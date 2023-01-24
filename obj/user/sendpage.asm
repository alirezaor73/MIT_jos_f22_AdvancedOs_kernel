
obj/user/sendpage:     file format elf64-x86-64


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
  80003c:	e8 66 02 00 00       	callq  8002a7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800052:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 85 09 01 00 00    	jne    800175 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 98 21 80 00 00 	movabs $0x802198,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf 2c 26 80 00 00 	movabs $0x80262c,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 74 04 80 00 00 	movabs $0x800474,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf 48 26 80 00 00 	movabs $0x802648,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 74 04 80 00 00 	movabs $0x800474,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 77 14 80 00 00 	movabs $0x801477,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 77 14 80 00 00 	movabs $0x801477,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 98 21 80 00 00 	movabs $0x802198,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf 2c 26 80 00 00 	movabs $0x80262c,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 74 04 80 00 00 	movabs $0x800474,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf 68 26 80 00 00 	movabs $0x802668,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 74 04 80 00 00 	movabs $0x800474,%rdx
  80029f:	00 00 00 
  8002a2:	ff d2                	callq  *%rdx
	return;
  8002a4:	90                   	nop
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 20          	sub    $0x20,%rsp
  8002af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8002b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8002b6:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8002c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002cd:	48 63 d0             	movslq %eax,%rdx
  8002d0:	48 89 d0             	mov    %rdx,%rax
  8002d3:	48 c1 e0 03          	shl    $0x3,%rax
  8002d7:	48 01 d0             	add    %rdx,%rax
  8002da:	48 c1 e0 05          	shl    $0x5,%rax
  8002de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002e5:	00 00 00 
  8002e8:	48 01 c2             	add    %rax,%rdx
  8002eb:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8002f2:	00 00 00 
  8002f5:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8002fc:	7e 14                	jle    800312 <libmain+0x6b>
		binaryname = argv[0];
  8002fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800302:	48 8b 10             	mov    (%rax),%rdx
  800305:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80030c:	00 00 00 
  80030f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800312:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800316:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800319:	48 89 d6             	mov    %rdx,%rsi
  80031c:	89 c7                	mov    %eax,%edi
  80031e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80032a:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80033c:	bf 00 00 00 00       	mov    $0x0,%edi
  800341:	48 b8 ab 18 80 00 00 	movabs $0x8018ab,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax
}
  80034d:	5d                   	pop    %rbp
  80034e:	c3                   	retq   

000000000080034f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80034f:	55                   	push   %rbp
  800350:	48 89 e5             	mov    %rsp,%rbp
  800353:	48 83 ec 10          	sub    $0x10,%rsp
  800357:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80035e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800362:	8b 00                	mov    (%rax),%eax
  800364:	8d 48 01             	lea    0x1(%rax),%ecx
  800367:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036b:	89 0a                	mov    %ecx,(%rdx)
  80036d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800370:	89 d1                	mov    %edx,%ecx
  800372:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800376:	48 98                	cltq   
  800378:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80037c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800380:	8b 00                	mov    (%rax),%eax
  800382:	3d ff 00 00 00       	cmp    $0xff,%eax
  800387:	75 2c                	jne    8003b5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038d:	8b 00                	mov    (%rax),%eax
  80038f:	48 98                	cltq   
  800391:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800395:	48 83 c2 08          	add    $0x8,%rdx
  800399:	48 89 c6             	mov    %rax,%rsi
  80039c:	48 89 d7             	mov    %rdx,%rdi
  80039f:	48 b8 23 18 80 00 00 	movabs $0x801823,%rax
  8003a6:	00 00 00 
  8003a9:	ff d0                	callq  *%rax
        b->idx = 0;
  8003ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003af:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b9:	8b 40 04             	mov    0x4(%rax),%eax
  8003bc:	8d 50 01             	lea    0x1(%rax),%edx
  8003bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003c6:	c9                   	leaveq 
  8003c7:	c3                   	retq   

00000000008003c8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003d3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003da:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003e1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003e8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003ef:	48 8b 0a             	mov    (%rdx),%rcx
  8003f2:	48 89 08             	mov    %rcx,(%rax)
  8003f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800401:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800405:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80040c:	00 00 00 
    b.cnt = 0;
  80040f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800416:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800419:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800420:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800427:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80042e:	48 89 c6             	mov    %rax,%rsi
  800431:	48 bf 4f 03 80 00 00 	movabs $0x80034f,%rdi
  800438:	00 00 00 
  80043b:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800442:	00 00 00 
  800445:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800447:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80044d:	48 98                	cltq   
  80044f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800456:	48 83 c2 08          	add    $0x8,%rdx
  80045a:	48 89 c6             	mov    %rax,%rsi
  80045d:	48 89 d7             	mov    %rdx,%rdi
  800460:	48 b8 23 18 80 00 00 	movabs $0x801823,%rax
  800467:	00 00 00 
  80046a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80046c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800472:	c9                   	leaveq 
  800473:	c3                   	retq   

0000000000800474 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800474:	55                   	push   %rbp
  800475:	48 89 e5             	mov    %rsp,%rbp
  800478:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80047f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800486:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80048d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800494:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80049b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004a2:	84 c0                	test   %al,%al
  8004a4:	74 20                	je     8004c6 <cprintf+0x52>
  8004a6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004aa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004b2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004b6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004ba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004be:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004c2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004c6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004cd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004d4:	00 00 00 
  8004d7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004de:	00 00 00 
  8004e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004f3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004fa:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800501:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800508:	48 8b 0a             	mov    (%rdx),%rcx
  80050b:	48 89 08             	mov    %rcx,(%rax)
  80050e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800512:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800516:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80051a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80051e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800525:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80052c:	48 89 d6             	mov    %rdx,%rsi
  80052f:	48 89 c7             	mov    %rax,%rdi
  800532:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  800539:	00 00 00 
  80053c:	ff d0                	callq  *%rax
  80053e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800544:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80054a:	c9                   	leaveq 
  80054b:	c3                   	retq   

000000000080054c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80054c:	55                   	push   %rbp
  80054d:	48 89 e5             	mov    %rsp,%rbp
  800550:	53                   	push   %rbx
  800551:	48 83 ec 38          	sub    $0x38,%rsp
  800555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800559:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80055d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800561:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800564:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800568:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80056c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80056f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800573:	77 3b                	ja     8005b0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800575:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800578:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80057c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80057f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800583:	ba 00 00 00 00       	mov    $0x0,%edx
  800588:	48 f7 f3             	div    %rbx
  80058b:	48 89 c2             	mov    %rax,%rdx
  80058e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800591:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800594:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	41 89 f9             	mov    %edi,%r9d
  80059f:	48 89 c7             	mov    %rax,%rdi
  8005a2:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
  8005ae:	eb 1e                	jmp    8005ce <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b0:	eb 12                	jmp    8005c4 <printnum+0x78>
			putch(padc, putdat);
  8005b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005b6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bd:	48 89 ce             	mov    %rcx,%rsi
  8005c0:	89 d7                	mov    %edx,%edi
  8005c2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005c8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005cc:	7f e4                	jg     8005b2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ce:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005da:	48 f7 f1             	div    %rcx
  8005dd:	48 89 d0             	mov    %rdx,%rax
  8005e0:	48 ba f0 27 80 00 00 	movabs $0x8027f0,%rdx
  8005e7:	00 00 00 
  8005ea:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005ee:	0f be d0             	movsbl %al,%edx
  8005f1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 89 ce             	mov    %rcx,%rsi
  8005fc:	89 d7                	mov    %edx,%edi
  8005fe:	ff d0                	callq  *%rax
}
  800600:	48 83 c4 38          	add    $0x38,%rsp
  800604:	5b                   	pop    %rbx
  800605:	5d                   	pop    %rbp
  800606:	c3                   	retq   

0000000000800607 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800607:	55                   	push   %rbp
  800608:	48 89 e5             	mov    %rsp,%rbp
  80060b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80060f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800613:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800616:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80061a:	7e 52                	jle    80066e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80061c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800620:	8b 00                	mov    (%rax),%eax
  800622:	83 f8 30             	cmp    $0x30,%eax
  800625:	73 24                	jae    80064b <getuint+0x44>
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	8b 00                	mov    (%rax),%eax
  800635:	89 c0                	mov    %eax,%eax
  800637:	48 01 d0             	add    %rdx,%rax
  80063a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063e:	8b 12                	mov    (%rdx),%edx
  800640:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800647:	89 0a                	mov    %ecx,(%rdx)
  800649:	eb 17                	jmp    800662 <getuint+0x5b>
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800653:	48 89 d0             	mov    %rdx,%rax
  800656:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800662:	48 8b 00             	mov    (%rax),%rax
  800665:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800669:	e9 a3 00 00 00       	jmpq   800711 <getuint+0x10a>
	else if (lflag)
  80066e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800672:	74 4f                	je     8006c3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	83 f8 30             	cmp    $0x30,%eax
  80067d:	73 24                	jae    8006a3 <getuint+0x9c>
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	89 c0                	mov    %eax,%eax
  80068f:	48 01 d0             	add    %rdx,%rax
  800692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800696:	8b 12                	mov    (%rdx),%edx
  800698:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	89 0a                	mov    %ecx,(%rdx)
  8006a1:	eb 17                	jmp    8006ba <getuint+0xb3>
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ab:	48 89 d0             	mov    %rdx,%rax
  8006ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ba:	48 8b 00             	mov    (%rax),%rax
  8006bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c1:	eb 4e                	jmp    800711 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	8b 00                	mov    (%rax),%eax
  8006c9:	83 f8 30             	cmp    $0x30,%eax
  8006cc:	73 24                	jae    8006f2 <getuint+0xeb>
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	89 c0                	mov    %eax,%eax
  8006de:	48 01 d0             	add    %rdx,%rax
  8006e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e5:	8b 12                	mov    (%rdx),%edx
  8006e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ee:	89 0a                	mov    %ecx,(%rdx)
  8006f0:	eb 17                	jmp    800709 <getuint+0x102>
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006fa:	48 89 d0             	mov    %rdx,%rax
  8006fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800709:	8b 00                	mov    (%rax),%eax
  80070b:	89 c0                	mov    %eax,%eax
  80070d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800711:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800715:	c9                   	leaveq 
  800716:	c3                   	retq   

0000000000800717 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800717:	55                   	push   %rbp
  800718:	48 89 e5             	mov    %rsp,%rbp
  80071b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80071f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800723:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800726:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80072a:	7e 52                	jle    80077e <getint+0x67>
		x=va_arg(*ap, long long);
  80072c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800730:	8b 00                	mov    (%rax),%eax
  800732:	83 f8 30             	cmp    $0x30,%eax
  800735:	73 24                	jae    80075b <getint+0x44>
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800743:	8b 00                	mov    (%rax),%eax
  800745:	89 c0                	mov    %eax,%eax
  800747:	48 01 d0             	add    %rdx,%rax
  80074a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074e:	8b 12                	mov    (%rdx),%edx
  800750:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800757:	89 0a                	mov    %ecx,(%rdx)
  800759:	eb 17                	jmp    800772 <getint+0x5b>
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800763:	48 89 d0             	mov    %rdx,%rax
  800766:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800772:	48 8b 00             	mov    (%rax),%rax
  800775:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800779:	e9 a3 00 00 00       	jmpq   800821 <getint+0x10a>
	else if (lflag)
  80077e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800782:	74 4f                	je     8007d3 <getint+0xbc>
		x=va_arg(*ap, long);
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	83 f8 30             	cmp    $0x30,%eax
  80078d:	73 24                	jae    8007b3 <getint+0x9c>
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	8b 00                	mov    (%rax),%eax
  80079d:	89 c0                	mov    %eax,%eax
  80079f:	48 01 d0             	add    %rdx,%rax
  8007a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a6:	8b 12                	mov    (%rdx),%edx
  8007a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	89 0a                	mov    %ecx,(%rdx)
  8007b1:	eb 17                	jmp    8007ca <getint+0xb3>
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007bb:	48 89 d0             	mov    %rdx,%rax
  8007be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ca:	48 8b 00             	mov    (%rax),%rax
  8007cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d1:	eb 4e                	jmp    800821 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d7:	8b 00                	mov    (%rax),%eax
  8007d9:	83 f8 30             	cmp    $0x30,%eax
  8007dc:	73 24                	jae    800802 <getint+0xeb>
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	8b 00                	mov    (%rax),%eax
  8007ec:	89 c0                	mov    %eax,%eax
  8007ee:	48 01 d0             	add    %rdx,%rax
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	8b 12                	mov    (%rdx),%edx
  8007f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fe:	89 0a                	mov    %ecx,(%rdx)
  800800:	eb 17                	jmp    800819 <getint+0x102>
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80080a:	48 89 d0             	mov    %rdx,%rax
  80080d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800815:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800819:	8b 00                	mov    (%rax),%eax
  80081b:	48 98                	cltq   
  80081d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800821:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800825:	c9                   	leaveq 
  800826:	c3                   	retq   

0000000000800827 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800827:	55                   	push   %rbp
  800828:	48 89 e5             	mov    %rsp,%rbp
  80082b:	41 54                	push   %r12
  80082d:	53                   	push   %rbx
  80082e:	48 83 ec 60          	sub    $0x60,%rsp
  800832:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800836:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80083a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80083e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800842:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800846:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80084a:	48 8b 0a             	mov    (%rdx),%rcx
  80084d:	48 89 08             	mov    %rcx,(%rax)
  800850:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800854:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800858:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80085c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800860:	eb 17                	jmp    800879 <vprintfmt+0x52>
			if (ch == '\0')
  800862:	85 db                	test   %ebx,%ebx
  800864:	0f 84 df 04 00 00    	je     800d49 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80086a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80086e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800872:	48 89 d6             	mov    %rdx,%rsi
  800875:	89 df                	mov    %ebx,%edi
  800877:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800879:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80087d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800881:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800885:	0f b6 00             	movzbl (%rax),%eax
  800888:	0f b6 d8             	movzbl %al,%ebx
  80088b:	83 fb 25             	cmp    $0x25,%ebx
  80088e:	75 d2                	jne    800862 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800890:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800894:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80089b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008bc:	0f b6 00             	movzbl (%rax),%eax
  8008bf:	0f b6 d8             	movzbl %al,%ebx
  8008c2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008c5:	83 f8 55             	cmp    $0x55,%eax
  8008c8:	0f 87 47 04 00 00    	ja     800d15 <vprintfmt+0x4ee>
  8008ce:	89 c0                	mov    %eax,%eax
  8008d0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008d7:	00 
  8008d8:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  8008df:	00 00 00 
  8008e2:	48 01 d0             	add    %rdx,%rax
  8008e5:	48 8b 00             	mov    (%rax),%rax
  8008e8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008ea:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008ee:	eb c0                	jmp    8008b0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008f4:	eb ba                	jmp    8008b0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008fd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800900:	89 d0                	mov    %edx,%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	01 c0                	add    %eax,%eax
  800909:	01 d8                	add    %ebx,%eax
  80090b:	83 e8 30             	sub    $0x30,%eax
  80090e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800911:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800915:	0f b6 00             	movzbl (%rax),%eax
  800918:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091b:	83 fb 2f             	cmp    $0x2f,%ebx
  80091e:	7e 0c                	jle    80092c <vprintfmt+0x105>
  800920:	83 fb 39             	cmp    $0x39,%ebx
  800923:	7f 07                	jg     80092c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800925:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80092a:	eb d1                	jmp    8008fd <vprintfmt+0xd6>
			goto process_precision;
  80092c:	eb 58                	jmp    800986 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80092e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800931:	83 f8 30             	cmp    $0x30,%eax
  800934:	73 17                	jae    80094d <vprintfmt+0x126>
  800936:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80093a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093d:	89 c0                	mov    %eax,%eax
  80093f:	48 01 d0             	add    %rdx,%rax
  800942:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800945:	83 c2 08             	add    $0x8,%edx
  800948:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80094b:	eb 0f                	jmp    80095c <vprintfmt+0x135>
  80094d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800951:	48 89 d0             	mov    %rdx,%rax
  800954:	48 83 c2 08          	add    $0x8,%rdx
  800958:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800961:	eb 23                	jmp    800986 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800963:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800967:	79 0c                	jns    800975 <vprintfmt+0x14e>
				width = 0;
  800969:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800970:	e9 3b ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>
  800975:	e9 36 ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80097a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800981:	e9 2a ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800986:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098a:	79 12                	jns    80099e <vprintfmt+0x177>
				width = precision, precision = -1;
  80098c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80098f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800992:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800999:	e9 12 ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>
  80099e:	e9 0d ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009a7:	e9 04 ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009af:	83 f8 30             	cmp    $0x30,%eax
  8009b2:	73 17                	jae    8009cb <vprintfmt+0x1a4>
  8009b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bb:	89 c0                	mov    %eax,%eax
  8009bd:	48 01 d0             	add    %rdx,%rax
  8009c0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c3:	83 c2 08             	add    $0x8,%edx
  8009c6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c9:	eb 0f                	jmp    8009da <vprintfmt+0x1b3>
  8009cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009cf:	48 89 d0             	mov    %rdx,%rax
  8009d2:	48 83 c2 08          	add    $0x8,%rdx
  8009d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009da:	8b 10                	mov    (%rax),%edx
  8009dc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e4:	48 89 ce             	mov    %rcx,%rsi
  8009e7:	89 d7                	mov    %edx,%edi
  8009e9:	ff d0                	callq  *%rax
			break;
  8009eb:	e9 53 03 00 00       	jmpq   800d43 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	83 f8 30             	cmp    $0x30,%eax
  8009f6:	73 17                	jae    800a0f <vprintfmt+0x1e8>
  8009f8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ff:	89 c0                	mov    %eax,%eax
  800a01:	48 01 d0             	add    %rdx,%rax
  800a04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a07:	83 c2 08             	add    $0x8,%edx
  800a0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0d:	eb 0f                	jmp    800a1e <vprintfmt+0x1f7>
  800a0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a13:	48 89 d0             	mov    %rdx,%rax
  800a16:	48 83 c2 08          	add    $0x8,%rdx
  800a1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a20:	85 db                	test   %ebx,%ebx
  800a22:	79 02                	jns    800a26 <vprintfmt+0x1ff>
				err = -err;
  800a24:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a26:	83 fb 15             	cmp    $0x15,%ebx
  800a29:	7f 16                	jg     800a41 <vprintfmt+0x21a>
  800a2b:	48 b8 40 27 80 00 00 	movabs $0x802740,%rax
  800a32:	00 00 00 
  800a35:	48 63 d3             	movslq %ebx,%rdx
  800a38:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a3c:	4d 85 e4             	test   %r12,%r12
  800a3f:	75 2e                	jne    800a6f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a49:	89 d9                	mov    %ebx,%ecx
  800a4b:	48 ba 01 28 80 00 00 	movabs $0x802801,%rdx
  800a52:	00 00 00 
  800a55:	48 89 c7             	mov    %rax,%rdi
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5d:	49 b8 52 0d 80 00 00 	movabs $0x800d52,%r8
  800a64:	00 00 00 
  800a67:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a6a:	e9 d4 02 00 00       	jmpq   800d43 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a6f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a77:	4c 89 e1             	mov    %r12,%rcx
  800a7a:	48 ba 0a 28 80 00 00 	movabs $0x80280a,%rdx
  800a81:	00 00 00 
  800a84:	48 89 c7             	mov    %rax,%rdi
  800a87:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8c:	49 b8 52 0d 80 00 00 	movabs $0x800d52,%r8
  800a93:	00 00 00 
  800a96:	41 ff d0             	callq  *%r8
			break;
  800a99:	e9 a5 02 00 00       	jmpq   800d43 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa1:	83 f8 30             	cmp    $0x30,%eax
  800aa4:	73 17                	jae    800abd <vprintfmt+0x296>
  800aa6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aaa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aad:	89 c0                	mov    %eax,%eax
  800aaf:	48 01 d0             	add    %rdx,%rax
  800ab2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab5:	83 c2 08             	add    $0x8,%edx
  800ab8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800abb:	eb 0f                	jmp    800acc <vprintfmt+0x2a5>
  800abd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac1:	48 89 d0             	mov    %rdx,%rax
  800ac4:	48 83 c2 08          	add    $0x8,%rdx
  800ac8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800acc:	4c 8b 20             	mov    (%rax),%r12
  800acf:	4d 85 e4             	test   %r12,%r12
  800ad2:	75 0a                	jne    800ade <vprintfmt+0x2b7>
				p = "(null)";
  800ad4:	49 bc 0d 28 80 00 00 	movabs $0x80280d,%r12
  800adb:	00 00 00 
			if (width > 0 && padc != '-')
  800ade:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae2:	7e 3f                	jle    800b23 <vprintfmt+0x2fc>
  800ae4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ae8:	74 39                	je     800b23 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aed:	48 98                	cltq   
  800aef:	48 89 c6             	mov    %rax,%rsi
  800af2:	4c 89 e7             	mov    %r12,%rdi
  800af5:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  800afc:	00 00 00 
  800aff:	ff d0                	callq  *%rax
  800b01:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b04:	eb 17                	jmp    800b1d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b06:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b0a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b12:	48 89 ce             	mov    %rcx,%rsi
  800b15:	89 d7                	mov    %edx,%edi
  800b17:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b19:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b21:	7f e3                	jg     800b06 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b23:	eb 37                	jmp    800b5c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b25:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b29:	74 1e                	je     800b49 <vprintfmt+0x322>
  800b2b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b2e:	7e 05                	jle    800b35 <vprintfmt+0x30e>
  800b30:	83 fb 7e             	cmp    $0x7e,%ebx
  800b33:	7e 14                	jle    800b49 <vprintfmt+0x322>
					putch('?', putdat);
  800b35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3d:	48 89 d6             	mov    %rdx,%rsi
  800b40:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b45:	ff d0                	callq  *%rax
  800b47:	eb 0f                	jmp    800b58 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b51:	48 89 d6             	mov    %rdx,%rsi
  800b54:	89 df                	mov    %ebx,%edi
  800b56:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b58:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5c:	4c 89 e0             	mov    %r12,%rax
  800b5f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b63:	0f b6 00             	movzbl (%rax),%eax
  800b66:	0f be d8             	movsbl %al,%ebx
  800b69:	85 db                	test   %ebx,%ebx
  800b6b:	74 10                	je     800b7d <vprintfmt+0x356>
  800b6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b71:	78 b2                	js     800b25 <vprintfmt+0x2fe>
  800b73:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b77:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b7b:	79 a8                	jns    800b25 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	eb 16                	jmp    800b95 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b87:	48 89 d6             	mov    %rdx,%rsi
  800b8a:	bf 20 00 00 00       	mov    $0x20,%edi
  800b8f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b95:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b99:	7f e4                	jg     800b7f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b9b:	e9 a3 01 00 00       	jmpq   800d43 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ba0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ba4:	be 03 00 00 00       	mov    $0x3,%esi
  800ba9:	48 89 c7             	mov    %rax,%rdi
  800bac:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  800bb3:	00 00 00 
  800bb6:	ff d0                	callq  *%rax
  800bb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc0:	48 85 c0             	test   %rax,%rax
  800bc3:	79 1d                	jns    800be2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bd5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdb:	48 f7 d8             	neg    %rax
  800bde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800be2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be9:	e9 e8 00 00 00       	jmpq   800cd6 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf2:	be 03 00 00 00       	mov    $0x3,%esi
  800bf7:	48 89 c7             	mov    %rax,%rdi
  800bfa:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  800c01:	00 00 00 
  800c04:	ff d0                	callq  *%rax
  800c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c11:	e9 c0 00 00 00       	jmpq   800cd6 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	48 89 d6             	mov    %rdx,%rsi
  800c21:	bf 58 00 00 00       	mov    $0x58,%edi
  800c26:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c30:	48 89 d6             	mov    %rdx,%rsi
  800c33:	bf 58 00 00 00       	mov    $0x58,%edi
  800c38:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c42:	48 89 d6             	mov    %rdx,%rsi
  800c45:	bf 58 00 00 00       	mov    $0x58,%edi
  800c4a:	ff d0                	callq  *%rax
			break;
  800c4c:	e9 f2 00 00 00       	jmpq   800d43 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c59:	48 89 d6             	mov    %rdx,%rsi
  800c5c:	bf 30 00 00 00       	mov    $0x30,%edi
  800c61:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 d6             	mov    %rdx,%rsi
  800c6e:	bf 78 00 00 00       	mov    $0x78,%edi
  800c73:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c78:	83 f8 30             	cmp    $0x30,%eax
  800c7b:	73 17                	jae    800c94 <vprintfmt+0x46d>
  800c7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c84:	89 c0                	mov    %eax,%eax
  800c86:	48 01 d0             	add    %rdx,%rax
  800c89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8c:	83 c2 08             	add    $0x8,%edx
  800c8f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c92:	eb 0f                	jmp    800ca3 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800c94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c98:	48 89 d0             	mov    %rdx,%rax
  800c9b:	48 83 c2 08          	add    $0x8,%rdx
  800c9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800caa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cb1:	eb 23                	jmp    800cd6 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb7:	be 03 00 00 00       	mov    $0x3,%esi
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 07 06 80 00 00 	movabs $0x800607,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ccf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cdb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cde:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ce1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ce9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ced:	45 89 c1             	mov    %r8d,%r9d
  800cf0:	41 89 f8             	mov    %edi,%r8d
  800cf3:	48 89 c7             	mov    %rax,%rdi
  800cf6:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
			break;
  800d02:	eb 3f                	jmp    800d43 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	48 89 d6             	mov    %rdx,%rsi
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	ff d0                	callq  *%rax
			break;
  800d13:	eb 2e                	jmp    800d43 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	bf 25 00 00 00       	mov    $0x25,%edi
  800d25:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d2c:	eb 05                	jmp    800d33 <vprintfmt+0x50c>
  800d2e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d37:	48 83 e8 01          	sub    $0x1,%rax
  800d3b:	0f b6 00             	movzbl (%rax),%eax
  800d3e:	3c 25                	cmp    $0x25,%al
  800d40:	75 ec                	jne    800d2e <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d42:	90                   	nop
		}
	}
  800d43:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d44:	e9 30 fb ff ff       	jmpq   800879 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d49:	48 83 c4 60          	add    $0x60,%rsp
  800d4d:	5b                   	pop    %rbx
  800d4e:	41 5c                	pop    %r12
  800d50:	5d                   	pop    %rbp
  800d51:	c3                   	retq   

0000000000800d52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d52:	55                   	push   %rbp
  800d53:	48 89 e5             	mov    %rsp,%rbp
  800d56:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d5d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d64:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d6b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d72:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d79:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d80:	84 c0                	test   %al,%al
  800d82:	74 20                	je     800da4 <printfmt+0x52>
  800d84:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d88:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d8c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d90:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d94:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d98:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d9c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800da4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dab:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800db2:	00 00 00 
  800db5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dbc:	00 00 00 
  800dbf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ddf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800de6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ded:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800df4:	48 89 c7             	mov    %rax,%rdi
  800df7:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e03:	c9                   	leaveq 
  800e04:	c3                   	retq   

0000000000800e05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e05:	55                   	push   %rbp
  800e06:	48 89 e5             	mov    %rsp,%rbp
  800e09:	48 83 ec 10          	sub    $0x10,%rsp
  800e0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e18:	8b 40 10             	mov    0x10(%rax),%eax
  800e1b:	8d 50 01             	lea    0x1(%rax),%edx
  800e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e22:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e29:	48 8b 10             	mov    (%rax),%rdx
  800e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e30:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e34:	48 39 c2             	cmp    %rax,%rdx
  800e37:	73 17                	jae    800e50 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3d:	48 8b 00             	mov    (%rax),%rax
  800e40:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e48:	48 89 0a             	mov    %rcx,(%rdx)
  800e4b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e4e:	88 10                	mov    %dl,(%rax)
}
  800e50:	c9                   	leaveq 
  800e51:	c3                   	retq   

0000000000800e52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e52:	55                   	push   %rbp
  800e53:	48 89 e5             	mov    %rsp,%rbp
  800e56:	48 83 ec 50          	sub    $0x50,%rsp
  800e5a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e5e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e61:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e65:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e69:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e6d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e71:	48 8b 0a             	mov    (%rdx),%rcx
  800e74:	48 89 08             	mov    %rcx,(%rax)
  800e77:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e7b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e7f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e83:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e8b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e8f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e92:	48 98                	cltq   
  800e94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e9c:	48 01 d0             	add    %rdx,%rax
  800e9f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ea3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eaa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eaf:	74 06                	je     800eb7 <vsnprintf+0x65>
  800eb1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eb5:	7f 07                	jg     800ebe <vsnprintf+0x6c>
		return -E_INVAL;
  800eb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebc:	eb 2f                	jmp    800eed <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ebe:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ec2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ec6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eca:	48 89 c6             	mov    %rax,%rsi
  800ecd:	48 bf 05 0e 80 00 00 	movabs $0x800e05,%rdi
  800ed4:	00 00 00 
  800ed7:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ee3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ee7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eea:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eed:	c9                   	leaveq 
  800eee:	c3                   	retq   

0000000000800eef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eef:	55                   	push   %rbp
  800ef0:	48 89 e5             	mov    %rsp,%rbp
  800ef3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800efa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f01:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f07:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f0e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f15:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 20                	je     800f40 <snprintf+0x51>
  800f20:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f24:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f28:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f2c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f30:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f34:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f38:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f3c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f40:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f47:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f4e:	00 00 00 
  800f51:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f58:	00 00 00 
  800f5b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f5f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f66:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f6d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f74:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f7b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f82:	48 8b 0a             	mov    (%rdx),%rcx
  800f85:	48 89 08             	mov    %rcx,(%rax)
  800f88:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f8c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f90:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f94:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f98:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f9f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fa6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fb3:	48 89 c7             	mov    %rax,%rdi
  800fb6:	48 b8 52 0e 80 00 00 	movabs $0x800e52,%rax
  800fbd:	00 00 00 
  800fc0:	ff d0                	callq  *%rax
  800fc2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fc8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fce:	c9                   	leaveq 
  800fcf:	c3                   	retq   

0000000000800fd0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fd0:	55                   	push   %rbp
  800fd1:	48 89 e5             	mov    %rsp,%rbp
  800fd4:	48 83 ec 18          	sub    $0x18,%rsp
  800fd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fe3:	eb 09                	jmp    800fee <strlen+0x1e>
		n++;
  800fe5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	0f b6 00             	movzbl (%rax),%eax
  800ff5:	84 c0                	test   %al,%al
  800ff7:	75 ec                	jne    800fe5 <strlen+0x15>
		n++;
	return n;
  800ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ffc:	c9                   	leaveq 
  800ffd:	c3                   	retq   

0000000000800ffe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ffe:	55                   	push   %rbp
  800fff:	48 89 e5             	mov    %rsp,%rbp
  801002:	48 83 ec 20          	sub    $0x20,%rsp
  801006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801015:	eb 0e                	jmp    801025 <strnlen+0x27>
		n++;
  801017:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801020:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801025:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80102a:	74 0b                	je     801037 <strnlen+0x39>
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	84 c0                	test   %al,%al
  801035:	75 e0                	jne    801017 <strnlen+0x19>
		n++;
	return n;
  801037:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103a:	c9                   	leaveq 
  80103b:	c3                   	retq   

000000000080103c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	48 83 ec 20          	sub    $0x20,%rsp
  801044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80104c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801050:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801054:	90                   	nop
  801055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801059:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801061:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801065:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801069:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80106d:	0f b6 12             	movzbl (%rdx),%edx
  801070:	88 10                	mov    %dl,(%rax)
  801072:	0f b6 00             	movzbl (%rax),%eax
  801075:	84 c0                	test   %al,%al
  801077:	75 dc                	jne    801055 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80107d:	c9                   	leaveq 
  80107e:	c3                   	retq   

000000000080107f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80107f:	55                   	push   %rbp
  801080:	48 89 e5             	mov    %rsp,%rbp
  801083:	48 83 ec 20          	sub    $0x20,%rsp
  801087:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	48 89 c7             	mov    %rax,%rdi
  801096:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	callq  *%rax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a8:	48 63 d0             	movslq %eax,%rdx
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 01 c2             	add    %rax,%rdx
  8010b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010b6:	48 89 c6             	mov    %rax,%rsi
  8010b9:	48 89 d7             	mov    %rdx,%rdi
  8010bc:	48 b8 3c 10 80 00 00 	movabs $0x80103c,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
	return dst;
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010cc:	c9                   	leaveq 
  8010cd:	c3                   	retq   

00000000008010ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010ce:	55                   	push   %rbp
  8010cf:	48 89 e5             	mov    %rsp,%rbp
  8010d2:	48 83 ec 28          	sub    $0x28,%rsp
  8010d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010f1:	00 
  8010f2:	eb 2a                	jmp    80111e <strncpy+0x50>
		*dst++ = *src;
  8010f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801100:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801104:	0f b6 12             	movzbl (%rdx),%edx
  801107:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110d:	0f b6 00             	movzbl (%rax),%eax
  801110:	84 c0                	test   %al,%al
  801112:	74 05                	je     801119 <strncpy+0x4b>
			src++;
  801114:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801119:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801126:	72 cc                	jb     8010f4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80112c:	c9                   	leaveq 
  80112d:	c3                   	retq   

000000000080112e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 28          	sub    $0x28,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801146:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80114a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80114f:	74 3d                	je     80118e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801151:	eb 1d                	jmp    801170 <strlcpy+0x42>
			*dst++ = *src++;
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801157:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801163:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801167:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80116b:	0f b6 12             	movzbl (%rdx),%edx
  80116e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801170:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801175:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117a:	74 0b                	je     801187 <strlcpy+0x59>
  80117c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801180:	0f b6 00             	movzbl (%rax),%eax
  801183:	84 c0                	test   %al,%al
  801185:	75 cc                	jne    801153 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80118e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801196:	48 29 c2             	sub    %rax,%rdx
  801199:	48 89 d0             	mov    %rdx,%rax
}
  80119c:	c9                   	leaveq 
  80119d:	c3                   	retq   

000000000080119e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119e:	55                   	push   %rbp
  80119f:	48 89 e5             	mov    %rsp,%rbp
  8011a2:	48 83 ec 10          	sub    $0x10,%rsp
  8011a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ae:	eb 0a                	jmp    8011ba <strcmp+0x1c>
		p++, q++;
  8011b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	84 c0                	test   %al,%al
  8011c3:	74 12                	je     8011d7 <strcmp+0x39>
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	0f b6 10             	movzbl (%rax),%edx
  8011cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d0:	0f b6 00             	movzbl (%rax),%eax
  8011d3:	38 c2                	cmp    %al,%dl
  8011d5:	74 d9                	je     8011b0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011db:	0f b6 00             	movzbl (%rax),%eax
  8011de:	0f b6 d0             	movzbl %al,%edx
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	0f b6 00             	movzbl (%rax),%eax
  8011e8:	0f b6 c0             	movzbl %al,%eax
  8011eb:	29 c2                	sub    %eax,%edx
  8011ed:	89 d0                	mov    %edx,%eax
}
  8011ef:	c9                   	leaveq 
  8011f0:	c3                   	retq   

00000000008011f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	48 83 ec 18          	sub    $0x18,%rsp
  8011f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801201:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801205:	eb 0f                	jmp    801216 <strncmp+0x25>
		n--, p++, q++;
  801207:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80120c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801211:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801216:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80121b:	74 1d                	je     80123a <strncmp+0x49>
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	0f b6 00             	movzbl (%rax),%eax
  801224:	84 c0                	test   %al,%al
  801226:	74 12                	je     80123a <strncmp+0x49>
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	0f b6 10             	movzbl (%rax),%edx
  80122f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801233:	0f b6 00             	movzbl (%rax),%eax
  801236:	38 c2                	cmp    %al,%dl
  801238:	74 cd                	je     801207 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80123a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123f:	75 07                	jne    801248 <strncmp+0x57>
		return 0;
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
  801246:	eb 18                	jmp    801260 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	0f b6 00             	movzbl (%rax),%eax
  80124f:	0f b6 d0             	movzbl %al,%edx
  801252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801256:	0f b6 00             	movzbl (%rax),%eax
  801259:	0f b6 c0             	movzbl %al,%eax
  80125c:	29 c2                	sub    %eax,%edx
  80125e:	89 d0                	mov    %edx,%eax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 0c          	sub    $0xc,%rsp
  80126a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126e:	89 f0                	mov    %esi,%eax
  801270:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801273:	eb 17                	jmp    80128c <strchr+0x2a>
		if (*s == c)
  801275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80127f:	75 06                	jne    801287 <strchr+0x25>
			return (char *) s;
  801281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801285:	eb 15                	jmp    80129c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801287:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801290:	0f b6 00             	movzbl (%rax),%eax
  801293:	84 c0                	test   %al,%al
  801295:	75 de                	jne    801275 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129c:	c9                   	leaveq 
  80129d:	c3                   	retq   

000000000080129e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80129e:	55                   	push   %rbp
  80129f:	48 89 e5             	mov    %rsp,%rbp
  8012a2:	48 83 ec 0c          	sub    $0xc,%rsp
  8012a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012aa:	89 f0                	mov    %esi,%eax
  8012ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012af:	eb 13                	jmp    8012c4 <strfind+0x26>
		if (*s == c)
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b5:	0f b6 00             	movzbl (%rax),%eax
  8012b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012bb:	75 02                	jne    8012bf <strfind+0x21>
			break;
  8012bd:	eb 10                	jmp    8012cf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	75 e2                	jne    8012b1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d3:	c9                   	leaveq 
  8012d4:	c3                   	retq   

00000000008012d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012d5:	55                   	push   %rbp
  8012d6:	48 89 e5             	mov    %rsp,%rbp
  8012d9:	48 83 ec 18          	sub    $0x18,%rsp
  8012dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ed:	75 06                	jne    8012f5 <memset+0x20>
		return v;
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	eb 69                	jmp    80135e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	83 e0 03             	and    $0x3,%eax
  8012fc:	48 85 c0             	test   %rax,%rax
  8012ff:	75 48                	jne    801349 <memset+0x74>
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	83 e0 03             	and    $0x3,%eax
  801308:	48 85 c0             	test   %rax,%rax
  80130b:	75 3c                	jne    801349 <memset+0x74>
		c &= 0xFF;
  80130d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801314:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801317:	c1 e0 18             	shl    $0x18,%eax
  80131a:	89 c2                	mov    %eax,%edx
  80131c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131f:	c1 e0 10             	shl    $0x10,%eax
  801322:	09 c2                	or     %eax,%edx
  801324:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801327:	c1 e0 08             	shl    $0x8,%eax
  80132a:	09 d0                	or     %edx,%eax
  80132c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	48 c1 e8 02          	shr    $0x2,%rax
  801337:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80133a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801341:	48 89 d7             	mov    %rdx,%rdi
  801344:	fc                   	cld    
  801345:	f3 ab                	rep stos %eax,%es:(%rdi)
  801347:	eb 11                	jmp    80135a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801349:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801350:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801354:	48 89 d7             	mov    %rdx,%rdi
  801357:	fc                   	cld    
  801358:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 28          	sub    $0x28,%rsp
  801368:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801370:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801378:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801380:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80138c:	0f 83 88 00 00 00    	jae    80141a <memmove+0xba>
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139a:	48 01 d0             	add    %rdx,%rax
  80139d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a1:	76 77                	jbe    80141a <memmove+0xba>
		s += n;
  8013a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013af:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b7:	83 e0 03             	and    $0x3,%eax
  8013ba:	48 85 c0             	test   %rax,%rax
  8013bd:	75 3b                	jne    8013fa <memmove+0x9a>
  8013bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c3:	83 e0 03             	and    $0x3,%eax
  8013c6:	48 85 c0             	test   %rax,%rax
  8013c9:	75 2f                	jne    8013fa <memmove+0x9a>
  8013cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cf:	83 e0 03             	and    $0x3,%eax
  8013d2:	48 85 c0             	test   %rax,%rax
  8013d5:	75 23                	jne    8013fa <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013db:	48 83 e8 04          	sub    $0x4,%rax
  8013df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e3:	48 83 ea 04          	sub    $0x4,%rdx
  8013e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013eb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013ef:	48 89 c7             	mov    %rax,%rdi
  8013f2:	48 89 d6             	mov    %rdx,%rsi
  8013f5:	fd                   	std    
  8013f6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013f8:	eb 1d                	jmp    801417 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801406:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	48 89 d7             	mov    %rdx,%rdi
  801411:	48 89 c1             	mov    %rax,%rcx
  801414:	fd                   	std    
  801415:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801417:	fc                   	cld    
  801418:	eb 57                	jmp    801471 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80141a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141e:	83 e0 03             	and    $0x3,%eax
  801421:	48 85 c0             	test   %rax,%rax
  801424:	75 36                	jne    80145c <memmove+0xfc>
  801426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142a:	83 e0 03             	and    $0x3,%eax
  80142d:	48 85 c0             	test   %rax,%rax
  801430:	75 2a                	jne    80145c <memmove+0xfc>
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 1e                	jne    80145c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	48 c1 e8 02          	shr    $0x2,%rax
  801446:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801451:	48 89 c7             	mov    %rax,%rdi
  801454:	48 89 d6             	mov    %rdx,%rsi
  801457:	fc                   	cld    
  801458:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145a:	eb 15                	jmp    801471 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80145c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801460:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801464:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801468:	48 89 c7             	mov    %rax,%rdi
  80146b:	48 89 d6             	mov    %rdx,%rsi
  80146e:	fc                   	cld    
  80146f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801475:	c9                   	leaveq 
  801476:	c3                   	retq   

0000000000801477 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801477:	55                   	push   %rbp
  801478:	48 89 e5             	mov    %rsp,%rbp
  80147b:	48 83 ec 18          	sub    $0x18,%rsp
  80147f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801483:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801487:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80148b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80148f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	48 89 ce             	mov    %rcx,%rsi
  80149a:	48 89 c7             	mov    %rax,%rdi
  80149d:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	callq  *%rax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 28          	sub    $0x28,%rsp
  8014b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014cf:	eb 36                	jmp    801507 <memcmp+0x5c>
		if (*s1 != *s2)
  8014d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d5:	0f b6 10             	movzbl (%rax),%edx
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	38 c2                	cmp    %al,%dl
  8014e1:	74 1a                	je     8014fd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e7:	0f b6 00             	movzbl (%rax),%eax
  8014ea:	0f b6 d0             	movzbl %al,%edx
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	0f b6 c0             	movzbl %al,%eax
  8014f7:	29 c2                	sub    %eax,%edx
  8014f9:	89 d0                	mov    %edx,%eax
  8014fb:	eb 20                	jmp    80151d <memcmp+0x72>
		s1++, s2++;
  8014fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801502:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801513:	48 85 c0             	test   %rax,%rax
  801516:	75 b9                	jne    8014d1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leaveq 
  80151e:	c3                   	retq   

000000000080151f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80151f:	55                   	push   %rbp
  801520:	48 89 e5             	mov    %rsp,%rbp
  801523:	48 83 ec 28          	sub    $0x28,%rsp
  801527:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80152e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80153a:	48 01 d0             	add    %rdx,%rax
  80153d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801541:	eb 15                	jmp    801558 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801547:	0f b6 10             	movzbl (%rax),%edx
  80154a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80154d:	38 c2                	cmp    %al,%dl
  80154f:	75 02                	jne    801553 <memfind+0x34>
			break;
  801551:	eb 0f                	jmp    801562 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801553:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801560:	72 e1                	jb     801543 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 34          	sub    $0x34,%rsp
  801570:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801574:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801578:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80157b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801582:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801589:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80158a:	eb 05                	jmp    801591 <strtol+0x29>
		s++;
  80158c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801591:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801595:	0f b6 00             	movzbl (%rax),%eax
  801598:	3c 20                	cmp    $0x20,%al
  80159a:	74 f0                	je     80158c <strtol+0x24>
  80159c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a0:	0f b6 00             	movzbl (%rax),%eax
  8015a3:	3c 09                	cmp    $0x9,%al
  8015a5:	74 e5                	je     80158c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ab:	0f b6 00             	movzbl (%rax),%eax
  8015ae:	3c 2b                	cmp    $0x2b,%al
  8015b0:	75 07                	jne    8015b9 <strtol+0x51>
		s++;
  8015b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b7:	eb 17                	jmp    8015d0 <strtol+0x68>
	else if (*s == '-')
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	3c 2d                	cmp    $0x2d,%al
  8015c2:	75 0c                	jne    8015d0 <strtol+0x68>
		s++, neg = 1;
  8015c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015d4:	74 06                	je     8015dc <strtol+0x74>
  8015d6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015da:	75 28                	jne    801604 <strtol+0x9c>
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	3c 30                	cmp    $0x30,%al
  8015e5:	75 1d                	jne    801604 <strtol+0x9c>
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	48 83 c0 01          	add    $0x1,%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	3c 78                	cmp    $0x78,%al
  8015f4:	75 0e                	jne    801604 <strtol+0x9c>
		s += 2, base = 16;
  8015f6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015fb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801602:	eb 2c                	jmp    801630 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801604:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801608:	75 19                	jne    801623 <strtol+0xbb>
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	3c 30                	cmp    $0x30,%al
  801613:	75 0e                	jne    801623 <strtol+0xbb>
		s++, base = 8;
  801615:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801621:	eb 0d                	jmp    801630 <strtol+0xc8>
	else if (base == 0)
  801623:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801627:	75 07                	jne    801630 <strtol+0xc8>
		base = 10;
  801629:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	3c 2f                	cmp    $0x2f,%al
  801639:	7e 1d                	jle    801658 <strtol+0xf0>
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	0f b6 00             	movzbl (%rax),%eax
  801642:	3c 39                	cmp    $0x39,%al
  801644:	7f 12                	jg     801658 <strtol+0xf0>
			dig = *s - '0';
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	0f be c0             	movsbl %al,%eax
  801650:	83 e8 30             	sub    $0x30,%eax
  801653:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801656:	eb 4e                	jmp    8016a6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 60                	cmp    $0x60,%al
  801661:	7e 1d                	jle    801680 <strtol+0x118>
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 7a                	cmp    $0x7a,%al
  80166c:	7f 12                	jg     801680 <strtol+0x118>
			dig = *s - 'a' + 10;
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	0f be c0             	movsbl %al,%eax
  801678:	83 e8 57             	sub    $0x57,%eax
  80167b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167e:	eb 26                	jmp    8016a6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	3c 40                	cmp    $0x40,%al
  801689:	7e 48                	jle    8016d3 <strtol+0x16b>
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	3c 5a                	cmp    $0x5a,%al
  801694:	7f 3d                	jg     8016d3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016ac:	7c 02                	jl     8016b0 <strtol+0x148>
			break;
  8016ae:	eb 23                	jmp    8016d3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016b8:	48 98                	cltq   
  8016ba:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016bf:	48 89 c2             	mov    %rax,%rdx
  8016c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c5:	48 98                	cltq   
  8016c7:	48 01 d0             	add    %rdx,%rax
  8016ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016ce:	e9 5d ff ff ff       	jmpq   801630 <strtol+0xc8>

	if (endptr)
  8016d3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016d8:	74 0b                	je     8016e5 <strtol+0x17d>
		*endptr = (char *) s;
  8016da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016e2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016e9:	74 09                	je     8016f4 <strtol+0x18c>
  8016eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ef:	48 f7 d8             	neg    %rax
  8016f2:	eb 04                	jmp    8016f8 <strtol+0x190>
  8016f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016f8:	c9                   	leaveq 
  8016f9:	c3                   	retq   

00000000008016fa <strstr>:

char * strstr(const char *in, const char *str)
{
  8016fa:	55                   	push   %rbp
  8016fb:	48 89 e5             	mov    %rsp,%rbp
  8016fe:	48 83 ec 30          	sub    $0x30,%rsp
  801702:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801706:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80170a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801712:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80171c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801720:	75 06                	jne    801728 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	eb 6b                	jmp    801793 <strstr+0x99>

	len = strlen(str);
  801728:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172c:	48 89 c7             	mov    %rax,%rdi
  80172f:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  801736:	00 00 00 
  801739:	ff d0                	callq  *%rax
  80173b:	48 98                	cltq   
  80173d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801745:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801749:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80174d:	0f b6 00             	movzbl (%rax),%eax
  801750:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801753:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801757:	75 07                	jne    801760 <strstr+0x66>
				return (char *) 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
  80175e:	eb 33                	jmp    801793 <strstr+0x99>
		} while (sc != c);
  801760:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801764:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801767:	75 d8                	jne    801741 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801769:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80176d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	48 89 ce             	mov    %rcx,%rsi
  801778:	48 89 c7             	mov    %rax,%rdi
  80177b:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  801782:	00 00 00 
  801785:	ff d0                	callq  *%rax
  801787:	85 c0                	test   %eax,%eax
  801789:	75 b6                	jne    801741 <strstr+0x47>

	return (char *) (in - 1);
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	48 83 e8 01          	sub    $0x1,%rax
}
  801793:	c9                   	leaveq 
  801794:	c3                   	retq   

0000000000801795 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	53                   	push   %rbx
  80179a:	48 83 ec 48          	sub    $0x48,%rsp
  80179e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017a1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017a4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017a8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017ac:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017b0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017b7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017bb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017bf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017c3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017c7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017cb:	4c 89 c3             	mov    %r8,%rbx
  8017ce:	cd 30                	int    $0x30
  8017d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017d8:	74 3e                	je     801818 <syscall+0x83>
  8017da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017df:	7e 37                	jle    801818 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e8:	49 89 d0             	mov    %rdx,%r8
  8017eb:	89 c1                	mov    %eax,%ecx
  8017ed:	48 ba c8 2a 80 00 00 	movabs $0x802ac8,%rdx
  8017f4:	00 00 00 
  8017f7:	be 23 00 00 00       	mov    $0x23,%esi
  8017fc:	48 bf e5 2a 80 00 00 	movabs $0x802ae5,%rdi
  801803:	00 00 00 
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	49 b9 73 23 80 00 00 	movabs $0x802373,%r9
  801812:	00 00 00 
  801815:	41 ff d1             	callq  *%r9

	return ret;
  801818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80181c:	48 83 c4 48          	add    $0x48,%rsp
  801820:	5b                   	pop    %rbx
  801821:	5d                   	pop    %rbp
  801822:	c3                   	retq   

0000000000801823 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 20          	sub    $0x20,%rsp
  80182b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80182f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801833:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801837:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80183b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801842:	00 
  801843:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801849:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184f:	48 89 d1             	mov    %rdx,%rcx
  801852:	48 89 c2             	mov    %rax,%rdx
  801855:	be 00 00 00 00       	mov    $0x0,%esi
  80185a:	bf 00 00 00 00       	mov    $0x0,%edi
  80185f:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
}
  80186b:	c9                   	leaveq 
  80186c:	c3                   	retq   

000000000080186d <sys_cgetc>:

int
sys_cgetc(void)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801875:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187c:	00 
  80187d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801883:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801889:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	be 00 00 00 00       	mov    $0x0,%esi
  801898:	bf 01 00 00 00       	mov    $0x1,%edi
  80189d:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8018a4:	00 00 00 
  8018a7:	ff d0                	callq  *%rax
}
  8018a9:	c9                   	leaveq 
  8018aa:	c3                   	retq   

00000000008018ab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018ab:	55                   	push   %rbp
  8018ac:	48 89 e5             	mov    %rsp,%rbp
  8018af:	48 83 ec 10          	sub    $0x10,%rsp
  8018b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b9:	48 98                	cltq   
  8018bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c2:	00 
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d4:	48 89 c2             	mov    %rax,%rdx
  8018d7:	be 01 00 00 00       	mov    $0x1,%esi
  8018dc:	bf 03 00 00 00       	mov    $0x3,%edi
  8018e1:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8018e8:	00 00 00 
  8018eb:	ff d0                	callq  *%rax
}
  8018ed:	c9                   	leaveq 
  8018ee:	c3                   	retq   

00000000008018ef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018ef:	55                   	push   %rbp
  8018f0:	48 89 e5             	mov    %rsp,%rbp
  8018f3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fe:	00 
  8018ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801905:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801910:	ba 00 00 00 00       	mov    $0x0,%edx
  801915:	be 00 00 00 00       	mov    $0x0,%esi
  80191a:	bf 02 00 00 00       	mov    $0x2,%edi
  80191f:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801926:	00 00 00 
  801929:	ff d0                	callq  *%rax
}
  80192b:	c9                   	leaveq 
  80192c:	c3                   	retq   

000000000080192d <sys_yield>:

void
sys_yield(void)
{
  80192d:	55                   	push   %rbp
  80192e:	48 89 e5             	mov    %rsp,%rbp
  801931:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801935:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193c:	00 
  80193d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801943:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801949:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	be 00 00 00 00       	mov    $0x0,%esi
  801958:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195d:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801964:	00 00 00 
  801967:	ff d0                	callq  *%rax
}
  801969:	c9                   	leaveq 
  80196a:	c3                   	retq   

000000000080196b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	48 83 ec 20          	sub    $0x20,%rsp
  801973:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801976:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80197d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801980:	48 63 c8             	movslq %eax,%rcx
  801983:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801987:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198a:	48 98                	cltq   
  80198c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801993:	00 
  801994:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199a:	49 89 c8             	mov    %rcx,%r8
  80199d:	48 89 d1             	mov    %rdx,%rcx
  8019a0:	48 89 c2             	mov    %rax,%rdx
  8019a3:	be 01 00 00 00       	mov    $0x1,%esi
  8019a8:	bf 04 00 00 00       	mov    $0x4,%edi
  8019ad:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8019b4:	00 00 00 
  8019b7:	ff d0                	callq  *%rax
}
  8019b9:	c9                   	leaveq 
  8019ba:	c3                   	retq   

00000000008019bb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	48 83 ec 30          	sub    $0x30,%rsp
  8019c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019cd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019d1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019d8:	48 63 c8             	movslq %eax,%rcx
  8019db:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e2:	48 63 f0             	movslq %eax,%rsi
  8019e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ec:	48 98                	cltq   
  8019ee:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019f2:	49 89 f9             	mov    %rdi,%r9
  8019f5:	49 89 f0             	mov    %rsi,%r8
  8019f8:	48 89 d1             	mov    %rdx,%rcx
  8019fb:	48 89 c2             	mov    %rax,%rdx
  8019fe:	be 01 00 00 00       	mov    $0x1,%esi
  801a03:	bf 05 00 00 00       	mov    $0x5,%edi
  801a08:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 20          	sub    $0x20,%rsp
  801a1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2c:	48 98                	cltq   
  801a2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a35:	00 
  801a36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a42:	48 89 d1             	mov    %rdx,%rcx
  801a45:	48 89 c2             	mov    %rax,%rdx
  801a48:	be 01 00 00 00       	mov    $0x1,%esi
  801a4d:	bf 06 00 00 00       	mov    $0x6,%edi
  801a52:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801a59:	00 00 00 
  801a5c:	ff d0                	callq  *%rax
}
  801a5e:	c9                   	leaveq 
  801a5f:	c3                   	retq   

0000000000801a60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a60:	55                   	push   %rbp
  801a61:	48 89 e5             	mov    %rsp,%rbp
  801a64:	48 83 ec 10          	sub    $0x10,%rsp
  801a68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a71:	48 63 d0             	movslq %eax,%rdx
  801a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a80:	00 
  801a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8d:	48 89 d1             	mov    %rdx,%rcx
  801a90:	48 89 c2             	mov    %rax,%rdx
  801a93:	be 01 00 00 00       	mov    $0x1,%esi
  801a98:	bf 08 00 00 00       	mov    $0x8,%edi
  801a9d:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 20          	sub    $0x20,%rsp
  801ab3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aca:	00 
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 09 00 00 00       	mov    $0x9,%edi
  801ae7:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 20          	sub    $0x20,%rsp
  801afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b08:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0e:	48 63 f0             	movslq %eax,%rsi
  801b11:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b25:	00 
  801b26:	49 89 f1             	mov    %rsi,%r9
  801b29:	49 89 c8             	mov    %rcx,%r8
  801b2c:	48 89 d1             	mov    %rdx,%rcx
  801b2f:	48 89 c2             	mov    %rax,%rdx
  801b32:	be 00 00 00 00       	mov    $0x0,%esi
  801b37:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b3c:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 10          	sub    $0x10,%rsp
  801b52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b61:	00 
  801b62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b73:	48 89 c2             	mov    %rax,%rdx
  801b76:	be 01 00 00 00       	mov    $0x1,%esi
  801b7b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b80:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
  801b92:	48 83 ec 30          	sub    $0x30,%rsp
  801b96:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9e:	48 8b 00             	mov    (%rax),%rax
  801ba1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ba5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba9:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bad:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801bb0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb3:	83 e0 02             	and    $0x2,%eax
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	75 4d                	jne    801c07 <pgfault+0x79>
  801bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbe:	48 c1 e8 0c          	shr    $0xc,%rax
  801bc2:	48 89 c2             	mov    %rax,%rdx
  801bc5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bcc:	01 00 00 
  801bcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd3:	25 00 08 00 00       	and    $0x800,%eax
  801bd8:	48 85 c0             	test   %rax,%rax
  801bdb:	74 2a                	je     801c07 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801bdd:	48 ba f8 2a 80 00 00 	movabs $0x802af8,%rdx
  801be4:	00 00 00 
  801be7:	be 1e 00 00 00       	mov    $0x1e,%esi
  801bec:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801bf3:	00 00 00 
  801bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfb:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801c02:	00 00 00 
  801c05:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801c07:	ba 07 00 00 00       	mov    $0x7,%edx
  801c0c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c11:	bf 00 00 00 00       	mov    $0x0,%edi
  801c16:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801c1d:	00 00 00 
  801c20:	ff d0                	callq  *%rax
  801c22:	85 c0                	test   %eax,%eax
  801c24:	0f 85 cd 00 00 00    	jne    801cf7 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c36:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c3c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c44:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c49:	48 89 c6             	mov    %rax,%rsi
  801c4c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c51:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c61:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c67:	48 89 c1             	mov    %rax,%rcx
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c74:	bf 00 00 00 00       	mov    $0x0,%edi
  801c79:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	callq  *%rax
  801c85:	85 c0                	test   %eax,%eax
  801c87:	79 2a                	jns    801cb3 <pgfault+0x125>
				panic("Page map at temp address failed");
  801c89:	48 ba 28 2b 80 00 00 	movabs $0x802b28,%rdx
  801c90:	00 00 00 
  801c93:	be 2f 00 00 00       	mov    $0x2f,%esi
  801c98:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801c9f:	00 00 00 
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca7:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801cae:	00 00 00 
  801cb1:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801cb3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cb8:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbd:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	79 54                	jns    801d21 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ccd:	48 ba 48 2b 80 00 00 	movabs $0x802b48,%rdx
  801cd4:	00 00 00 
  801cd7:	be 31 00 00 00       	mov    $0x31,%esi
  801cdc:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801ce3:	00 00 00 
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801cf2:	00 00 00 
  801cf5:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801cf7:	48 ba 70 2b 80 00 00 	movabs $0x802b70,%rdx
  801cfe:	00 00 00 
  801d01:	be 35 00 00 00       	mov    $0x35,%esi
  801d06:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801d0d:	00 00 00 
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
  801d15:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801d1c:	00 00 00 
  801d1f:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801d21:	c9                   	leaveq 
  801d22:	c3                   	retq   

0000000000801d23 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d23:	55                   	push   %rbp
  801d24:	48 89 e5             	mov    %rsp,%rbp
  801d27:	48 83 ec 20          	sub    $0x20,%rsp
  801d2b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d2e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801d31:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d38:	01 00 00 
  801d3b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d42:	25 07 0e 00 00       	and    $0xe07,%eax
  801d47:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d4a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d4d:	48 c1 e0 0c          	shl    $0xc,%rax
  801d51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d58:	25 00 04 00 00       	and    $0x400,%eax
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	74 57                	je     801db8 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d61:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d64:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d68:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6f:	41 89 f0             	mov    %esi,%r8d
  801d72:	48 89 c6             	mov    %rax,%rsi
  801d75:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7a:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
  801d86:	85 c0                	test   %eax,%eax
  801d88:	0f 8e 52 01 00 00    	jle    801ee0 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801d8e:	48 ba 9d 2b 80 00 00 	movabs $0x802b9d,%rdx
  801d95:	00 00 00 
  801d98:	be 52 00 00 00       	mov    $0x52,%esi
  801d9d:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801da4:	00 00 00 
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dac:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801db3:	00 00 00 
  801db6:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbb:	83 e0 02             	and    $0x2,%eax
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 10                	jne    801dd2 <duppage+0xaf>
  801dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc5:	25 00 08 00 00       	and    $0x800,%eax
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	0f 84 bb 00 00 00    	je     801e8d <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd5:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801dda:	80 cc 08             	or     $0x8,%ah
  801ddd:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801de0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801de3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801de7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dee:	41 89 f0             	mov    %esi,%r8d
  801df1:	48 89 c6             	mov    %rax,%rsi
  801df4:	bf 00 00 00 00       	mov    $0x0,%edi
  801df9:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	callq  *%rax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	7e 2a                	jle    801e33 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801e09:	48 ba 9d 2b 80 00 00 	movabs $0x802b9d,%rdx
  801e10:	00 00 00 
  801e13:	be 5a 00 00 00       	mov    $0x5a,%esi
  801e18:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801e1f:	00 00 00 
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801e2e:	00 00 00 
  801e31:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e33:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3e:	41 89 c8             	mov    %ecx,%r8d
  801e41:	48 89 d1             	mov    %rdx,%rcx
  801e44:	ba 00 00 00 00       	mov    $0x0,%edx
  801e49:	48 89 c6             	mov    %rax,%rsi
  801e4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e51:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	7e 2a                	jle    801e8b <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801e61:	48 ba 9d 2b 80 00 00 	movabs $0x802b9d,%rdx
  801e68:	00 00 00 
  801e6b:	be 5d 00 00 00       	mov    $0x5d,%esi
  801e70:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801e77:	00 00 00 
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7f:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801e86:	00 00 00 
  801e89:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e8b:	eb 53                	jmp    801ee0 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e8d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e90:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e94:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9b:	41 89 f0             	mov    %esi,%r8d
  801e9e:	48 89 c6             	mov    %rax,%rsi
  801ea1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea6:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	callq  *%rax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	7e 2a                	jle    801ee0 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801eb6:	48 ba 9d 2b 80 00 00 	movabs $0x802b9d,%rdx
  801ebd:	00 00 00 
  801ec0:	be 61 00 00 00       	mov    $0x61,%esi
  801ec5:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801ecc:	00 00 00 
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  801edb:	00 00 00 
  801ede:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee5:	c9                   	leaveq 
  801ee6:	c3                   	retq   

0000000000801ee7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ee7:	55                   	push   %rbp
  801ee8:	48 89 e5             	mov    %rsp,%rbp
  801eeb:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801eef:	48 bf 8e 1b 80 00 00 	movabs $0x801b8e,%rdi
  801ef6:	00 00 00 
  801ef9:	48 b8 87 24 80 00 00 	movabs $0x802487,%rax
  801f00:	00 00 00 
  801f03:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f05:	b8 07 00 00 00       	mov    $0x7,%eax
  801f0a:	cd 30                	int    $0x30
  801f0c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f0f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f12:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f19:	79 30                	jns    801f4b <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f1e:	89 c1                	mov    %eax,%ecx
  801f20:	48 ba bb 2b 80 00 00 	movabs $0x802bbb,%rdx
  801f27:	00 00 00 
  801f2a:	be 89 00 00 00       	mov    $0x89,%esi
  801f2f:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  801f36:	00 00 00 
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	49 b8 73 23 80 00 00 	movabs $0x802373,%r8
  801f45:	00 00 00 
  801f48:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f4f:	75 46                	jne    801f97 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f51:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	callq  *%rax
  801f5d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f62:	48 63 d0             	movslq %eax,%rdx
  801f65:	48 89 d0             	mov    %rdx,%rax
  801f68:	48 c1 e0 03          	shl    $0x3,%rax
  801f6c:	48 01 d0             	add    %rdx,%rax
  801f6f:	48 c1 e0 05          	shl    $0x5,%rax
  801f73:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f7a:	00 00 00 
  801f7d:	48 01 c2             	add    %rax,%rdx
  801f80:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  801f87:	00 00 00 
  801f8a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	e9 d1 01 00 00       	jmpq   802168 <fork+0x281>
	}

	uint64_t ad = 0;
  801f97:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f9e:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f9f:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fa4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fa8:	e9 df 00 00 00       	jmpq   80208c <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb1:	48 c1 e8 27          	shr    $0x27,%rax
  801fb5:	48 89 c2             	mov    %rax,%rdx
  801fb8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fbf:	01 00 00 
  801fc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc6:	83 e0 01             	and    $0x1,%eax
  801fc9:	48 85 c0             	test   %rax,%rax
  801fcc:	0f 84 9e 00 00 00    	je     802070 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801fd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd6:	48 c1 e8 1e          	shr    $0x1e,%rax
  801fda:	48 89 c2             	mov    %rax,%rdx
  801fdd:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801fe4:	01 00 00 
  801fe7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801feb:	83 e0 01             	and    $0x1,%eax
  801fee:	48 85 c0             	test   %rax,%rax
  801ff1:	74 73                	je     802066 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801ff3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff7:	48 c1 e8 15          	shr    $0x15,%rax
  801ffb:	48 89 c2             	mov    %rax,%rdx
  801ffe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802005:	01 00 00 
  802008:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80200c:	83 e0 01             	and    $0x1,%eax
  80200f:	48 85 c0             	test   %rax,%rax
  802012:	74 48                	je     80205c <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802018:	48 c1 e8 0c          	shr    $0xc,%rax
  80201c:	48 89 c2             	mov    %rax,%rdx
  80201f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802026:	01 00 00 
  802029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802035:	83 e0 01             	and    $0x1,%eax
  802038:	48 85 c0             	test   %rax,%rax
  80203b:	74 47                	je     802084 <fork+0x19d>
						duppage(envid, VPN(addr));
  80203d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802041:	48 c1 e8 0c          	shr    $0xc,%rax
  802045:	89 c2                	mov    %eax,%edx
  802047:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80204a:	89 d6                	mov    %edx,%esi
  80204c:	89 c7                	mov    %eax,%edi
  80204e:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  802055:	00 00 00 
  802058:	ff d0                	callq  *%rax
  80205a:	eb 28                	jmp    802084 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  80205c:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802063:	00 
  802064:	eb 1e                	jmp    802084 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802066:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80206d:	40 
  80206e:	eb 14                	jmp    802084 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802070:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802074:	48 c1 e8 27          	shr    $0x27,%rax
  802078:	48 83 c0 01          	add    $0x1,%rax
  80207c:	48 c1 e0 27          	shl    $0x27,%rax
  802080:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802084:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80208b:	00 
  80208c:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802093:	00 
  802094:	0f 87 13 ff ff ff    	ja     801fad <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80209a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80209d:	ba 07 00 00 00       	mov    $0x7,%edx
  8020a2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020a7:	89 c7                	mov    %eax,%edi
  8020a9:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8020b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020b8:	ba 07 00 00 00       	mov    $0x7,%edx
  8020bd:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020c2:	89 c7                	mov    %eax,%edi
  8020c4:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  8020cb:	00 00 00 
  8020ce:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8020d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d3:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020d9:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8020de:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e3:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020e8:	89 c7                	mov    %eax,%edi
  8020ea:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8020f6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020fb:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802100:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802105:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802111:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802116:	bf 00 00 00 00       	mov    $0x0,%edi
  80211b:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802127:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80212e:	00 00 00 
  802131:	48 8b 00             	mov    (%rax),%rax
  802134:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80213b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80213e:	48 89 d6             	mov    %rdx,%rsi
  802141:	89 c7                	mov    %eax,%edi
  802143:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80214f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802152:	be 02 00 00 00       	mov    $0x2,%esi
  802157:	89 c7                	mov    %eax,%edi
  802159:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax

	return envid;
  802165:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  802168:	c9                   	leaveq 
  802169:	c3                   	retq   

000000000080216a <sfork>:

// Challenge!
int
sfork(void)
{
  80216a:	55                   	push   %rbp
  80216b:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80216e:	48 ba d3 2b 80 00 00 	movabs $0x802bd3,%rdx
  802175:	00 00 00 
  802178:	be b8 00 00 00       	mov    $0xb8,%esi
  80217d:	48 bf 1d 2b 80 00 00 	movabs $0x802b1d,%rdi
  802184:	00 00 00 
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  802193:	00 00 00 
  802196:	ff d1                	callq  *%rcx

0000000000802198 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802198:	55                   	push   %rbp
  802199:	48 89 e5             	mov    %rsp,%rbp
  80219c:	48 83 ec 30          	sub    $0x30,%rsp
  8021a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8021ac:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021b1:	75 0e                	jne    8021c1 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8021b3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8021ba:	00 00 00 
  8021bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8021c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021c5:	48 89 c7             	mov    %rax,%rdi
  8021c8:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  8021cf:	00 00 00 
  8021d2:	ff d0                	callq  *%rax
  8021d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021db:	79 27                	jns    802204 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8021dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021e2:	74 0a                	je     8021ee <ipc_recv+0x56>
            *from_env_store = 0;
  8021e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8021ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021f3:	74 0a                	je     8021ff <ipc_recv+0x67>
            *perm_store = 0;
  8021f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8021ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802202:	eb 53                	jmp    802257 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  802204:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802209:	74 19                	je     802224 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80220b:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802212:	00 00 00 
  802215:	48 8b 00             	mov    (%rax),%rax
  802218:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80221e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802222:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  802224:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802229:	74 19                	je     802244 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80222b:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802232:	00 00 00 
  802235:	48 8b 00             	mov    (%rax),%rax
  802238:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80223e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802242:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  802244:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80224b:	00 00 00 
  80224e:	48 8b 00             	mov    (%rax),%rax
  802251:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  802257:	c9                   	leaveq 
  802258:	c3                   	retq   

0000000000802259 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802259:	55                   	push   %rbp
  80225a:	48 89 e5             	mov    %rsp,%rbp
  80225d:	48 83 ec 30          	sub    $0x30,%rsp
  802261:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802264:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802267:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80226b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80226e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802273:	75 0e                	jne    802283 <ipc_send+0x2a>
        pg = (void *)UTOP;
  802275:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80227c:	00 00 00 
  80227f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  802283:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802286:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802289:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80228d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802290:	89 c7                	mov    %eax,%edi
  802292:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
  80229e:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8022a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a5:	79 36                	jns    8022dd <ipc_send+0x84>
  8022a7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8022ab:	74 30                	je     8022dd <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8022ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b0:	89 c1                	mov    %eax,%ecx
  8022b2:	48 ba e9 2b 80 00 00 	movabs $0x802be9,%rdx
  8022b9:	00 00 00 
  8022bc:	be 49 00 00 00       	mov    $0x49,%esi
  8022c1:	48 bf f6 2b 80 00 00 	movabs $0x802bf6,%rdi
  8022c8:	00 00 00 
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	49 b8 73 23 80 00 00 	movabs $0x802373,%r8
  8022d7:	00 00 00 
  8022da:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8022dd:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  8022e4:	00 00 00 
  8022e7:	ff d0                	callq  *%rax
    } while(r != 0);
  8022e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ed:	75 94                	jne    802283 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8022ef:	c9                   	leaveq 
  8022f0:	c3                   	retq   

00000000008022f1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022f1:	55                   	push   %rbp
  8022f2:	48 89 e5             	mov    %rsp,%rbp
  8022f5:	48 83 ec 14          	sub    $0x14,%rsp
  8022f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8022fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802303:	eb 5e                	jmp    802363 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802305:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80230c:	00 00 00 
  80230f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802312:	48 63 d0             	movslq %eax,%rdx
  802315:	48 89 d0             	mov    %rdx,%rax
  802318:	48 c1 e0 03          	shl    $0x3,%rax
  80231c:	48 01 d0             	add    %rdx,%rax
  80231f:	48 c1 e0 05          	shl    $0x5,%rax
  802323:	48 01 c8             	add    %rcx,%rax
  802326:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80232c:	8b 00                	mov    (%rax),%eax
  80232e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802331:	75 2c                	jne    80235f <ipc_find_env+0x6e>
			return envs[i].env_id;
  802333:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80233a:	00 00 00 
  80233d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802340:	48 63 d0             	movslq %eax,%rdx
  802343:	48 89 d0             	mov    %rdx,%rax
  802346:	48 c1 e0 03          	shl    $0x3,%rax
  80234a:	48 01 d0             	add    %rdx,%rax
  80234d:	48 c1 e0 05          	shl    $0x5,%rax
  802351:	48 01 c8             	add    %rcx,%rax
  802354:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80235a:	8b 40 08             	mov    0x8(%rax),%eax
  80235d:	eb 12                	jmp    802371 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80235f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802363:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80236a:	7e 99                	jle    802305 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802371:	c9                   	leaveq 
  802372:	c3                   	retq   

0000000000802373 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802373:	55                   	push   %rbp
  802374:	48 89 e5             	mov    %rsp,%rbp
  802377:	53                   	push   %rbx
  802378:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80237f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802386:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80238c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802393:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80239a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8023a1:	84 c0                	test   %al,%al
  8023a3:	74 23                	je     8023c8 <_panic+0x55>
  8023a5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8023ac:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8023b0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8023b4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8023b8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8023bc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8023c0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8023c4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8023c8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8023cf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8023d6:	00 00 00 
  8023d9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8023e0:	00 00 00 
  8023e3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023e7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8023ee:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8023f5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023fc:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802403:	00 00 00 
  802406:	48 8b 18             	mov    (%rax),%rbx
  802409:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80241b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802422:	41 89 c8             	mov    %ecx,%r8d
  802425:	48 89 d1             	mov    %rdx,%rcx
  802428:	48 89 da             	mov    %rbx,%rdx
  80242b:	89 c6                	mov    %eax,%esi
  80242d:	48 bf 00 2c 80 00 00 	movabs $0x802c00,%rdi
  802434:	00 00 00 
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	49 b9 74 04 80 00 00 	movabs $0x800474,%r9
  802443:	00 00 00 
  802446:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802449:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802450:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802457:	48 89 d6             	mov    %rdx,%rsi
  80245a:	48 89 c7             	mov    %rax,%rdi
  80245d:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax
	cprintf("\n");
  802469:	48 bf 23 2c 80 00 00 	movabs $0x802c23,%rdi
  802470:	00 00 00 
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	48 ba 74 04 80 00 00 	movabs $0x800474,%rdx
  80247f:	00 00 00 
  802482:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802484:	cc                   	int3   
  802485:	eb fd                	jmp    802484 <_panic+0x111>

0000000000802487 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802487:	55                   	push   %rbp
  802488:	48 89 e5             	mov    %rsp,%rbp
  80248b:	48 83 ec 10          	sub    $0x10,%rsp
  80248f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  802493:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80249a:	00 00 00 
  80249d:	48 8b 00             	mov    (%rax),%rax
  8024a0:	48 85 c0             	test   %rax,%rax
  8024a3:	75 49                	jne    8024ee <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8024a5:	ba 07 00 00 00       	mov    $0x7,%edx
  8024aa:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024af:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b4:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	79 2a                	jns    8024ee <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8024c4:	48 ba 28 2c 80 00 00 	movabs $0x802c28,%rdx
  8024cb:	00 00 00 
  8024ce:	be 21 00 00 00       	mov    $0x21,%esi
  8024d3:	48 bf 53 2c 80 00 00 	movabs $0x802c53,%rdi
  8024da:	00 00 00 
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  8024e9:	00 00 00 
  8024ec:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024ee:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8024f5:	00 00 00 
  8024f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024fc:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8024ff:	48 be 4a 25 80 00 00 	movabs $0x80254a,%rsi
  802506:	00 00 00 
  802509:	bf 00 00 00 00       	mov    $0x0,%edi
  80250e:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  802515:	00 00 00 
  802518:	ff d0                	callq  *%rax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	79 2a                	jns    802548 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80251e:	48 ba 68 2c 80 00 00 	movabs $0x802c68,%rdx
  802525:	00 00 00 
  802528:	be 27 00 00 00       	mov    $0x27,%esi
  80252d:	48 bf 53 2c 80 00 00 	movabs $0x802c53,%rdi
  802534:	00 00 00 
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
  80253c:	48 b9 73 23 80 00 00 	movabs $0x802373,%rcx
  802543:	00 00 00 
  802546:	ff d1                	callq  *%rcx
}
  802548:	c9                   	leaveq 
  802549:	c3                   	retq   

000000000080254a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80254a:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80254d:	48 a1 20 40 80 00 00 	movabs 0x804020,%rax
  802554:	00 00 00 
call *%rax
  802557:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  802559:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802560:	00 
    movq 152(%rsp), %rcx
  802561:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  802568:	00 
    subq $8, %rcx
  802569:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  80256d:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  802570:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  802577:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  802578:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80257c:	4c 8b 3c 24          	mov    (%rsp),%r15
  802580:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802585:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80258a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80258f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802594:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802599:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80259e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8025a3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8025a8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8025ad:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8025b2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8025b7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8025bc:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8025c1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8025c6:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  8025ca:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  8025ce:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  8025cf:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  8025d0:	c3                   	retq   
