
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
  800052:	48 b8 3d 1f 80 00 00 	movabs $0x801f3d,%rax
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
  80007d:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf cc 3f 80 00 00 	movabs $0x803fcc,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 fd 11 80 00 00 	movabs $0x8011fd,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf e8 3f 80 00 00 	movabs $0x803fe8,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 83 14 80 00 00 	movabs $0x801483,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 af 22 80 00 00 	movabs $0x8022af,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 83 14 80 00 00 	movabs $0x801483,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 af 22 80 00 00 	movabs $0x8022af,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf cc 3f 80 00 00 	movabs $0x803fcc,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 fd 11 80 00 00 	movabs $0x8011fd,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf 08 40 80 00 00 	movabs $0x804008,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8002b6:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
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
  8002eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002f2:	00 00 00 
  8002f5:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8002fc:	7e 14                	jle    800312 <libmain+0x6b>
		binaryname = argv[0];
  8002fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800302:	48 8b 10             	mov    (%rax),%rdx
  800305:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
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
	close_all();
  80033c:	48 b8 0a 27 80 00 00 	movabs $0x80270a,%rax
  800343:	00 00 00 
  800346:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800348:	bf 00 00 00 00       	mov    $0x0,%edi
  80034d:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	5d                   	pop    %rbp
  80035a:	c3                   	retq   

000000000080035b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
  80035f:	48 83 ec 10          	sub    $0x10,%rsp
  800363:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800366:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80036a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036e:	8b 00                	mov    (%rax),%eax
  800370:	8d 48 01             	lea    0x1(%rax),%ecx
  800373:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800377:	89 0a                	mov    %ecx,(%rdx)
  800379:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80037c:	89 d1                	mov    %edx,%ecx
  80037e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800382:	48 98                	cltq   
  800384:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038c:	8b 00                	mov    (%rax),%eax
  80038e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800393:	75 2c                	jne    8003c1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800399:	8b 00                	mov    (%rax),%eax
  80039b:	48 98                	cltq   
  80039d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a1:	48 83 c2 08          	add    $0x8,%rdx
  8003a5:	48 89 c6             	mov    %rax,%rsi
  8003a8:	48 89 d7             	mov    %rdx,%rdi
  8003ab:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  8003b2:	00 00 00 
  8003b5:	ff d0                	callq  *%rax
        b->idx = 0;
  8003b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c5:	8b 40 04             	mov    0x4(%rax),%eax
  8003c8:	8d 50 01             	lea    0x1(%rax),%edx
  8003cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cf:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003d2:	c9                   	leaveq 
  8003d3:	c3                   	retq   

00000000008003d4 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003d4:	55                   	push   %rbp
  8003d5:	48 89 e5             	mov    %rsp,%rbp
  8003d8:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003df:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003e6:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003ed:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003f4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003fb:	48 8b 0a             	mov    (%rdx),%rcx
  8003fe:	48 89 08             	mov    %rcx,(%rax)
  800401:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800405:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800409:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80040d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800411:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800418:	00 00 00 
    b.cnt = 0;
  80041b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800422:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800425:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80042c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800433:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80043a:	48 89 c6             	mov    %rax,%rsi
  80043d:	48 bf 5b 03 80 00 00 	movabs $0x80035b,%rdi
  800444:	00 00 00 
  800447:	48 b8 33 08 80 00 00 	movabs $0x800833,%rax
  80044e:	00 00 00 
  800451:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800453:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800459:	48 98                	cltq   
  80045b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800462:	48 83 c2 08          	add    $0x8,%rdx
  800466:	48 89 c6             	mov    %rax,%rsi
  800469:	48 89 d7             	mov    %rdx,%rdi
  80046c:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  800473:	00 00 00 
  800476:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800478:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80047e:	c9                   	leaveq 
  80047f:	c3                   	retq   

0000000000800480 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800480:	55                   	push   %rbp
  800481:	48 89 e5             	mov    %rsp,%rbp
  800484:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80048b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800492:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800499:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004a0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004a7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ae:	84 c0                	test   %al,%al
  8004b0:	74 20                	je     8004d2 <cprintf+0x52>
  8004b2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004b6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004be:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004c2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004c6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004ca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ce:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004d2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004d9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004e0:	00 00 00 
  8004e3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004ea:	00 00 00 
  8004ed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004f8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004ff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800506:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80050d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800514:	48 8b 0a             	mov    (%rdx),%rcx
  800517:	48 89 08             	mov    %rcx,(%rax)
  80051a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80051e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800522:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800526:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80052a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800531:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800538:	48 89 d6             	mov    %rdx,%rsi
  80053b:	48 89 c7             	mov    %rax,%rdi
  80053e:	48 b8 d4 03 80 00 00 	movabs $0x8003d4,%rax
  800545:	00 00 00 
  800548:	ff d0                	callq  *%rax
  80054a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800550:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800556:	c9                   	leaveq 
  800557:	c3                   	retq   

0000000000800558 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800558:	55                   	push   %rbp
  800559:	48 89 e5             	mov    %rsp,%rbp
  80055c:	53                   	push   %rbx
  80055d:	48 83 ec 38          	sub    $0x38,%rsp
  800561:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800565:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800569:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80056d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800570:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800574:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800578:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80057b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80057f:	77 3b                	ja     8005bc <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800581:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800584:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800588:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80058b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80058f:	ba 00 00 00 00       	mov    $0x0,%edx
  800594:	48 f7 f3             	div    %rbx
  800597:	48 89 c2             	mov    %rax,%rdx
  80059a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80059d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005a0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	41 89 f9             	mov    %edi,%r9d
  8005ab:	48 89 c7             	mov    %rax,%rdi
  8005ae:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  8005b5:	00 00 00 
  8005b8:	ff d0                	callq  *%rax
  8005ba:	eb 1e                	jmp    8005da <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005bc:	eb 12                	jmp    8005d0 <printnum+0x78>
			putch(padc, putdat);
  8005be:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	48 89 ce             	mov    %rcx,%rsi
  8005cc:	89 d7                	mov    %edx,%edi
  8005ce:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d0:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005d4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005d8:	7f e4                	jg     8005be <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005da:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e6:	48 f7 f1             	div    %rcx
  8005e9:	48 89 d0             	mov    %rdx,%rax
  8005ec:	48 ba 30 42 80 00 00 	movabs $0x804230,%rdx
  8005f3:	00 00 00 
  8005f6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005fa:	0f be d0             	movsbl %al,%edx
  8005fd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	48 89 ce             	mov    %rcx,%rsi
  800608:	89 d7                	mov    %edx,%edi
  80060a:	ff d0                	callq  *%rax
}
  80060c:	48 83 c4 38          	add    $0x38,%rsp
  800610:	5b                   	pop    %rbx
  800611:	5d                   	pop    %rbp
  800612:	c3                   	retq   

0000000000800613 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800613:	55                   	push   %rbp
  800614:	48 89 e5             	mov    %rsp,%rbp
  800617:	48 83 ec 1c          	sub    $0x1c,%rsp
  80061b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80061f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800622:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800626:	7e 52                	jle    80067a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	83 f8 30             	cmp    $0x30,%eax
  800631:	73 24                	jae    800657 <getuint+0x44>
  800633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800637:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	8b 00                	mov    (%rax),%eax
  800641:	89 c0                	mov    %eax,%eax
  800643:	48 01 d0             	add    %rdx,%rax
  800646:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064a:	8b 12                	mov    (%rdx),%edx
  80064c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80064f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800653:	89 0a                	mov    %ecx,(%rdx)
  800655:	eb 17                	jmp    80066e <getuint+0x5b>
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80065f:	48 89 d0             	mov    %rdx,%rax
  800662:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80066e:	48 8b 00             	mov    (%rax),%rax
  800671:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800675:	e9 a3 00 00 00       	jmpq   80071d <getuint+0x10a>
	else if (lflag)
  80067a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80067e:	74 4f                	je     8006cf <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800684:	8b 00                	mov    (%rax),%eax
  800686:	83 f8 30             	cmp    $0x30,%eax
  800689:	73 24                	jae    8006af <getuint+0x9c>
  80068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	8b 00                	mov    (%rax),%eax
  800699:	89 c0                	mov    %eax,%eax
  80069b:	48 01 d0             	add    %rdx,%rax
  80069e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a2:	8b 12                	mov    (%rdx),%edx
  8006a4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	89 0a                	mov    %ecx,(%rdx)
  8006ad:	eb 17                	jmp    8006c6 <getuint+0xb3>
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b7:	48 89 d0             	mov    %rdx,%rax
  8006ba:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c6:	48 8b 00             	mov    (%rax),%rax
  8006c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cd:	eb 4e                	jmp    80071d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	8b 00                	mov    (%rax),%eax
  8006d5:	83 f8 30             	cmp    $0x30,%eax
  8006d8:	73 24                	jae    8006fe <getuint+0xeb>
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e6:	8b 00                	mov    (%rax),%eax
  8006e8:	89 c0                	mov    %eax,%eax
  8006ea:	48 01 d0             	add    %rdx,%rax
  8006ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f1:	8b 12                	mov    (%rdx),%edx
  8006f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	89 0a                	mov    %ecx,(%rdx)
  8006fc:	eb 17                	jmp    800715 <getuint+0x102>
  8006fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800702:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800706:	48 89 d0             	mov    %rdx,%rax
  800709:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800711:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800715:	8b 00                	mov    (%rax),%eax
  800717:	89 c0                	mov    %eax,%eax
  800719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80071d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800721:	c9                   	leaveq 
  800722:	c3                   	retq   

0000000000800723 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800723:	55                   	push   %rbp
  800724:	48 89 e5             	mov    %rsp,%rbp
  800727:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800732:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800736:	7e 52                	jle    80078a <getint+0x67>
		x=va_arg(*ap, long long);
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	83 f8 30             	cmp    $0x30,%eax
  800741:	73 24                	jae    800767 <getint+0x44>
  800743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800747:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074f:	8b 00                	mov    (%rax),%eax
  800751:	89 c0                	mov    %eax,%eax
  800753:	48 01 d0             	add    %rdx,%rax
  800756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075a:	8b 12                	mov    (%rdx),%edx
  80075c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800763:	89 0a                	mov    %ecx,(%rdx)
  800765:	eb 17                	jmp    80077e <getint+0x5b>
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076f:	48 89 d0             	mov    %rdx,%rax
  800772:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077e:	48 8b 00             	mov    (%rax),%rax
  800781:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800785:	e9 a3 00 00 00       	jmpq   80082d <getint+0x10a>
	else if (lflag)
  80078a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078e:	74 4f                	je     8007df <getint+0xbc>
		x=va_arg(*ap, long);
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 24                	jae    8007bf <getint+0x9c>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	8b 00                	mov    (%rax),%eax
  8007a9:	89 c0                	mov    %eax,%eax
  8007ab:	48 01 d0             	add    %rdx,%rax
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	8b 12                	mov    (%rdx),%edx
  8007b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	89 0a                	mov    %ecx,(%rdx)
  8007bd:	eb 17                	jmp    8007d6 <getint+0xb3>
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d6:	48 8b 00             	mov    (%rax),%rax
  8007d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007dd:	eb 4e                	jmp    80082d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e3:	8b 00                	mov    (%rax),%eax
  8007e5:	83 f8 30             	cmp    $0x30,%eax
  8007e8:	73 24                	jae    80080e <getint+0xeb>
  8007ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	8b 00                	mov    (%rax),%eax
  8007f8:	89 c0                	mov    %eax,%eax
  8007fa:	48 01 d0             	add    %rdx,%rax
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	8b 12                	mov    (%rdx),%edx
  800803:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080a:	89 0a                	mov    %ecx,(%rdx)
  80080c:	eb 17                	jmp    800825 <getint+0x102>
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800816:	48 89 d0             	mov    %rdx,%rax
  800819:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800821:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800825:	8b 00                	mov    (%rax),%eax
  800827:	48 98                	cltq   
  800829:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80082d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800831:	c9                   	leaveq 
  800832:	c3                   	retq   

0000000000800833 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800833:	55                   	push   %rbp
  800834:	48 89 e5             	mov    %rsp,%rbp
  800837:	41 54                	push   %r12
  800839:	53                   	push   %rbx
  80083a:	48 83 ec 60          	sub    $0x60,%rsp
  80083e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800842:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800846:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80084a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80084e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800852:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800856:	48 8b 0a             	mov    (%rdx),%rcx
  800859:	48 89 08             	mov    %rcx,(%rax)
  80085c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800860:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800864:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800868:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086c:	eb 17                	jmp    800885 <vprintfmt+0x52>
			if (ch == '\0')
  80086e:	85 db                	test   %ebx,%ebx
  800870:	0f 84 df 04 00 00    	je     800d55 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800876:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80087a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087e:	48 89 d6             	mov    %rdx,%rsi
  800881:	89 df                	mov    %ebx,%edi
  800883:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800885:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800889:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80088d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800891:	0f b6 00             	movzbl (%rax),%eax
  800894:	0f b6 d8             	movzbl %al,%ebx
  800897:	83 fb 25             	cmp    $0x25,%ebx
  80089a:	75 d2                	jne    80086e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80089c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008a0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008a7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008b5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c8:	0f b6 00             	movzbl (%rax),%eax
  8008cb:	0f b6 d8             	movzbl %al,%ebx
  8008ce:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008d1:	83 f8 55             	cmp    $0x55,%eax
  8008d4:	0f 87 47 04 00 00    	ja     800d21 <vprintfmt+0x4ee>
  8008da:	89 c0                	mov    %eax,%eax
  8008dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008e3:	00 
  8008e4:	48 b8 58 42 80 00 00 	movabs $0x804258,%rax
  8008eb:	00 00 00 
  8008ee:	48 01 d0             	add    %rdx,%rax
  8008f1:	48 8b 00             	mov    (%rax),%rax
  8008f4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008f6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008fa:	eb c0                	jmp    8008bc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800900:	eb ba                	jmp    8008bc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800902:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800909:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80090c:	89 d0                	mov    %edx,%eax
  80090e:	c1 e0 02             	shl    $0x2,%eax
  800911:	01 d0                	add    %edx,%eax
  800913:	01 c0                	add    %eax,%eax
  800915:	01 d8                	add    %ebx,%eax
  800917:	83 e8 30             	sub    $0x30,%eax
  80091a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80091d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800921:	0f b6 00             	movzbl (%rax),%eax
  800924:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800927:	83 fb 2f             	cmp    $0x2f,%ebx
  80092a:	7e 0c                	jle    800938 <vprintfmt+0x105>
  80092c:	83 fb 39             	cmp    $0x39,%ebx
  80092f:	7f 07                	jg     800938 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800931:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800936:	eb d1                	jmp    800909 <vprintfmt+0xd6>
			goto process_precision;
  800938:	eb 58                	jmp    800992 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80093a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093d:	83 f8 30             	cmp    $0x30,%eax
  800940:	73 17                	jae    800959 <vprintfmt+0x126>
  800942:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800946:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800949:	89 c0                	mov    %eax,%eax
  80094b:	48 01 d0             	add    %rdx,%rax
  80094e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800951:	83 c2 08             	add    $0x8,%edx
  800954:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800957:	eb 0f                	jmp    800968 <vprintfmt+0x135>
  800959:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095d:	48 89 d0             	mov    %rdx,%rax
  800960:	48 83 c2 08          	add    $0x8,%rdx
  800964:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800968:	8b 00                	mov    (%rax),%eax
  80096a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80096d:	eb 23                	jmp    800992 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80096f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800973:	79 0c                	jns    800981 <vprintfmt+0x14e>
				width = 0;
  800975:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80097c:	e9 3b ff ff ff       	jmpq   8008bc <vprintfmt+0x89>
  800981:	e9 36 ff ff ff       	jmpq   8008bc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800986:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80098d:	e9 2a ff ff ff       	jmpq   8008bc <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800992:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800996:	79 12                	jns    8009aa <vprintfmt+0x177>
				width = precision, precision = -1;
  800998:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80099b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80099e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009a5:	e9 12 ff ff ff       	jmpq   8008bc <vprintfmt+0x89>
  8009aa:	e9 0d ff ff ff       	jmpq   8008bc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009af:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009b3:	e9 04 ff ff ff       	jmpq   8008bc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bb:	83 f8 30             	cmp    $0x30,%eax
  8009be:	73 17                	jae    8009d7 <vprintfmt+0x1a4>
  8009c0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c7:	89 c0                	mov    %eax,%eax
  8009c9:	48 01 d0             	add    %rdx,%rax
  8009cc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009cf:	83 c2 08             	add    $0x8,%edx
  8009d2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d5:	eb 0f                	jmp    8009e6 <vprintfmt+0x1b3>
  8009d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009db:	48 89 d0             	mov    %rdx,%rax
  8009de:	48 83 c2 08          	add    $0x8,%rdx
  8009e2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e6:	8b 10                	mov    (%rax),%edx
  8009e8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f0:	48 89 ce             	mov    %rcx,%rsi
  8009f3:	89 d7                	mov    %edx,%edi
  8009f5:	ff d0                	callq  *%rax
			break;
  8009f7:	e9 53 03 00 00       	jmpq   800d4f <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ff:	83 f8 30             	cmp    $0x30,%eax
  800a02:	73 17                	jae    800a1b <vprintfmt+0x1e8>
  800a04:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0b:	89 c0                	mov    %eax,%eax
  800a0d:	48 01 d0             	add    %rdx,%rax
  800a10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a13:	83 c2 08             	add    $0x8,%edx
  800a16:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a19:	eb 0f                	jmp    800a2a <vprintfmt+0x1f7>
  800a1b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1f:	48 89 d0             	mov    %rdx,%rax
  800a22:	48 83 c2 08          	add    $0x8,%rdx
  800a26:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a2c:	85 db                	test   %ebx,%ebx
  800a2e:	79 02                	jns    800a32 <vprintfmt+0x1ff>
				err = -err;
  800a30:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a32:	83 fb 15             	cmp    $0x15,%ebx
  800a35:	7f 16                	jg     800a4d <vprintfmt+0x21a>
  800a37:	48 b8 80 41 80 00 00 	movabs $0x804180,%rax
  800a3e:	00 00 00 
  800a41:	48 63 d3             	movslq %ebx,%rdx
  800a44:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a48:	4d 85 e4             	test   %r12,%r12
  800a4b:	75 2e                	jne    800a7b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a4d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a55:	89 d9                	mov    %ebx,%ecx
  800a57:	48 ba 41 42 80 00 00 	movabs $0x804241,%rdx
  800a5e:	00 00 00 
  800a61:	48 89 c7             	mov    %rax,%rdi
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
  800a69:	49 b8 5e 0d 80 00 00 	movabs $0x800d5e,%r8
  800a70:	00 00 00 
  800a73:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a76:	e9 d4 02 00 00       	jmpq   800d4f <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a7b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a83:	4c 89 e1             	mov    %r12,%rcx
  800a86:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  800a8d:	00 00 00 
  800a90:	48 89 c7             	mov    %rax,%rdi
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	49 b8 5e 0d 80 00 00 	movabs $0x800d5e,%r8
  800a9f:	00 00 00 
  800aa2:	41 ff d0             	callq  *%r8
			break;
  800aa5:	e9 a5 02 00 00       	jmpq   800d4f <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aaa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aad:	83 f8 30             	cmp    $0x30,%eax
  800ab0:	73 17                	jae    800ac9 <vprintfmt+0x296>
  800ab2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab9:	89 c0                	mov    %eax,%eax
  800abb:	48 01 d0             	add    %rdx,%rax
  800abe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac1:	83 c2 08             	add    $0x8,%edx
  800ac4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac7:	eb 0f                	jmp    800ad8 <vprintfmt+0x2a5>
  800ac9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acd:	48 89 d0             	mov    %rdx,%rax
  800ad0:	48 83 c2 08          	add    $0x8,%rdx
  800ad4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad8:	4c 8b 20             	mov    (%rax),%r12
  800adb:	4d 85 e4             	test   %r12,%r12
  800ade:	75 0a                	jne    800aea <vprintfmt+0x2b7>
				p = "(null)";
  800ae0:	49 bc 4d 42 80 00 00 	movabs $0x80424d,%r12
  800ae7:	00 00 00 
			if (width > 0 && padc != '-')
  800aea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aee:	7e 3f                	jle    800b2f <vprintfmt+0x2fc>
  800af0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800af4:	74 39                	je     800b2f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800af9:	48 98                	cltq   
  800afb:	48 89 c6             	mov    %rax,%rsi
  800afe:	4c 89 e7             	mov    %r12,%rdi
  800b01:	48 b8 0a 10 80 00 00 	movabs $0x80100a,%rax
  800b08:	00 00 00 
  800b0b:	ff d0                	callq  *%rax
  800b0d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b10:	eb 17                	jmp    800b29 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b12:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b16:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1e:	48 89 ce             	mov    %rcx,%rsi
  800b21:	89 d7                	mov    %edx,%edi
  800b23:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b25:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2d:	7f e3                	jg     800b12 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2f:	eb 37                	jmp    800b68 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b31:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b35:	74 1e                	je     800b55 <vprintfmt+0x322>
  800b37:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3a:	7e 05                	jle    800b41 <vprintfmt+0x30e>
  800b3c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3f:	7e 14                	jle    800b55 <vprintfmt+0x322>
					putch('?', putdat);
  800b41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b49:	48 89 d6             	mov    %rdx,%rsi
  800b4c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b51:	ff d0                	callq  *%rax
  800b53:	eb 0f                	jmp    800b64 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5d:	48 89 d6             	mov    %rdx,%rsi
  800b60:	89 df                	mov    %ebx,%edi
  800b62:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b68:	4c 89 e0             	mov    %r12,%rax
  800b6b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b6f:	0f b6 00             	movzbl (%rax),%eax
  800b72:	0f be d8             	movsbl %al,%ebx
  800b75:	85 db                	test   %ebx,%ebx
  800b77:	74 10                	je     800b89 <vprintfmt+0x356>
  800b79:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b7d:	78 b2                	js     800b31 <vprintfmt+0x2fe>
  800b7f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b83:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b87:	79 a8                	jns    800b31 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b89:	eb 16                	jmp    800ba1 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b93:	48 89 d6             	mov    %rdx,%rsi
  800b96:	bf 20 00 00 00       	mov    $0x20,%edi
  800b9b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba5:	7f e4                	jg     800b8b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ba7:	e9 a3 01 00 00       	jmpq   800d4f <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb0:	be 03 00 00 00       	mov    $0x3,%esi
  800bb5:	48 89 c7             	mov    %rax,%rdi
  800bb8:	48 b8 23 07 80 00 00 	movabs $0x800723,%rax
  800bbf:	00 00 00 
  800bc2:	ff d0                	callq  *%rax
  800bc4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcc:	48 85 c0             	test   %rax,%rax
  800bcf:	79 1d                	jns    800bee <vprintfmt+0x3bb>
				putch('-', putdat);
  800bd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd9:	48 89 d6             	mov    %rdx,%rsi
  800bdc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800be1:	ff d0                	callq  *%rax
				num = -(long long) num;
  800be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be7:	48 f7 d8             	neg    %rax
  800bea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bf5:	e9 e8 00 00 00       	jmpq   800ce2 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfe:	be 03 00 00 00       	mov    $0x3,%esi
  800c03:	48 89 c7             	mov    %rax,%rdi
  800c06:	48 b8 13 06 80 00 00 	movabs $0x800613,%rax
  800c0d:	00 00 00 
  800c10:	ff d0                	callq  *%rax
  800c12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c16:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c1d:	e9 c0 00 00 00       	jmpq   800ce2 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2a:	48 89 d6             	mov    %rdx,%rsi
  800c2d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c32:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3c:	48 89 d6             	mov    %rdx,%rsi
  800c3f:	bf 58 00 00 00       	mov    $0x58,%edi
  800c44:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4e:	48 89 d6             	mov    %rdx,%rsi
  800c51:	bf 58 00 00 00       	mov    $0x58,%edi
  800c56:	ff d0                	callq  *%rax
			break;
  800c58:	e9 f2 00 00 00       	jmpq   800d4f <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c65:	48 89 d6             	mov    %rdx,%rsi
  800c68:	bf 30 00 00 00       	mov    $0x30,%edi
  800c6d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c77:	48 89 d6             	mov    %rdx,%rsi
  800c7a:	bf 78 00 00 00       	mov    $0x78,%edi
  800c7f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c84:	83 f8 30             	cmp    $0x30,%eax
  800c87:	73 17                	jae    800ca0 <vprintfmt+0x46d>
  800c89:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c90:	89 c0                	mov    %eax,%eax
  800c92:	48 01 d0             	add    %rdx,%rax
  800c95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c98:	83 c2 08             	add    $0x8,%edx
  800c9b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9e:	eb 0f                	jmp    800caf <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ca0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca4:	48 89 d0             	mov    %rdx,%rax
  800ca7:	48 83 c2 08          	add    $0x8,%rdx
  800cab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800caf:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cb6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cbd:	eb 23                	jmp    800ce2 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cbf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc3:	be 03 00 00 00       	mov    $0x3,%esi
  800cc8:	48 89 c7             	mov    %rax,%rdi
  800ccb:	48 b8 13 06 80 00 00 	movabs $0x800613,%rax
  800cd2:	00 00 00 
  800cd5:	ff d0                	callq  *%rax
  800cd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cdb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ce7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cea:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ced:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf9:	45 89 c1             	mov    %r8d,%r9d
  800cfc:	41 89 f8             	mov    %edi,%r8d
  800cff:	48 89 c7             	mov    %rax,%rdi
  800d02:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  800d09:	00 00 00 
  800d0c:	ff d0                	callq  *%rax
			break;
  800d0e:	eb 3f                	jmp    800d4f <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d18:	48 89 d6             	mov    %rdx,%rsi
  800d1b:	89 df                	mov    %ebx,%edi
  800d1d:	ff d0                	callq  *%rax
			break;
  800d1f:	eb 2e                	jmp    800d4f <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d29:	48 89 d6             	mov    %rdx,%rsi
  800d2c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d31:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d33:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d38:	eb 05                	jmp    800d3f <vprintfmt+0x50c>
  800d3a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d3f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d43:	48 83 e8 01          	sub    $0x1,%rax
  800d47:	0f b6 00             	movzbl (%rax),%eax
  800d4a:	3c 25                	cmp    $0x25,%al
  800d4c:	75 ec                	jne    800d3a <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d4e:	90                   	nop
		}
	}
  800d4f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d50:	e9 30 fb ff ff       	jmpq   800885 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d55:	48 83 c4 60          	add    $0x60,%rsp
  800d59:	5b                   	pop    %rbx
  800d5a:	41 5c                	pop    %r12
  800d5c:	5d                   	pop    %rbp
  800d5d:	c3                   	retq   

0000000000800d5e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5e:	55                   	push   %rbp
  800d5f:	48 89 e5             	mov    %rsp,%rbp
  800d62:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d69:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d70:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d77:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d85:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8c:	84 c0                	test   %al,%al
  800d8e:	74 20                	je     800db0 <printfmt+0x52>
  800d90:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d94:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d98:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dac:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db0:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800db7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dbe:	00 00 00 
  800dc1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dc8:	00 00 00 
  800dcb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dcf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dd6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ddd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800de4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800deb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800df2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800df9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e00:	48 89 c7             	mov    %rax,%rdi
  800e03:	48 b8 33 08 80 00 00 	movabs $0x800833,%rax
  800e0a:	00 00 00 
  800e0d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e0f:	c9                   	leaveq 
  800e10:	c3                   	retq   

0000000000800e11 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e11:	55                   	push   %rbp
  800e12:	48 89 e5             	mov    %rsp,%rbp
  800e15:	48 83 ec 10          	sub    $0x10,%rsp
  800e19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e24:	8b 40 10             	mov    0x10(%rax),%eax
  800e27:	8d 50 01             	lea    0x1(%rax),%edx
  800e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e35:	48 8b 10             	mov    (%rax),%rdx
  800e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e40:	48 39 c2             	cmp    %rax,%rdx
  800e43:	73 17                	jae    800e5c <sprintputch+0x4b>
		*b->buf++ = ch;
  800e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e49:	48 8b 00             	mov    (%rax),%rax
  800e4c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e54:	48 89 0a             	mov    %rcx,(%rdx)
  800e57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e5a:	88 10                	mov    %dl,(%rax)
}
  800e5c:	c9                   	leaveq 
  800e5d:	c3                   	retq   

0000000000800e5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e5e:	55                   	push   %rbp
  800e5f:	48 89 e5             	mov    %rsp,%rbp
  800e62:	48 83 ec 50          	sub    $0x50,%rsp
  800e66:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e6a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e6d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e71:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e75:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e79:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e7d:	48 8b 0a             	mov    (%rdx),%rcx
  800e80:	48 89 08             	mov    %rcx,(%rax)
  800e83:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e87:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e8b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e8f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e97:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e9b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e9e:	48 98                	cltq   
  800ea0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ea4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea8:	48 01 d0             	add    %rdx,%rax
  800eab:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eaf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eb6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ebb:	74 06                	je     800ec3 <vsnprintf+0x65>
  800ebd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ec1:	7f 07                	jg     800eca <vsnprintf+0x6c>
		return -E_INVAL;
  800ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec8:	eb 2f                	jmp    800ef9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eca:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ece:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ed2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ed6:	48 89 c6             	mov    %rax,%rsi
  800ed9:	48 bf 11 0e 80 00 00 	movabs $0x800e11,%rdi
  800ee0:	00 00 00 
  800ee3:	48 b8 33 08 80 00 00 	movabs $0x800833,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800eef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ef6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ef9:	c9                   	leaveq 
  800efa:	c3                   	retq   

0000000000800efb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800efb:	55                   	push   %rbp
  800efc:	48 89 e5             	mov    %rsp,%rbp
  800eff:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f06:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f0d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f13:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f1a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f21:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 20                	je     800f4c <snprintf+0x51>
  800f2c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f30:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f34:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f38:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f3c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f40:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f44:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f48:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f4c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f53:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f5a:	00 00 00 
  800f5d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f64:	00 00 00 
  800f67:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f6b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f72:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f79:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f80:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f87:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f8e:	48 8b 0a             	mov    (%rdx),%rcx
  800f91:	48 89 08             	mov    %rcx,(%rax)
  800f94:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f98:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f9c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fa4:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fab:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fb2:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fb8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fbf:	48 89 c7             	mov    %rax,%rdi
  800fc2:	48 b8 5e 0e 80 00 00 	movabs $0x800e5e,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	callq  *%rax
  800fce:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fd4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fda:	c9                   	leaveq 
  800fdb:	c3                   	retq   

0000000000800fdc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fdc:	55                   	push   %rbp
  800fdd:	48 89 e5             	mov    %rsp,%rbp
  800fe0:	48 83 ec 18          	sub    $0x18,%rsp
  800fe4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fef:	eb 09                	jmp    800ffa <strlen+0x1e>
		n++;
  800ff1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffe:	0f b6 00             	movzbl (%rax),%eax
  801001:	84 c0                	test   %al,%al
  801003:	75 ec                	jne    800ff1 <strlen+0x15>
		n++;
	return n;
  801005:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801008:	c9                   	leaveq 
  801009:	c3                   	retq   

000000000080100a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80100a:	55                   	push   %rbp
  80100b:	48 89 e5             	mov    %rsp,%rbp
  80100e:	48 83 ec 20          	sub    $0x20,%rsp
  801012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801016:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801021:	eb 0e                	jmp    801031 <strnlen+0x27>
		n++;
  801023:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801027:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801031:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801036:	74 0b                	je     801043 <strnlen+0x39>
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	0f b6 00             	movzbl (%rax),%eax
  80103f:	84 c0                	test   %al,%al
  801041:	75 e0                	jne    801023 <strnlen+0x19>
		n++;
	return n;
  801043:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801046:	c9                   	leaveq 
  801047:	c3                   	retq   

0000000000801048 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	48 83 ec 20          	sub    $0x20,%rsp
  801050:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801054:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801058:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801069:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80106d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801071:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801075:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801079:	0f b6 12             	movzbl (%rdx),%edx
  80107c:	88 10                	mov    %dl,(%rax)
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	84 c0                	test   %al,%al
  801083:	75 dc                	jne    801061 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801085:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801089:	c9                   	leaveq 
  80108a:	c3                   	retq   

000000000080108b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	48 83 ec 20          	sub    $0x20,%rsp
  801093:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801097:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80109b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109f:	48 89 c7             	mov    %rax,%rdi
  8010a2:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  8010a9:	00 00 00 
  8010ac:	ff d0                	callq  *%rax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b4:	48 63 d0             	movslq %eax,%rdx
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 01 c2             	add    %rax,%rdx
  8010be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c2:	48 89 c6             	mov    %rax,%rsi
  8010c5:	48 89 d7             	mov    %rdx,%rdi
  8010c8:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	callq  *%rax
	return dst;
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 83 ec 28          	sub    $0x28,%rsp
  8010e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010f6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010fd:	00 
  8010fe:	eb 2a                	jmp    80112a <strncpy+0x50>
		*dst++ = *src;
  801100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801104:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801108:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801110:	0f b6 12             	movzbl (%rdx),%edx
  801113:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801115:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801119:	0f b6 00             	movzbl (%rax),%eax
  80111c:	84 c0                	test   %al,%al
  80111e:	74 05                	je     801125 <strncpy+0x4b>
			src++;
  801120:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801125:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801132:	72 cc                	jb     801100 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801138:	c9                   	leaveq 
  801139:	c3                   	retq   

000000000080113a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80113a:	55                   	push   %rbp
  80113b:	48 89 e5             	mov    %rsp,%rbp
  80113e:	48 83 ec 28          	sub    $0x28,%rsp
  801142:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801146:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80114a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80114e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801152:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801156:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115b:	74 3d                	je     80119a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80115d:	eb 1d                	jmp    80117c <strlcpy+0x42>
			*dst++ = *src++;
  80115f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801163:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801167:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80116b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801173:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801177:	0f b6 12             	movzbl (%rdx),%edx
  80117a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80117c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801181:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801186:	74 0b                	je     801193 <strlcpy+0x59>
  801188:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118c:	0f b6 00             	movzbl (%rax),%eax
  80118f:	84 c0                	test   %al,%al
  801191:	75 cc                	jne    80115f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801197:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80119a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a2:	48 29 c2             	sub    %rax,%rdx
  8011a5:	48 89 d0             	mov    %rdx,%rax
}
  8011a8:	c9                   	leaveq 
  8011a9:	c3                   	retq   

00000000008011aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011aa:	55                   	push   %rbp
  8011ab:	48 89 e5             	mov    %rsp,%rbp
  8011ae:	48 83 ec 10          	sub    $0x10,%rsp
  8011b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ba:	eb 0a                	jmp    8011c6 <strcmp+0x1c>
		p++, q++;
  8011bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	84 c0                	test   %al,%al
  8011cf:	74 12                	je     8011e3 <strcmp+0x39>
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	0f b6 10             	movzbl (%rax),%edx
  8011d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011dc:	0f b6 00             	movzbl (%rax),%eax
  8011df:	38 c2                	cmp    %al,%dl
  8011e1:	74 d9                	je     8011bc <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e7:	0f b6 00             	movzbl (%rax),%eax
  8011ea:	0f b6 d0             	movzbl %al,%edx
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	0f b6 00             	movzbl (%rax),%eax
  8011f4:	0f b6 c0             	movzbl %al,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
}
  8011fb:	c9                   	leaveq 
  8011fc:	c3                   	retq   

00000000008011fd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011fd:	55                   	push   %rbp
  8011fe:	48 89 e5             	mov    %rsp,%rbp
  801201:	48 83 ec 18          	sub    $0x18,%rsp
  801205:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801209:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80120d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801211:	eb 0f                	jmp    801222 <strncmp+0x25>
		n--, p++, q++;
  801213:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801218:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801222:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801227:	74 1d                	je     801246 <strncmp+0x49>
  801229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	84 c0                	test   %al,%al
  801232:	74 12                	je     801246 <strncmp+0x49>
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801238:	0f b6 10             	movzbl (%rax),%edx
  80123b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123f:	0f b6 00             	movzbl (%rax),%eax
  801242:	38 c2                	cmp    %al,%dl
  801244:	74 cd                	je     801213 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801246:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80124b:	75 07                	jne    801254 <strncmp+0x57>
		return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
  801252:	eb 18                	jmp    80126c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	0f b6 00             	movzbl (%rax),%eax
  80125b:	0f b6 d0             	movzbl %al,%edx
  80125e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801262:	0f b6 00             	movzbl (%rax),%eax
  801265:	0f b6 c0             	movzbl %al,%eax
  801268:	29 c2                	sub    %eax,%edx
  80126a:	89 d0                	mov    %edx,%eax
}
  80126c:	c9                   	leaveq 
  80126d:	c3                   	retq   

000000000080126e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80126e:	55                   	push   %rbp
  80126f:	48 89 e5             	mov    %rsp,%rbp
  801272:	48 83 ec 0c          	sub    $0xc,%rsp
  801276:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80127a:	89 f0                	mov    %esi,%eax
  80127c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80127f:	eb 17                	jmp    801298 <strchr+0x2a>
		if (*s == c)
  801281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801285:	0f b6 00             	movzbl (%rax),%eax
  801288:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80128b:	75 06                	jne    801293 <strchr+0x25>
			return (char *) s;
  80128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801291:	eb 15                	jmp    8012a8 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801293:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129c:	0f b6 00             	movzbl (%rax),%eax
  80129f:	84 c0                	test   %al,%al
  8012a1:	75 de                	jne    801281 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a8:	c9                   	leaveq 
  8012a9:	c3                   	retq   

00000000008012aa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012aa:	55                   	push   %rbp
  8012ab:	48 89 e5             	mov    %rsp,%rbp
  8012ae:	48 83 ec 0c          	sub    $0xc,%rsp
  8012b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b6:	89 f0                	mov    %esi,%eax
  8012b8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012bb:	eb 13                	jmp    8012d0 <strfind+0x26>
		if (*s == c)
  8012bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c1:	0f b6 00             	movzbl (%rax),%eax
  8012c4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c7:	75 02                	jne    8012cb <strfind+0x21>
			break;
  8012c9:	eb 10                	jmp    8012db <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	84 c0                	test   %al,%al
  8012d9:	75 e2                	jne    8012bd <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 83 ec 18          	sub    $0x18,%rsp
  8012e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ed:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012f4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012f9:	75 06                	jne    801301 <memset+0x20>
		return v;
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	eb 69                	jmp    80136a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801305:	83 e0 03             	and    $0x3,%eax
  801308:	48 85 c0             	test   %rax,%rax
  80130b:	75 48                	jne    801355 <memset+0x74>
  80130d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801311:	83 e0 03             	and    $0x3,%eax
  801314:	48 85 c0             	test   %rax,%rax
  801317:	75 3c                	jne    801355 <memset+0x74>
		c &= 0xFF;
  801319:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801323:	c1 e0 18             	shl    $0x18,%eax
  801326:	89 c2                	mov    %eax,%edx
  801328:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132b:	c1 e0 10             	shl    $0x10,%eax
  80132e:	09 c2                	or     %eax,%edx
  801330:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801333:	c1 e0 08             	shl    $0x8,%eax
  801336:	09 d0                	or     %edx,%eax
  801338:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	48 c1 e8 02          	shr    $0x2,%rax
  801343:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801346:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134d:	48 89 d7             	mov    %rdx,%rdi
  801350:	fc                   	cld    
  801351:	f3 ab                	rep stos %eax,%es:(%rdi)
  801353:	eb 11                	jmp    801366 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801355:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801359:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801360:	48 89 d7             	mov    %rdx,%rdi
  801363:	fc                   	cld    
  801364:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80136a:	c9                   	leaveq 
  80136b:	c3                   	retq   

000000000080136c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	48 83 ec 28          	sub    $0x28,%rsp
  801374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801378:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801380:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801384:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801394:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801398:	0f 83 88 00 00 00    	jae    801426 <memmove+0xba>
  80139e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a6:	48 01 d0             	add    %rdx,%rax
  8013a9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ad:	76 77                	jbe    801426 <memmove+0xba>
		s += n;
  8013af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bb:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	83 e0 03             	and    $0x3,%eax
  8013c6:	48 85 c0             	test   %rax,%rax
  8013c9:	75 3b                	jne    801406 <memmove+0x9a>
  8013cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cf:	83 e0 03             	and    $0x3,%eax
  8013d2:	48 85 c0             	test   %rax,%rax
  8013d5:	75 2f                	jne    801406 <memmove+0x9a>
  8013d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013db:	83 e0 03             	and    $0x3,%eax
  8013de:	48 85 c0             	test   %rax,%rax
  8013e1:	75 23                	jne    801406 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e7:	48 83 e8 04          	sub    $0x4,%rax
  8013eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ef:	48 83 ea 04          	sub    $0x4,%rdx
  8013f3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013f7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013fb:	48 89 c7             	mov    %rax,%rdi
  8013fe:	48 89 d6             	mov    %rdx,%rsi
  801401:	fd                   	std    
  801402:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801404:	eb 1d                	jmp    801423 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80140e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801412:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	48 89 d7             	mov    %rdx,%rdi
  80141d:	48 89 c1             	mov    %rax,%rcx
  801420:	fd                   	std    
  801421:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801423:	fc                   	cld    
  801424:	eb 57                	jmp    80147d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	83 e0 03             	and    $0x3,%eax
  80142d:	48 85 c0             	test   %rax,%rax
  801430:	75 36                	jne    801468 <memmove+0xfc>
  801432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 2a                	jne    801468 <memmove+0xfc>
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	83 e0 03             	and    $0x3,%eax
  801445:	48 85 c0             	test   %rax,%rax
  801448:	75 1e                	jne    801468 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	48 c1 e8 02          	shr    $0x2,%rax
  801452:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801459:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145d:	48 89 c7             	mov    %rax,%rdi
  801460:	48 89 d6             	mov    %rdx,%rsi
  801463:	fc                   	cld    
  801464:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801466:	eb 15                	jmp    80147d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801470:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801474:	48 89 c7             	mov    %rax,%rdi
  801477:	48 89 d6             	mov    %rdx,%rsi
  80147a:	fc                   	cld    
  80147b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80147d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801481:	c9                   	leaveq 
  801482:	c3                   	retq   

0000000000801483 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801483:	55                   	push   %rbp
  801484:	48 89 e5             	mov    %rsp,%rbp
  801487:	48 83 ec 18          	sub    $0x18,%rsp
  80148b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80148f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801493:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801497:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80149b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80149f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a3:	48 89 ce             	mov    %rcx,%rsi
  8014a6:	48 89 c7             	mov    %rax,%rdi
  8014a9:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8014b0:	00 00 00 
  8014b3:	ff d0                	callq  *%rax
}
  8014b5:	c9                   	leaveq 
  8014b6:	c3                   	retq   

00000000008014b7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014b7:	55                   	push   %rbp
  8014b8:	48 89 e5             	mov    %rsp,%rbp
  8014bb:	48 83 ec 28          	sub    $0x28,%rsp
  8014bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014db:	eb 36                	jmp    801513 <memcmp+0x5c>
		if (*s1 != *s2)
  8014dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e1:	0f b6 10             	movzbl (%rax),%edx
  8014e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e8:	0f b6 00             	movzbl (%rax),%eax
  8014eb:	38 c2                	cmp    %al,%dl
  8014ed:	74 1a                	je     801509 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	0f b6 d0             	movzbl %al,%edx
  8014f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	0f b6 c0             	movzbl %al,%eax
  801503:	29 c2                	sub    %eax,%edx
  801505:	89 d0                	mov    %edx,%eax
  801507:	eb 20                	jmp    801529 <memcmp+0x72>
		s1++, s2++;
  801509:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80150e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80151b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80151f:	48 85 c0             	test   %rax,%rax
  801522:	75 b9                	jne    8014dd <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801529:	c9                   	leaveq 
  80152a:	c3                   	retq   

000000000080152b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	48 83 ec 28          	sub    $0x28,%rsp
  801533:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801537:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80153a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801546:	48 01 d0             	add    %rdx,%rax
  801549:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80154d:	eb 15                	jmp    801564 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80154f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801553:	0f b6 10             	movzbl (%rax),%edx
  801556:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801559:	38 c2                	cmp    %al,%dl
  80155b:	75 02                	jne    80155f <memfind+0x34>
			break;
  80155d:	eb 0f                	jmp    80156e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80155f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801568:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80156c:	72 e1                	jb     80154f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80156e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801572:	c9                   	leaveq 
  801573:	c3                   	retq   

0000000000801574 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801574:	55                   	push   %rbp
  801575:	48 89 e5             	mov    %rsp,%rbp
  801578:	48 83 ec 34          	sub    $0x34,%rsp
  80157c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801580:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801584:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801587:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80158e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801595:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801596:	eb 05                	jmp    80159d <strtol+0x29>
		s++;
  801598:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	0f b6 00             	movzbl (%rax),%eax
  8015a4:	3c 20                	cmp    $0x20,%al
  8015a6:	74 f0                	je     801598 <strtol+0x24>
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3c 09                	cmp    $0x9,%al
  8015b1:	74 e5                	je     801598 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	3c 2b                	cmp    $0x2b,%al
  8015bc:	75 07                	jne    8015c5 <strtol+0x51>
		s++;
  8015be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c3:	eb 17                	jmp    8015dc <strtol+0x68>
	else if (*s == '-')
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	3c 2d                	cmp    $0x2d,%al
  8015ce:	75 0c                	jne    8015dc <strtol+0x68>
		s++, neg = 1;
  8015d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e0:	74 06                	je     8015e8 <strtol+0x74>
  8015e2:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015e6:	75 28                	jne    801610 <strtol+0x9c>
  8015e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	3c 30                	cmp    $0x30,%al
  8015f1:	75 1d                	jne    801610 <strtol+0x9c>
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	48 83 c0 01          	add    $0x1,%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 78                	cmp    $0x78,%al
  801600:	75 0e                	jne    801610 <strtol+0x9c>
		s += 2, base = 16;
  801602:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801607:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80160e:	eb 2c                	jmp    80163c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801610:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801614:	75 19                	jne    80162f <strtol+0xbb>
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	3c 30                	cmp    $0x30,%al
  80161f:	75 0e                	jne    80162f <strtol+0xbb>
		s++, base = 8;
  801621:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801626:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80162d:	eb 0d                	jmp    80163c <strtol+0xc8>
	else if (base == 0)
  80162f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801633:	75 07                	jne    80163c <strtol+0xc8>
		base = 10;
  801635:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	0f b6 00             	movzbl (%rax),%eax
  801643:	3c 2f                	cmp    $0x2f,%al
  801645:	7e 1d                	jle    801664 <strtol+0xf0>
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	3c 39                	cmp    $0x39,%al
  801650:	7f 12                	jg     801664 <strtol+0xf0>
			dig = *s - '0';
  801652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801662:	eb 4e                	jmp    8016b2 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801668:	0f b6 00             	movzbl (%rax),%eax
  80166b:	3c 60                	cmp    $0x60,%al
  80166d:	7e 1d                	jle    80168c <strtol+0x118>
  80166f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801673:	0f b6 00             	movzbl (%rax),%eax
  801676:	3c 7a                	cmp    $0x7a,%al
  801678:	7f 12                	jg     80168c <strtol+0x118>
			dig = *s - 'a' + 10;
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	0f b6 00             	movzbl (%rax),%eax
  801681:	0f be c0             	movsbl %al,%eax
  801684:	83 e8 57             	sub    $0x57,%eax
  801687:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168a:	eb 26                	jmp    8016b2 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	3c 40                	cmp    $0x40,%al
  801695:	7e 48                	jle    8016df <strtol+0x16b>
  801697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169b:	0f b6 00             	movzbl (%rax),%eax
  80169e:	3c 5a                	cmp    $0x5a,%al
  8016a0:	7f 3d                	jg     8016df <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	0f be c0             	movsbl %al,%eax
  8016ac:	83 e8 37             	sub    $0x37,%eax
  8016af:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b5:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b8:	7c 02                	jl     8016bc <strtol+0x148>
			break;
  8016ba:	eb 23                	jmp    8016df <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016c4:	48 98                	cltq   
  8016c6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016cb:	48 89 c2             	mov    %rax,%rdx
  8016ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d1:	48 98                	cltq   
  8016d3:	48 01 d0             	add    %rdx,%rax
  8016d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016da:	e9 5d ff ff ff       	jmpq   80163c <strtol+0xc8>

	if (endptr)
  8016df:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016e4:	74 0b                	je     8016f1 <strtol+0x17d>
		*endptr = (char *) s;
  8016e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016ee:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f5:	74 09                	je     801700 <strtol+0x18c>
  8016f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fb:	48 f7 d8             	neg    %rax
  8016fe:	eb 04                	jmp    801704 <strtol+0x190>
  801700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801704:	c9                   	leaveq 
  801705:	c3                   	retq   

0000000000801706 <strstr>:

char * strstr(const char *in, const char *str)
{
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	48 83 ec 30          	sub    $0x30,%rsp
  80170e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801712:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801716:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80171e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801722:	0f b6 00             	movzbl (%rax),%eax
  801725:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801728:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80172c:	75 06                	jne    801734 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80172e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801732:	eb 6b                	jmp    80179f <strstr+0x99>

	len = strlen(str);
  801734:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801738:	48 89 c7             	mov    %rax,%rdi
  80173b:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  801742:	00 00 00 
  801745:	ff d0                	callq  *%rax
  801747:	48 98                	cltq   
  801749:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801755:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80175f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801763:	75 07                	jne    80176c <strstr+0x66>
				return (char *) 0;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 33                	jmp    80179f <strstr+0x99>
		} while (sc != c);
  80176c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801770:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801773:	75 d8                	jne    80174d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801775:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801779:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80177d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801781:	48 89 ce             	mov    %rcx,%rsi
  801784:	48 89 c7             	mov    %rax,%rdi
  801787:	48 b8 fd 11 80 00 00 	movabs $0x8011fd,%rax
  80178e:	00 00 00 
  801791:	ff d0                	callq  *%rax
  801793:	85 c0                	test   %eax,%eax
  801795:	75 b6                	jne    80174d <strstr+0x47>

	return (char *) (in - 1);
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	48 83 e8 01          	sub    $0x1,%rax
}
  80179f:	c9                   	leaveq 
  8017a0:	c3                   	retq   

00000000008017a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	53                   	push   %rbx
  8017a6:	48 83 ec 48          	sub    $0x48,%rsp
  8017aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017ad:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017b8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017bc:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017c3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017cb:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017cf:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017d3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d7:	4c 89 c3             	mov    %r8,%rbx
  8017da:	cd 30                	int    $0x30
  8017dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017e4:	74 3e                	je     801824 <syscall+0x83>
  8017e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017eb:	7e 37                	jle    801824 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f4:	49 89 d0             	mov    %rdx,%r8
  8017f7:	89 c1                	mov    %eax,%ecx
  8017f9:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  801800:	00 00 00 
  801803:	be 23 00 00 00       	mov    $0x23,%esi
  801808:	48 bf 25 45 80 00 00 	movabs $0x804525,%rdi
  80180f:	00 00 00 
  801812:	b8 00 00 00 00       	mov    $0x0,%eax
  801817:	49 b9 8e 3c 80 00 00 	movabs $0x803c8e,%r9
  80181e:	00 00 00 
  801821:	41 ff d1             	callq  *%r9

	return ret;
  801824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801828:	48 83 c4 48          	add    $0x48,%rsp
  80182c:	5b                   	pop    %rbx
  80182d:	5d                   	pop    %rbp
  80182e:	c3                   	retq   

000000000080182f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80182f:	55                   	push   %rbp
  801830:	48 89 e5             	mov    %rsp,%rbp
  801833:	48 83 ec 20          	sub    $0x20,%rsp
  801837:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80183b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80183f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801843:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801847:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184e:	00 
  80184f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801855:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185b:	48 89 d1             	mov    %rdx,%rcx
  80185e:	48 89 c2             	mov    %rax,%rdx
  801861:	be 00 00 00 00       	mov    $0x0,%esi
  801866:	bf 00 00 00 00       	mov    $0x0,%edi
  80186b:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801872:	00 00 00 
  801875:	ff d0                	callq  *%rax
}
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_cgetc>:

int
sys_cgetc(void)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801881:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801888:	00 
  801889:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801895:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189a:	ba 00 00 00 00       	mov    $0x0,%edx
  80189f:	be 00 00 00 00       	mov    $0x0,%esi
  8018a4:	bf 01 00 00 00       	mov    $0x1,%edi
  8018a9:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8018b0:	00 00 00 
  8018b3:	ff d0                	callq  *%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 10          	sub    $0x10,%rsp
  8018bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c5:	48 98                	cltq   
  8018c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ce:	00 
  8018cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e0:	48 89 c2             	mov    %rax,%rdx
  8018e3:	be 01 00 00 00       	mov    $0x1,%esi
  8018e8:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ed:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8018f4:	00 00 00 
  8018f7:	ff d0                	callq  *%rax
}
  8018f9:	c9                   	leaveq 
  8018fa:	c3                   	retq   

00000000008018fb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018fb:	55                   	push   %rbp
  8018fc:	48 89 e5             	mov    %rsp,%rbp
  8018ff:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801903:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190a:	00 
  80190b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801911:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801917:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191c:	ba 00 00 00 00       	mov    $0x0,%edx
  801921:	be 00 00 00 00       	mov    $0x0,%esi
  801926:	bf 02 00 00 00       	mov    $0x2,%edi
  80192b:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801932:	00 00 00 
  801935:	ff d0                	callq  *%rax
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <sys_yield>:

void
sys_yield(void)
{
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801941:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801948:	00 
  801949:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801955:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195a:	ba 00 00 00 00       	mov    $0x0,%edx
  80195f:	be 00 00 00 00       	mov    $0x0,%esi
  801964:	bf 0b 00 00 00       	mov    $0xb,%edi
  801969:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
}
  801975:	c9                   	leaveq 
  801976:	c3                   	retq   

0000000000801977 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801977:	55                   	push   %rbp
  801978:	48 89 e5             	mov    %rsp,%rbp
  80197b:	48 83 ec 20          	sub    $0x20,%rsp
  80197f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801982:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801986:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801989:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80198c:	48 63 c8             	movslq %eax,%rcx
  80198f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801993:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801996:	48 98                	cltq   
  801998:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199f:	00 
  8019a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a6:	49 89 c8             	mov    %rcx,%r8
  8019a9:	48 89 d1             	mov    %rdx,%rcx
  8019ac:	48 89 c2             	mov    %rax,%rdx
  8019af:	be 01 00 00 00       	mov    $0x1,%esi
  8019b4:	bf 04 00 00 00       	mov    $0x4,%edi
  8019b9:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8019c0:	00 00 00 
  8019c3:	ff d0                	callq  *%rax
}
  8019c5:	c9                   	leaveq 
  8019c6:	c3                   	retq   

00000000008019c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019c7:	55                   	push   %rbp
  8019c8:	48 89 e5             	mov    %rsp,%rbp
  8019cb:	48 83 ec 30          	sub    $0x30,%rsp
  8019cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019d9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019dd:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019e1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019e4:	48 63 c8             	movslq %eax,%rcx
  8019e7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ee:	48 63 f0             	movslq %eax,%rsi
  8019f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f8:	48 98                	cltq   
  8019fa:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019fe:	49 89 f9             	mov    %rdi,%r9
  801a01:	49 89 f0             	mov    %rsi,%r8
  801a04:	48 89 d1             	mov    %rdx,%rcx
  801a07:	48 89 c2             	mov    %rax,%rdx
  801a0a:	be 01 00 00 00       	mov    $0x1,%esi
  801a0f:	bf 05 00 00 00       	mov    $0x5,%edi
  801a14:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801a1b:	00 00 00 
  801a1e:	ff d0                	callq  *%rax
}
  801a20:	c9                   	leaveq 
  801a21:	c3                   	retq   

0000000000801a22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a22:	55                   	push   %rbp
  801a23:	48 89 e5             	mov    %rsp,%rbp
  801a26:	48 83 ec 20          	sub    $0x20,%rsp
  801a2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a38:	48 98                	cltq   
  801a3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a41:	00 
  801a42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4e:	48 89 d1             	mov    %rdx,%rcx
  801a51:	48 89 c2             	mov    %rax,%rdx
  801a54:	be 01 00 00 00       	mov    $0x1,%esi
  801a59:	bf 06 00 00 00       	mov    $0x6,%edi
  801a5e:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 10          	sub    $0x10,%rsp
  801a74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a77:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7d:	48 63 d0             	movslq %eax,%rdx
  801a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a83:	48 98                	cltq   
  801a85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8c:	00 
  801a8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a99:	48 89 d1             	mov    %rdx,%rcx
  801a9c:	48 89 c2             	mov    %rax,%rdx
  801a9f:	be 01 00 00 00       	mov    $0x1,%esi
  801aa4:	bf 08 00 00 00       	mov    $0x8,%edi
  801aa9:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	callq  *%rax
}
  801ab5:	c9                   	leaveq 
  801ab6:	c3                   	retq   

0000000000801ab7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ab7:	55                   	push   %rbp
  801ab8:	48 89 e5             	mov    %rsp,%rbp
  801abb:	48 83 ec 20          	sub    $0x20,%rsp
  801abf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acd:	48 98                	cltq   
  801acf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad6:	00 
  801ad7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801add:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae3:	48 89 d1             	mov    %rdx,%rcx
  801ae6:	48 89 c2             	mov    %rax,%rdx
  801ae9:	be 01 00 00 00       	mov    $0x1,%esi
  801aee:	bf 09 00 00 00       	mov    $0x9,%edi
  801af3:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
}
  801aff:	c9                   	leaveq 
  801b00:	c3                   	retq   

0000000000801b01 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	48 83 ec 20          	sub    $0x20,%rsp
  801b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b17:	48 98                	cltq   
  801b19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b20:	00 
  801b21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2d:	48 89 d1             	mov    %rdx,%rcx
  801b30:	48 89 c2             	mov    %rax,%rdx
  801b33:	be 01 00 00 00       	mov    $0x1,%esi
  801b38:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b3d:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
}
  801b49:	c9                   	leaveq 
  801b4a:	c3                   	retq   

0000000000801b4b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b4b:	55                   	push   %rbp
  801b4c:	48 89 e5             	mov    %rsp,%rbp
  801b4f:	48 83 ec 20          	sub    $0x20,%rsp
  801b53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b5e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b64:	48 63 f0             	movslq %eax,%rsi
  801b67:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6e:	48 98                	cltq   
  801b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7b:	00 
  801b7c:	49 89 f1             	mov    %rsi,%r9
  801b7f:	49 89 c8             	mov    %rcx,%r8
  801b82:	48 89 d1             	mov    %rdx,%rcx
  801b85:	48 89 c2             	mov    %rax,%rdx
  801b88:	be 00 00 00 00       	mov    $0x0,%esi
  801b8d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b92:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	callq  *%rax
}
  801b9e:	c9                   	leaveq 
  801b9f:	c3                   	retq   

0000000000801ba0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ba0:	55                   	push   %rbp
  801ba1:	48 89 e5             	mov    %rsp,%rbp
  801ba4:	48 83 ec 10          	sub    $0x10,%rsp
  801ba8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb7:	00 
  801bb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc9:	48 89 c2             	mov    %rax,%rdx
  801bcc:	be 01 00 00 00       	mov    $0x1,%esi
  801bd1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bd6:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	callq  *%rax
}
  801be2:	c9                   	leaveq 
  801be3:	c3                   	retq   

0000000000801be4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	48 83 ec 30          	sub    $0x30,%rsp
  801bec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf4:	48 8b 00             	mov    (%rax),%rax
  801bf7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801bfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bff:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c03:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c09:	83 e0 02             	and    $0x2,%eax
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	75 4d                	jne    801c5d <pgfault+0x79>
  801c10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c14:	48 c1 e8 0c          	shr    $0xc,%rax
  801c18:	48 89 c2             	mov    %rax,%rdx
  801c1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c22:	01 00 00 
  801c25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c29:	25 00 08 00 00       	and    $0x800,%eax
  801c2e:	48 85 c0             	test   %rax,%rax
  801c31:	74 2a                	je     801c5d <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801c33:	48 ba 38 45 80 00 00 	movabs $0x804538,%rdx
  801c3a:	00 00 00 
  801c3d:	be 1e 00 00 00       	mov    $0x1e,%esi
  801c42:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801c49:	00 00 00 
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801c58:	00 00 00 
  801c5b:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801c5d:	ba 07 00 00 00       	mov    $0x7,%edx
  801c62:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c67:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6c:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	0f 85 cd 00 00 00    	jne    801d4d <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c92:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c9f:	48 89 c6             	mov    %rax,%rsi
  801ca2:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ca7:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cb7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cbd:	48 89 c1             	mov    %rax,%rcx
  801cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cca:	bf 00 00 00 00       	mov    $0x0,%edi
  801ccf:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	callq  *%rax
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	79 2a                	jns    801d09 <pgfault+0x125>
				panic("Page map at temp address failed");
  801cdf:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  801ce6:	00 00 00 
  801ce9:	be 2f 00 00 00       	mov    $0x2f,%esi
  801cee:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801cf5:	00 00 00 
  801cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfd:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801d04:	00 00 00 
  801d07:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d09:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d0e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d13:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801d1a:	00 00 00 
  801d1d:	ff d0                	callq  *%rax
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	79 54                	jns    801d77 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d23:	48 ba 88 45 80 00 00 	movabs $0x804588,%rdx
  801d2a:	00 00 00 
  801d2d:	be 31 00 00 00       	mov    $0x31,%esi
  801d32:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801d39:	00 00 00 
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d41:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801d48:	00 00 00 
  801d4b:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801d4d:	48 ba b0 45 80 00 00 	movabs $0x8045b0,%rdx
  801d54:	00 00 00 
  801d57:	be 35 00 00 00       	mov    $0x35,%esi
  801d5c:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801d63:	00 00 00 
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6b:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801d72:	00 00 00 
  801d75:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801d77:	c9                   	leaveq 
  801d78:	c3                   	retq   

0000000000801d79 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d79:	55                   	push   %rbp
  801d7a:	48 89 e5             	mov    %rsp,%rbp
  801d7d:	48 83 ec 20          	sub    $0x20,%rsp
  801d81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d84:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801d87:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8e:	01 00 00 
  801d91:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d98:	25 07 0e 00 00       	and    $0xe07,%eax
  801d9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801da0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801da3:	48 c1 e0 0c          	shl    $0xc,%rax
  801da7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801dab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dae:	25 00 04 00 00       	and    $0x400,%eax
  801db3:	85 c0                	test   %eax,%eax
  801db5:	74 57                	je     801e0e <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801db7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801dba:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dbe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc5:	41 89 f0             	mov    %esi,%r8d
  801dc8:	48 89 c6             	mov    %rax,%rsi
  801dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd0:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	0f 8e 52 01 00 00    	jle    801f36 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801de4:	48 ba dd 45 80 00 00 	movabs $0x8045dd,%rdx
  801deb:	00 00 00 
  801dee:	be 52 00 00 00       	mov    $0x52,%esi
  801df3:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801dfa:	00 00 00 
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801e09:	00 00 00 
  801e0c:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e11:	83 e0 02             	and    $0x2,%eax
  801e14:	85 c0                	test   %eax,%eax
  801e16:	75 10                	jne    801e28 <duppage+0xaf>
  801e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1b:	25 00 08 00 00       	and    $0x800,%eax
  801e20:	85 c0                	test   %eax,%eax
  801e22:	0f 84 bb 00 00 00    	je     801ee3 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2b:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e30:	80 cc 08             	or     $0x8,%ah
  801e33:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e36:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e39:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e44:	41 89 f0             	mov    %esi,%r8d
  801e47:	48 89 c6             	mov    %rax,%rsi
  801e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4f:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	callq  *%rax
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	7e 2a                	jle    801e89 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801e5f:	48 ba dd 45 80 00 00 	movabs $0x8045dd,%rdx
  801e66:	00 00 00 
  801e69:	be 5a 00 00 00       	mov    $0x5a,%esi
  801e6e:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801e75:	00 00 00 
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801e84:	00 00 00 
  801e87:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e89:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e94:	41 89 c8             	mov    %ecx,%r8d
  801e97:	48 89 d1             	mov    %rdx,%rcx
  801e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9f:	48 89 c6             	mov    %rax,%rsi
  801ea2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea7:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  801eae:	00 00 00 
  801eb1:	ff d0                	callq  *%rax
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	7e 2a                	jle    801ee1 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801eb7:	48 ba dd 45 80 00 00 	movabs $0x8045dd,%rdx
  801ebe:	00 00 00 
  801ec1:	be 5d 00 00 00       	mov    $0x5d,%esi
  801ec6:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801ecd:	00 00 00 
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801edc:	00 00 00 
  801edf:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ee1:	eb 53                	jmp    801f36 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ee3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ee6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801eea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef1:	41 89 f0             	mov    %esi,%r8d
  801ef4:	48 89 c6             	mov    %rax,%rsi
  801ef7:	bf 00 00 00 00       	mov    $0x0,%edi
  801efc:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  801f03:	00 00 00 
  801f06:	ff d0                	callq  *%rax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	7e 2a                	jle    801f36 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801f0c:	48 ba dd 45 80 00 00 	movabs $0x8045dd,%rdx
  801f13:	00 00 00 
  801f16:	be 61 00 00 00       	mov    $0x61,%esi
  801f1b:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801f22:	00 00 00 
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2a:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  801f31:	00 00 00 
  801f34:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3b:	c9                   	leaveq 
  801f3c:	c3                   	retq   

0000000000801f3d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f3d:	55                   	push   %rbp
  801f3e:	48 89 e5             	mov    %rsp,%rbp
  801f41:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801f45:	48 bf e4 1b 80 00 00 	movabs $0x801be4,%rdi
  801f4c:	00 00 00 
  801f4f:	48 b8 a2 3d 80 00 00 	movabs $0x803da2,%rax
  801f56:	00 00 00 
  801f59:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f5b:	b8 07 00 00 00       	mov    $0x7,%eax
  801f60:	cd 30                	int    $0x30
  801f62:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f65:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f68:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801f6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f6f:	79 30                	jns    801fa1 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f71:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f74:	89 c1                	mov    %eax,%ecx
  801f76:	48 ba fb 45 80 00 00 	movabs $0x8045fb,%rdx
  801f7d:	00 00 00 
  801f80:	be 89 00 00 00       	mov    $0x89,%esi
  801f85:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  801f8c:	00 00 00 
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	49 b8 8e 3c 80 00 00 	movabs $0x803c8e,%r8
  801f9b:	00 00 00 
  801f9e:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fa5:	75 46                	jne    801fed <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801fa7:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
  801fb3:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fb8:	48 63 d0             	movslq %eax,%rdx
  801fbb:	48 89 d0             	mov    %rdx,%rax
  801fbe:	48 c1 e0 03          	shl    $0x3,%rax
  801fc2:	48 01 d0             	add    %rdx,%rax
  801fc5:	48 c1 e0 05          	shl    $0x5,%rax
  801fc9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fd0:	00 00 00 
  801fd3:	48 01 c2             	add    %rax,%rdx
  801fd6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fdd:	00 00 00 
  801fe0:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	e9 d1 01 00 00       	jmpq   8021be <fork+0x281>
	}

	uint64_t ad = 0;
  801fed:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801ff4:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801ff5:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801ffa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801ffe:	e9 df 00 00 00       	jmpq   8020e2 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802007:	48 c1 e8 27          	shr    $0x27,%rax
  80200b:	48 89 c2             	mov    %rax,%rdx
  80200e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802015:	01 00 00 
  802018:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201c:	83 e0 01             	and    $0x1,%eax
  80201f:	48 85 c0             	test   %rax,%rax
  802022:	0f 84 9e 00 00 00    	je     8020c6 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202c:	48 c1 e8 1e          	shr    $0x1e,%rax
  802030:	48 89 c2             	mov    %rax,%rdx
  802033:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80203a:	01 00 00 
  80203d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802041:	83 e0 01             	and    $0x1,%eax
  802044:	48 85 c0             	test   %rax,%rax
  802047:	74 73                	je     8020bc <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802049:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204d:	48 c1 e8 15          	shr    $0x15,%rax
  802051:	48 89 c2             	mov    %rax,%rdx
  802054:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205b:	01 00 00 
  80205e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802062:	83 e0 01             	and    $0x1,%eax
  802065:	48 85 c0             	test   %rax,%rax
  802068:	74 48                	je     8020b2 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80206a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206e:	48 c1 e8 0c          	shr    $0xc,%rax
  802072:	48 89 c2             	mov    %rax,%rdx
  802075:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207c:	01 00 00 
  80207f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802083:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208b:	83 e0 01             	and    $0x1,%eax
  80208e:	48 85 c0             	test   %rax,%rax
  802091:	74 47                	je     8020da <fork+0x19d>
						duppage(envid, VPN(addr));
  802093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802097:	48 c1 e8 0c          	shr    $0xc,%rax
  80209b:	89 c2                	mov    %eax,%edx
  80209d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020a0:	89 d6                	mov    %edx,%esi
  8020a2:	89 c7                	mov    %eax,%edi
  8020a4:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
  8020b0:	eb 28                	jmp    8020da <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  8020b2:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8020b9:	00 
  8020ba:	eb 1e                	jmp    8020da <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020bc:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020c3:	40 
  8020c4:	eb 14                	jmp    8020da <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  8020c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ca:	48 c1 e8 27          	shr    $0x27,%rax
  8020ce:	48 83 c0 01          	add    $0x1,%rax
  8020d2:	48 c1 e0 27          	shl    $0x27,%rax
  8020d6:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8020da:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020e1:	00 
  8020e2:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020e9:	00 
  8020ea:	0f 87 13 ff ff ff    	ja     802003 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8020f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020fd:	89 c7                	mov    %eax,%edi
  8020ff:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80210b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210e:	ba 07 00 00 00       	mov    $0x7,%edx
  802113:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802118:	89 c7                	mov    %eax,%edi
  80211a:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  802121:	00 00 00 
  802124:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802126:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802129:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80212f:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802134:	ba 00 00 00 00       	mov    $0x0,%edx
  802139:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80213e:	89 c7                	mov    %eax,%edi
  802140:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80214c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802151:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802156:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80215b:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802167:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80216c:	bf 00 00 00 00       	mov    $0x0,%edi
  802171:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80217d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802184:	00 00 00 
  802187:	48 8b 00             	mov    (%rax),%rax
  80218a:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802191:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802194:	48 89 d6             	mov    %rdx,%rsi
  802197:	89 c7                	mov    %eax,%edi
  802199:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  8021a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a8:	be 02 00 00 00       	mov    $0x2,%esi
  8021ad:	89 c7                	mov    %eax,%edi
  8021af:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	callq  *%rax

	return envid;
  8021bb:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8021be:	c9                   	leaveq 
  8021bf:	c3                   	retq   

00000000008021c0 <sfork>:

// Challenge!
int
sfork(void)
{
  8021c0:	55                   	push   %rbp
  8021c1:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021c4:	48 ba 13 46 80 00 00 	movabs $0x804613,%rdx
  8021cb:	00 00 00 
  8021ce:	be b8 00 00 00       	mov    $0xb8,%esi
  8021d3:	48 bf 5d 45 80 00 00 	movabs $0x80455d,%rdi
  8021da:	00 00 00 
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  8021e9:	00 00 00 
  8021ec:	ff d1                	callq  *%rcx

00000000008021ee <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021ee:	55                   	push   %rbp
  8021ef:	48 89 e5             	mov    %rsp,%rbp
  8021f2:	48 83 ec 30          	sub    $0x30,%rsp
  8021f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  802202:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802207:	75 0e                	jne    802217 <ipc_recv+0x29>
        pg = (void *)UTOP;
  802209:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802210:	00 00 00 
  802213:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  802217:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80221b:	48 89 c7             	mov    %rax,%rdi
  80221e:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  802225:	00 00 00 
  802228:	ff d0                	callq  *%rax
  80222a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802231:	79 27                	jns    80225a <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  802233:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802238:	74 0a                	je     802244 <ipc_recv+0x56>
            *from_env_store = 0;
  80223a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  802244:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802249:	74 0a                	je     802255 <ipc_recv+0x67>
            *perm_store = 0;
  80224b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  802255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802258:	eb 53                	jmp    8022ad <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  80225a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80225f:	74 19                	je     80227a <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  802261:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802268:	00 00 00 
  80226b:	48 8b 00             	mov    (%rax),%rax
  80226e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802278:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80227a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80227f:	74 19                	je     80229a <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  802281:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802288:	00 00 00 
  80228b:	48 8b 00             	mov    (%rax),%rax
  80228e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802294:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802298:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80229a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022a1:	00 00 00 
  8022a4:	48 8b 00             	mov    (%rax),%rax
  8022a7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8022ad:	c9                   	leaveq 
  8022ae:	c3                   	retq   

00000000008022af <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022af:	55                   	push   %rbp
  8022b0:	48 89 e5             	mov    %rsp,%rbp
  8022b3:	48 83 ec 30          	sub    $0x30,%rsp
  8022b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022bd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022c1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8022c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022c9:	75 0e                	jne    8022d9 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8022cb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022d2:	00 00 00 
  8022d5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8022d9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8022dc:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8022df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022e6:	89 c7                	mov    %eax,%edi
  8022e8:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
  8022f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8022f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fb:	79 36                	jns    802333 <ipc_send+0x84>
  8022fd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802301:	74 30                	je     802333 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  802303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802306:	89 c1                	mov    %eax,%ecx
  802308:	48 ba 29 46 80 00 00 	movabs $0x804629,%rdx
  80230f:	00 00 00 
  802312:	be 49 00 00 00       	mov    $0x49,%esi
  802317:	48 bf 36 46 80 00 00 	movabs $0x804636,%rdi
  80231e:	00 00 00 
  802321:	b8 00 00 00 00       	mov    $0x0,%eax
  802326:	49 b8 8e 3c 80 00 00 	movabs $0x803c8e,%r8
  80232d:	00 00 00 
  802330:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  802333:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
    } while(r != 0);
  80233f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802343:	75 94                	jne    8022d9 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  802345:	c9                   	leaveq 
  802346:	c3                   	retq   

0000000000802347 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802347:	55                   	push   %rbp
  802348:	48 89 e5             	mov    %rsp,%rbp
  80234b:	48 83 ec 14          	sub    $0x14,%rsp
  80234f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802359:	eb 5e                	jmp    8023b9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80235b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802362:	00 00 00 
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802368:	48 63 d0             	movslq %eax,%rdx
  80236b:	48 89 d0             	mov    %rdx,%rax
  80236e:	48 c1 e0 03          	shl    $0x3,%rax
  802372:	48 01 d0             	add    %rdx,%rax
  802375:	48 c1 e0 05          	shl    $0x5,%rax
  802379:	48 01 c8             	add    %rcx,%rax
  80237c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802382:	8b 00                	mov    (%rax),%eax
  802384:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802387:	75 2c                	jne    8023b5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802389:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802390:	00 00 00 
  802393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802396:	48 63 d0             	movslq %eax,%rdx
  802399:	48 89 d0             	mov    %rdx,%rax
  80239c:	48 c1 e0 03          	shl    $0x3,%rax
  8023a0:	48 01 d0             	add    %rdx,%rax
  8023a3:	48 c1 e0 05          	shl    $0x5,%rax
  8023a7:	48 01 c8             	add    %rcx,%rax
  8023aa:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8023b0:	8b 40 08             	mov    0x8(%rax),%eax
  8023b3:	eb 12                	jmp    8023c7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8023b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023b9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8023c0:	7e 99                	jle    80235b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c7:	c9                   	leaveq 
  8023c8:	c3                   	retq   

00000000008023c9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8023c9:	55                   	push   %rbp
  8023ca:	48 89 e5             	mov    %rsp,%rbp
  8023cd:	48 83 ec 08          	sub    $0x8,%rsp
  8023d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023d9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023e0:	ff ff ff 
  8023e3:	48 01 d0             	add    %rdx,%rax
  8023e6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023ea:	c9                   	leaveq 
  8023eb:	c3                   	retq   

00000000008023ec <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023ec:	55                   	push   %rbp
  8023ed:	48 89 e5             	mov    %rsp,%rbp
  8023f0:	48 83 ec 08          	sub    $0x8,%rsp
  8023f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fc:	48 89 c7             	mov    %rax,%rdi
  8023ff:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
  80240b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802411:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802415:	c9                   	leaveq 
  802416:	c3                   	retq   

0000000000802417 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802417:	55                   	push   %rbp
  802418:	48 89 e5             	mov    %rsp,%rbp
  80241b:	48 83 ec 18          	sub    $0x18,%rsp
  80241f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80242a:	eb 6b                	jmp    802497 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80242c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242f:	48 98                	cltq   
  802431:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802437:	48 c1 e0 0c          	shl    $0xc,%rax
  80243b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80243f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802443:	48 c1 e8 15          	shr    $0x15,%rax
  802447:	48 89 c2             	mov    %rax,%rdx
  80244a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802451:	01 00 00 
  802454:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802458:	83 e0 01             	and    $0x1,%eax
  80245b:	48 85 c0             	test   %rax,%rax
  80245e:	74 21                	je     802481 <fd_alloc+0x6a>
  802460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802464:	48 c1 e8 0c          	shr    $0xc,%rax
  802468:	48 89 c2             	mov    %rax,%rdx
  80246b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802472:	01 00 00 
  802475:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802479:	83 e0 01             	and    $0x1,%eax
  80247c:	48 85 c0             	test   %rax,%rax
  80247f:	75 12                	jne    802493 <fd_alloc+0x7c>
			*fd_store = fd;
  802481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802485:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802489:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80248c:	b8 00 00 00 00       	mov    $0x0,%eax
  802491:	eb 1a                	jmp    8024ad <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802493:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802497:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80249b:	7e 8f                	jle    80242c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80249d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024a8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024ad:	c9                   	leaveq 
  8024ae:	c3                   	retq   

00000000008024af <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024af:	55                   	push   %rbp
  8024b0:	48 89 e5             	mov    %rsp,%rbp
  8024b3:	48 83 ec 20          	sub    $0x20,%rsp
  8024b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024c2:	78 06                	js     8024ca <fd_lookup+0x1b>
  8024c4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8024c8:	7e 07                	jle    8024d1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024cf:	eb 6c                	jmp    80253d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d4:	48 98                	cltq   
  8024d6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8024e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e8:	48 c1 e8 15          	shr    $0x15,%rax
  8024ec:	48 89 c2             	mov    %rax,%rdx
  8024ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f6:	01 00 00 
  8024f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fd:	83 e0 01             	and    $0x1,%eax
  802500:	48 85 c0             	test   %rax,%rax
  802503:	74 21                	je     802526 <fd_lookup+0x77>
  802505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802509:	48 c1 e8 0c          	shr    $0xc,%rax
  80250d:	48 89 c2             	mov    %rax,%rdx
  802510:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802517:	01 00 00 
  80251a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251e:	83 e0 01             	and    $0x1,%eax
  802521:	48 85 c0             	test   %rax,%rax
  802524:	75 07                	jne    80252d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802526:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80252b:	eb 10                	jmp    80253d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80252d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802531:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802535:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 30          	sub    $0x30,%rsp
  802547:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802554:	48 89 c7             	mov    %rax,%rdi
  802557:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
  802563:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802567:	48 89 d6             	mov    %rdx,%rsi
  80256a:	89 c7                	mov    %eax,%edi
  80256c:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
  802578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257f:	78 0a                	js     80258b <fd_close+0x4c>
	    || fd != fd2)
  802581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802585:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802589:	74 12                	je     80259d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80258b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80258f:	74 05                	je     802596 <fd_close+0x57>
  802591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802594:	eb 05                	jmp    80259b <fd_close+0x5c>
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	eb 69                	jmp    802606 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80259d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a1:	8b 00                	mov    (%rax),%eax
  8025a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a7:	48 89 d6             	mov    %rdx,%rsi
  8025aa:	89 c7                	mov    %eax,%edi
  8025ac:	48 b8 08 26 80 00 00 	movabs $0x802608,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
  8025b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bf:	78 2a                	js     8025eb <fd_close+0xac>
		if (dev->dev_close)
  8025c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025c9:	48 85 c0             	test   %rax,%rax
  8025cc:	74 16                	je     8025e4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025da:	48 89 d7             	mov    %rdx,%rdi
  8025dd:	ff d0                	callq  *%rax
  8025df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e2:	eb 07                	jmp    8025eb <fd_close+0xac>
		else
			r = 0;
  8025e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ef:	48 89 c6             	mov    %rax,%rsi
  8025f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f7:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8025fe:	00 00 00 
  802601:	ff d0                	callq  *%rax
	return r;
  802603:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802606:	c9                   	leaveq 
  802607:	c3                   	retq   

0000000000802608 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802608:	55                   	push   %rbp
  802609:	48 89 e5             	mov    %rsp,%rbp
  80260c:	48 83 ec 20          	sub    $0x20,%rsp
  802610:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802613:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802617:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80261e:	eb 41                	jmp    802661 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802620:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802627:	00 00 00 
  80262a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80262d:	48 63 d2             	movslq %edx,%rdx
  802630:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802634:	8b 00                	mov    (%rax),%eax
  802636:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802639:	75 22                	jne    80265d <dev_lookup+0x55>
			*dev = devtab[i];
  80263b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802642:	00 00 00 
  802645:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802648:	48 63 d2             	movslq %edx,%rdx
  80264b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80264f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802653:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
  80265b:	eb 60                	jmp    8026bd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80265d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802661:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802668:	00 00 00 
  80266b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80266e:	48 63 d2             	movslq %edx,%rdx
  802671:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802675:	48 85 c0             	test   %rax,%rax
  802678:	75 a6                	jne    802620 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80267a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802681:	00 00 00 
  802684:	48 8b 00             	mov    (%rax),%rax
  802687:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80268d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802690:	89 c6                	mov    %eax,%esi
  802692:	48 bf 40 46 80 00 00 	movabs $0x804640,%rdi
  802699:	00 00 00 
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  8026a8:	00 00 00 
  8026ab:	ff d1                	callq  *%rcx
	*dev = 0;
  8026ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026bd:	c9                   	leaveq 
  8026be:	c3                   	retq   

00000000008026bf <close>:

int
close(int fdnum)
{
  8026bf:	55                   	push   %rbp
  8026c0:	48 89 e5             	mov    %rsp,%rbp
  8026c3:	48 83 ec 20          	sub    $0x20,%rsp
  8026c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026d1:	48 89 d6             	mov    %rdx,%rsi
  8026d4:	89 c7                	mov    %eax,%edi
  8026d6:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
  8026e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e9:	79 05                	jns    8026f0 <close+0x31>
		return r;
  8026eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ee:	eb 18                	jmp    802708 <close+0x49>
	else
		return fd_close(fd, 1);
  8026f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f4:	be 01 00 00 00       	mov    $0x1,%esi
  8026f9:	48 89 c7             	mov    %rax,%rdi
  8026fc:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
}
  802708:	c9                   	leaveq 
  802709:	c3                   	retq   

000000000080270a <close_all>:

void
close_all(void)
{
  80270a:	55                   	push   %rbp
  80270b:	48 89 e5             	mov    %rsp,%rbp
  80270e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802712:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802719:	eb 15                	jmp    802730 <close_all+0x26>
		close(i);
  80271b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271e:	89 c7                	mov    %eax,%edi
  802720:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80272c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802730:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802734:	7e e5                	jle    80271b <close_all+0x11>
		close(i);
}
  802736:	c9                   	leaveq 
  802737:	c3                   	retq   

0000000000802738 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802738:	55                   	push   %rbp
  802739:	48 89 e5             	mov    %rsp,%rbp
  80273c:	48 83 ec 40          	sub    $0x40,%rsp
  802740:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802743:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802746:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80274a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80274d:	48 89 d6             	mov    %rdx,%rsi
  802750:	89 c7                	mov    %eax,%edi
  802752:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802759:	00 00 00 
  80275c:	ff d0                	callq  *%rax
  80275e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802765:	79 08                	jns    80276f <dup+0x37>
		return r;
  802767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276a:	e9 70 01 00 00       	jmpq   8028df <dup+0x1a7>
	close(newfdnum);
  80276f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802772:	89 c7                	mov    %eax,%edi
  802774:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802780:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802783:	48 98                	cltq   
  802785:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80278b:	48 c1 e0 0c          	shl    $0xc,%rax
  80278f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802797:	48 89 c7             	mov    %rax,%rdi
  80279a:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  8027a1:	00 00 00 
  8027a4:	ff d0                	callq  *%rax
  8027a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ae:	48 89 c7             	mov    %rax,%rdi
  8027b1:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	callq  *%rax
  8027bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c5:	48 c1 e8 15          	shr    $0x15,%rax
  8027c9:	48 89 c2             	mov    %rax,%rdx
  8027cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027d3:	01 00 00 
  8027d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027da:	83 e0 01             	and    $0x1,%eax
  8027dd:	48 85 c0             	test   %rax,%rax
  8027e0:	74 73                	je     802855 <dup+0x11d>
  8027e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8027ea:	48 89 c2             	mov    %rax,%rdx
  8027ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027f4:	01 00 00 
  8027f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027fb:	83 e0 01             	and    $0x1,%eax
  8027fe:	48 85 c0             	test   %rax,%rax
  802801:	74 52                	je     802855 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802807:	48 c1 e8 0c          	shr    $0xc,%rax
  80280b:	48 89 c2             	mov    %rax,%rdx
  80280e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802815:	01 00 00 
  802818:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281c:	25 07 0e 00 00       	and    $0xe07,%eax
  802821:	89 c1                	mov    %eax,%ecx
  802823:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282b:	41 89 c8             	mov    %ecx,%r8d
  80282e:	48 89 d1             	mov    %rdx,%rcx
  802831:	ba 00 00 00 00       	mov    $0x0,%edx
  802836:	48 89 c6             	mov    %rax,%rsi
  802839:	bf 00 00 00 00       	mov    $0x0,%edi
  80283e:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  802845:	00 00 00 
  802848:	ff d0                	callq  *%rax
  80284a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802851:	79 02                	jns    802855 <dup+0x11d>
			goto err;
  802853:	eb 57                	jmp    8028ac <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802859:	48 c1 e8 0c          	shr    $0xc,%rax
  80285d:	48 89 c2             	mov    %rax,%rdx
  802860:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802867:	01 00 00 
  80286a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286e:	25 07 0e 00 00       	and    $0xe07,%eax
  802873:	89 c1                	mov    %eax,%ecx
  802875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802879:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80287d:	41 89 c8             	mov    %ecx,%r8d
  802880:	48 89 d1             	mov    %rdx,%rcx
  802883:	ba 00 00 00 00       	mov    $0x0,%edx
  802888:	48 89 c6             	mov    %rax,%rsi
  80288b:	bf 00 00 00 00       	mov    $0x0,%edi
  802890:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  802897:	00 00 00 
  80289a:	ff d0                	callq  *%rax
  80289c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a3:	79 02                	jns    8028a7 <dup+0x16f>
		goto err;
  8028a5:	eb 05                	jmp    8028ac <dup+0x174>

	return newfdnum;
  8028a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028aa:	eb 33                	jmp    8028df <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b0:	48 89 c6             	mov    %rax,%rsi
  8028b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b8:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c8:	48 89 c6             	mov    %rax,%rsi
  8028cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d0:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
	return r;
  8028dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028df:	c9                   	leaveq 
  8028e0:	c3                   	retq   

00000000008028e1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028e1:	55                   	push   %rbp
  8028e2:	48 89 e5             	mov    %rsp,%rbp
  8028e5:	48 83 ec 40          	sub    $0x40,%rsp
  8028e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028fb:	48 89 d6             	mov    %rdx,%rsi
  8028fe:	89 c7                	mov    %eax,%edi
  802900:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
  80290c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802913:	78 24                	js     802939 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802919:	8b 00                	mov    (%rax),%eax
  80291b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80291f:	48 89 d6             	mov    %rdx,%rsi
  802922:	89 c7                	mov    %eax,%edi
  802924:	48 b8 08 26 80 00 00 	movabs $0x802608,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	callq  *%rax
  802930:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802937:	79 05                	jns    80293e <read+0x5d>
		return r;
  802939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293c:	eb 76                	jmp    8029b4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80293e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802942:	8b 40 08             	mov    0x8(%rax),%eax
  802945:	83 e0 03             	and    $0x3,%eax
  802948:	83 f8 01             	cmp    $0x1,%eax
  80294b:	75 3a                	jne    802987 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80294d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802954:	00 00 00 
  802957:	48 8b 00             	mov    (%rax),%rax
  80295a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802960:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802963:	89 c6                	mov    %eax,%esi
  802965:	48 bf 5f 46 80 00 00 	movabs $0x80465f,%rdi
  80296c:	00 00 00 
  80296f:	b8 00 00 00 00       	mov    $0x0,%eax
  802974:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  80297b:	00 00 00 
  80297e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802980:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802985:	eb 2d                	jmp    8029b4 <read+0xd3>
	}
	if (!dev->dev_read)
  802987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80298f:	48 85 c0             	test   %rax,%rax
  802992:	75 07                	jne    80299b <read+0xba>
		return -E_NOT_SUPP;
  802994:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802999:	eb 19                	jmp    8029b4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80299b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299f:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029a3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029af:	48 89 cf             	mov    %rcx,%rdi
  8029b2:	ff d0                	callq  *%rax
}
  8029b4:	c9                   	leaveq 
  8029b5:	c3                   	retq   

00000000008029b6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
  8029ba:	48 83 ec 30          	sub    $0x30,%rsp
  8029be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029d0:	eb 49                	jmp    802a1b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d5:	48 98                	cltq   
  8029d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029db:	48 29 c2             	sub    %rax,%rdx
  8029de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e1:	48 63 c8             	movslq %eax,%rcx
  8029e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e8:	48 01 c1             	add    %rax,%rcx
  8029eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ee:	48 89 ce             	mov    %rcx,%rsi
  8029f1:	89 c7                	mov    %eax,%edi
  8029f3:	48 b8 e1 28 80 00 00 	movabs $0x8028e1,%rax
  8029fa:	00 00 00 
  8029fd:	ff d0                	callq  *%rax
  8029ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a02:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a06:	79 05                	jns    802a0d <readn+0x57>
			return m;
  802a08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a0b:	eb 1c                	jmp    802a29 <readn+0x73>
		if (m == 0)
  802a0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a11:	75 02                	jne    802a15 <readn+0x5f>
			break;
  802a13:	eb 11                	jmp    802a26 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a18:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1e:	48 98                	cltq   
  802a20:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a24:	72 ac                	jb     8029d2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a29:	c9                   	leaveq 
  802a2a:	c3                   	retq   

0000000000802a2b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a2b:	55                   	push   %rbp
  802a2c:	48 89 e5             	mov    %rsp,%rbp
  802a2f:	48 83 ec 40          	sub    $0x40,%rsp
  802a33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a45:	48 89 d6             	mov    %rdx,%rsi
  802a48:	89 c7                	mov    %eax,%edi
  802a4a:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	callq  *%rax
  802a56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5d:	78 24                	js     802a83 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a63:	8b 00                	mov    (%rax),%eax
  802a65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a69:	48 89 d6             	mov    %rdx,%rsi
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	48 b8 08 26 80 00 00 	movabs $0x802608,%rax
  802a75:	00 00 00 
  802a78:	ff d0                	callq  *%rax
  802a7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a81:	79 05                	jns    802a88 <write+0x5d>
		return r;
  802a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a86:	eb 75                	jmp    802afd <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8c:	8b 40 08             	mov    0x8(%rax),%eax
  802a8f:	83 e0 03             	and    $0x3,%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	75 3a                	jne    802ad0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a96:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a9d:	00 00 00 
  802aa0:	48 8b 00             	mov    (%rax),%rax
  802aa3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802aa9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802aac:	89 c6                	mov    %eax,%esi
  802aae:	48 bf 7b 46 80 00 00 	movabs $0x80467b,%rdi
  802ab5:	00 00 00 
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  802abd:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  802ac4:	00 00 00 
  802ac7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ac9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ace:	eb 2d                	jmp    802afd <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ad8:	48 85 c0             	test   %rax,%rax
  802adb:	75 07                	jne    802ae4 <write+0xb9>
		return -E_NOT_SUPP;
  802add:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ae2:	eb 19                	jmp    802afd <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aec:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802af0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802af4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802af8:	48 89 cf             	mov    %rcx,%rdi
  802afb:	ff d0                	callq  *%rax
}
  802afd:	c9                   	leaveq 
  802afe:	c3                   	retq   

0000000000802aff <seek>:

int
seek(int fdnum, off_t offset)
{
  802aff:	55                   	push   %rbp
  802b00:	48 89 e5             	mov    %rsp,%rbp
  802b03:	48 83 ec 18          	sub    $0x18,%rsp
  802b07:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b0a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b0d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b14:	48 89 d6             	mov    %rdx,%rsi
  802b17:	89 c7                	mov    %eax,%edi
  802b19:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
  802b25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2c:	79 05                	jns    802b33 <seek+0x34>
		return r;
  802b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b31:	eb 0f                	jmp    802b42 <seek+0x43>
	fd->fd_offset = offset;
  802b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b37:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b3a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b42:	c9                   	leaveq 
  802b43:	c3                   	retq   

0000000000802b44 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b44:	55                   	push   %rbp
  802b45:	48 89 e5             	mov    %rsp,%rbp
  802b48:	48 83 ec 30          	sub    $0x30,%rsp
  802b4c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b4f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b52:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b56:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b59:	48 89 d6             	mov    %rdx,%rsi
  802b5c:	89 c7                	mov    %eax,%edi
  802b5e:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
  802b6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b71:	78 24                	js     802b97 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b77:	8b 00                	mov    (%rax),%eax
  802b79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b7d:	48 89 d6             	mov    %rdx,%rsi
  802b80:	89 c7                	mov    %eax,%edi
  802b82:	48 b8 08 26 80 00 00 	movabs $0x802608,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
  802b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b95:	79 05                	jns    802b9c <ftruncate+0x58>
		return r;
  802b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9a:	eb 72                	jmp    802c0e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba0:	8b 40 08             	mov    0x8(%rax),%eax
  802ba3:	83 e0 03             	and    $0x3,%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	75 3a                	jne    802be4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802baa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bb1:	00 00 00 
  802bb4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802bb7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bbd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bc0:	89 c6                	mov    %eax,%esi
  802bc2:	48 bf 98 46 80 00 00 	movabs $0x804698,%rdi
  802bc9:	00 00 00 
  802bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd1:	48 b9 80 04 80 00 00 	movabs $0x800480,%rcx
  802bd8:	00 00 00 
  802bdb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802be2:	eb 2a                	jmp    802c0e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802be4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bec:	48 85 c0             	test   %rax,%rax
  802bef:	75 07                	jne    802bf8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bf1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bf6:	eb 16                	jmp    802c0e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfc:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c04:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c07:	89 ce                	mov    %ecx,%esi
  802c09:	48 89 d7             	mov    %rdx,%rdi
  802c0c:	ff d0                	callq  *%rax
}
  802c0e:	c9                   	leaveq 
  802c0f:	c3                   	retq   

0000000000802c10 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c10:	55                   	push   %rbp
  802c11:	48 89 e5             	mov    %rsp,%rbp
  802c14:	48 83 ec 30          	sub    $0x30,%rsp
  802c18:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c1f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c26:	48 89 d6             	mov    %rdx,%rsi
  802c29:	89 c7                	mov    %eax,%edi
  802c2b:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  802c32:	00 00 00 
  802c35:	ff d0                	callq  *%rax
  802c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3e:	78 24                	js     802c64 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c44:	8b 00                	mov    (%rax),%eax
  802c46:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c4a:	48 89 d6             	mov    %rdx,%rsi
  802c4d:	89 c7                	mov    %eax,%edi
  802c4f:	48 b8 08 26 80 00 00 	movabs $0x802608,%rax
  802c56:	00 00 00 
  802c59:	ff d0                	callq  *%rax
  802c5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c62:	79 05                	jns    802c69 <fstat+0x59>
		return r;
  802c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c67:	eb 5e                	jmp    802cc7 <fstat+0xb7>
	if (!dev->dev_stat)
  802c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c71:	48 85 c0             	test   %rax,%rax
  802c74:	75 07                	jne    802c7d <fstat+0x6d>
		return -E_NOT_SUPP;
  802c76:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c7b:	eb 4a                	jmp    802cc7 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c81:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c88:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c8f:	00 00 00 
	stat->st_isdir = 0;
  802c92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c96:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c9d:	00 00 00 
	stat->st_dev = dev;
  802ca0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ca4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cbb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cbf:	48 89 ce             	mov    %rcx,%rsi
  802cc2:	48 89 d7             	mov    %rdx,%rdi
  802cc5:	ff d0                	callq  *%rax
}
  802cc7:	c9                   	leaveq 
  802cc8:	c3                   	retq   

0000000000802cc9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802cc9:	55                   	push   %rbp
  802cca:	48 89 e5             	mov    %rsp,%rbp
  802ccd:	48 83 ec 20          	sub    $0x20,%rsp
  802cd1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdd:	be 00 00 00 00       	mov    $0x0,%esi
  802ce2:	48 89 c7             	mov    %rax,%rdi
  802ce5:	48 b8 b7 2d 80 00 00 	movabs $0x802db7,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
  802cf1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf8:	79 05                	jns    802cff <stat+0x36>
		return fd;
  802cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfd:	eb 2f                	jmp    802d2e <stat+0x65>
	r = fstat(fd, stat);
  802cff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d06:	48 89 d6             	mov    %rdx,%rsi
  802d09:	89 c7                	mov    %eax,%edi
  802d0b:	48 b8 10 2c 80 00 00 	movabs $0x802c10,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
  802d17:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
	return r;
  802d2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d2e:	c9                   	leaveq 
  802d2f:	c3                   	retq   

0000000000802d30 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d30:	55                   	push   %rbp
  802d31:	48 89 e5             	mov    %rsp,%rbp
  802d34:	48 83 ec 10          	sub    $0x10,%rsp
  802d38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d3f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d46:	00 00 00 
  802d49:	8b 00                	mov    (%rax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	75 1d                	jne    802d6c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d4f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d54:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
  802d60:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d67:	00 00 00 
  802d6a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d6c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d73:	00 00 00 
  802d76:	8b 00                	mov    (%rax),%eax
  802d78:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d7b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d80:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d87:	00 00 00 
  802d8a:	89 c7                	mov    %eax,%edi
  802d8c:	48 b8 af 22 80 00 00 	movabs $0x8022af,%rax
  802d93:	00 00 00 
  802d96:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802da1:	48 89 c6             	mov    %rax,%rsi
  802da4:	bf 00 00 00 00       	mov    $0x0,%edi
  802da9:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
}
  802db5:	c9                   	leaveq 
  802db6:	c3                   	retq   

0000000000802db7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802db7:	55                   	push   %rbp
  802db8:	48 89 e5             	mov    %rsp,%rbp
  802dbb:	48 83 ec 20          	sub    $0x20,%rsp
  802dbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dc3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802dc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dca:	48 89 c7             	mov    %rax,%rdi
  802dcd:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
  802dd9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802dde:	7e 0a                	jle    802dea <open+0x33>
		return -E_BAD_PATH;
  802de0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802de5:	e9 a5 00 00 00       	jmpq   802e8f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802dea:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dee:	48 89 c7             	mov    %rax,%rdi
  802df1:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  802df8:	00 00 00 
  802dfb:	ff d0                	callq  *%rax
  802dfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e04:	79 08                	jns    802e0e <open+0x57>
		return r;
  802e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e09:	e9 81 00 00 00       	jmpq   802e8f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e12:	48 89 c6             	mov    %rax,%rsi
  802e15:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e1c:	00 00 00 
  802e1f:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  802e26:	00 00 00 
  802e29:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802e2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e32:	00 00 00 
  802e35:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e38:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e42:	48 89 c6             	mov    %rax,%rsi
  802e45:	bf 01 00 00 00       	mov    $0x1,%edi
  802e4a:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
  802e56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5d:	79 1d                	jns    802e7c <open+0xc5>
		fd_close(fd, 0);
  802e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e63:	be 00 00 00 00       	mov    $0x0,%esi
  802e68:	48 89 c7             	mov    %rax,%rdi
  802e6b:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802e72:	00 00 00 
  802e75:	ff d0                	callq  *%rax
		return r;
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7a:	eb 13                	jmp    802e8f <open+0xd8>
	}

	return fd2num(fd);
  802e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e80:	48 89 c7             	mov    %rax,%rdi
  802e83:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  802e8a:	00 00 00 
  802e8d:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802e8f:	c9                   	leaveq 
  802e90:	c3                   	retq   

0000000000802e91 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e91:	55                   	push   %rbp
  802e92:	48 89 e5             	mov    %rsp,%rbp
  802e95:	48 83 ec 10          	sub    $0x10,%rsp
  802e99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ea4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eab:	00 00 00 
  802eae:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802eb0:	be 00 00 00 00       	mov    $0x0,%esi
  802eb5:	bf 06 00 00 00       	mov    $0x6,%edi
  802eba:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  802ec1:	00 00 00 
  802ec4:	ff d0                	callq  *%rax
}
  802ec6:	c9                   	leaveq 
  802ec7:	c3                   	retq   

0000000000802ec8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ec8:	55                   	push   %rbp
  802ec9:	48 89 e5             	mov    %rsp,%rbp
  802ecc:	48 83 ec 30          	sub    $0x30,%rsp
  802ed0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ed4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ed8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ee3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eea:	00 00 00 
  802eed:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802eef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef6:	00 00 00 
  802ef9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802efd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f01:	be 00 00 00 00       	mov    $0x0,%esi
  802f06:	bf 03 00 00 00       	mov    $0x3,%edi
  802f0b:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	callq  *%rax
  802f17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1e:	79 08                	jns    802f28 <devfile_read+0x60>
		return r;
  802f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f23:	e9 a4 00 00 00       	jmpq   802fcc <devfile_read+0x104>
	assert(r <= n);
  802f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2b:	48 98                	cltq   
  802f2d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f31:	76 35                	jbe    802f68 <devfile_read+0xa0>
  802f33:	48 b9 c5 46 80 00 00 	movabs $0x8046c5,%rcx
  802f3a:	00 00 00 
  802f3d:	48 ba cc 46 80 00 00 	movabs $0x8046cc,%rdx
  802f44:	00 00 00 
  802f47:	be 84 00 00 00       	mov    $0x84,%esi
  802f4c:	48 bf e1 46 80 00 00 	movabs $0x8046e1,%rdi
  802f53:	00 00 00 
  802f56:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5b:	49 b8 8e 3c 80 00 00 	movabs $0x803c8e,%r8
  802f62:	00 00 00 
  802f65:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802f68:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802f6f:	7e 35                	jle    802fa6 <devfile_read+0xde>
  802f71:	48 b9 ec 46 80 00 00 	movabs $0x8046ec,%rcx
  802f78:	00 00 00 
  802f7b:	48 ba cc 46 80 00 00 	movabs $0x8046cc,%rdx
  802f82:	00 00 00 
  802f85:	be 85 00 00 00       	mov    $0x85,%esi
  802f8a:	48 bf e1 46 80 00 00 	movabs $0x8046e1,%rdi
  802f91:	00 00 00 
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	49 b8 8e 3c 80 00 00 	movabs $0x803c8e,%r8
  802fa0:	00 00 00 
  802fa3:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa9:	48 63 d0             	movslq %eax,%rdx
  802fac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb0:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fb7:	00 00 00 
  802fba:	48 89 c7             	mov    %rax,%rdi
  802fbd:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  802fc4:	00 00 00 
  802fc7:	ff d0                	callq  *%rax
	return r;
  802fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802fcc:	c9                   	leaveq 
  802fcd:	c3                   	retq   

0000000000802fce <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fce:	55                   	push   %rbp
  802fcf:	48 89 e5             	mov    %rsp,%rbp
  802fd2:	48 83 ec 30          	sub    $0x30,%rsp
  802fd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fde:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe6:	8b 50 0c             	mov    0xc(%rax),%edx
  802fe9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff0:	00 00 00 
  802ff3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ff5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ffc:	00 00 00 
  802fff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803003:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  803007:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80300e:	00 
  80300f:	76 35                	jbe    803046 <devfile_write+0x78>
  803011:	48 b9 f8 46 80 00 00 	movabs $0x8046f8,%rcx
  803018:	00 00 00 
  80301b:	48 ba cc 46 80 00 00 	movabs $0x8046cc,%rdx
  803022:	00 00 00 
  803025:	be 9e 00 00 00       	mov    $0x9e,%esi
  80302a:	48 bf e1 46 80 00 00 	movabs $0x8046e1,%rdi
  803031:	00 00 00 
  803034:	b8 00 00 00 00       	mov    $0x0,%eax
  803039:	49 b8 8e 3c 80 00 00 	movabs $0x803c8e,%r8
  803040:	00 00 00 
  803043:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803046:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80304a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80304e:	48 89 c6             	mov    %rax,%rsi
  803051:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803058:	00 00 00 
  80305b:	48 b8 83 14 80 00 00 	movabs $0x801483,%rax
  803062:	00 00 00 
  803065:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803067:	be 00 00 00 00       	mov    $0x0,%esi
  80306c:	bf 04 00 00 00       	mov    $0x4,%edi
  803071:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
  80307d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803080:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803084:	79 05                	jns    80308b <devfile_write+0xbd>
		return r;
  803086:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803089:	eb 43                	jmp    8030ce <devfile_write+0x100>
	assert(r <= n);
  80308b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308e:	48 98                	cltq   
  803090:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803094:	76 35                	jbe    8030cb <devfile_write+0xfd>
  803096:	48 b9 c5 46 80 00 00 	movabs $0x8046c5,%rcx
  80309d:	00 00 00 
  8030a0:	48 ba cc 46 80 00 00 	movabs $0x8046cc,%rdx
  8030a7:	00 00 00 
  8030aa:	be a2 00 00 00       	mov    $0xa2,%esi
  8030af:	48 bf e1 46 80 00 00 	movabs $0x8046e1,%rdi
  8030b6:	00 00 00 
  8030b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030be:	49 b8 8e 3c 80 00 00 	movabs $0x803c8e,%r8
  8030c5:	00 00 00 
  8030c8:	41 ff d0             	callq  *%r8
	return r;
  8030cb:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8030ce:	c9                   	leaveq 
  8030cf:	c3                   	retq   

00000000008030d0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030d0:	55                   	push   %rbp
  8030d1:	48 89 e5             	mov    %rsp,%rbp
  8030d4:	48 83 ec 20          	sub    $0x20,%rsp
  8030d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8030e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ee:	00 00 00 
  8030f1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030f3:	be 00 00 00 00       	mov    $0x0,%esi
  8030f8:	bf 05 00 00 00       	mov    $0x5,%edi
  8030fd:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  803104:	00 00 00 
  803107:	ff d0                	callq  *%rax
  803109:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803110:	79 05                	jns    803117 <devfile_stat+0x47>
		return r;
  803112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803115:	eb 56                	jmp    80316d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803117:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803122:	00 00 00 
  803125:	48 89 c7             	mov    %rax,%rdi
  803128:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803134:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80313b:	00 00 00 
  80313e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803144:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803148:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80314e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803155:	00 00 00 
  803158:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80315e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803162:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803168:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80316d:	c9                   	leaveq 
  80316e:	c3                   	retq   

000000000080316f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80316f:	55                   	push   %rbp
  803170:	48 89 e5             	mov    %rsp,%rbp
  803173:	48 83 ec 10          	sub    $0x10,%rsp
  803177:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80317b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80317e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803182:	8b 50 0c             	mov    0xc(%rax),%edx
  803185:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80318c:	00 00 00 
  80318f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803191:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803198:	00 00 00 
  80319b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80319e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031a1:	be 00 00 00 00       	mov    $0x0,%esi
  8031a6:	bf 02 00 00 00       	mov    $0x2,%edi
  8031ab:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  8031b2:	00 00 00 
  8031b5:	ff d0                	callq  *%rax
}
  8031b7:	c9                   	leaveq 
  8031b8:	c3                   	retq   

00000000008031b9 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031b9:	55                   	push   %rbp
  8031ba:	48 89 e5             	mov    %rsp,%rbp
  8031bd:	48 83 ec 10          	sub    $0x10,%rsp
  8031c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c9:	48 89 c7             	mov    %rax,%rdi
  8031cc:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
  8031d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031dd:	7e 07                	jle    8031e6 <remove+0x2d>
		return -E_BAD_PATH;
  8031df:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031e4:	eb 33                	jmp    803219 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ea:	48 89 c6             	mov    %rax,%rsi
  8031ed:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031f4:	00 00 00 
  8031f7:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803203:	be 00 00 00 00       	mov    $0x0,%esi
  803208:	bf 07 00 00 00       	mov    $0x7,%edi
  80320d:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  803214:	00 00 00 
  803217:	ff d0                	callq  *%rax
}
  803219:	c9                   	leaveq 
  80321a:	c3                   	retq   

000000000080321b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80321b:	55                   	push   %rbp
  80321c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80321f:	be 00 00 00 00       	mov    $0x0,%esi
  803224:	bf 08 00 00 00       	mov    $0x8,%edi
  803229:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
}
  803235:	5d                   	pop    %rbp
  803236:	c3                   	retq   

0000000000803237 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803237:	55                   	push   %rbp
  803238:	48 89 e5             	mov    %rsp,%rbp
  80323b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803242:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803249:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803250:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803257:	be 00 00 00 00       	mov    $0x0,%esi
  80325c:	48 89 c7             	mov    %rax,%rdi
  80325f:	48 b8 b7 2d 80 00 00 	movabs $0x802db7,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
  80326b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80326e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803272:	79 28                	jns    80329c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803277:	89 c6                	mov    %eax,%esi
  803279:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  803280:	00 00 00 
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
  803288:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
  80328f:	00 00 00 
  803292:	ff d2                	callq  *%rdx
		return fd_src;
  803294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803297:	e9 74 01 00 00       	jmpq   803410 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80329c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032a3:	be 01 01 00 00       	mov    $0x101,%esi
  8032a8:	48 89 c7             	mov    %rax,%rdi
  8032ab:	48 b8 b7 2d 80 00 00 	movabs $0x802db7,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
  8032b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032be:	79 39                	jns    8032f9 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032c3:	89 c6                	mov    %eax,%esi
  8032c5:	48 bf 3b 47 80 00 00 	movabs $0x80473b,%rdi
  8032cc:	00 00 00 
  8032cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d4:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
  8032db:	00 00 00 
  8032de:	ff d2                	callq  *%rdx
		close(fd_src);
  8032e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e3:	89 c7                	mov    %eax,%edi
  8032e5:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  8032ec:	00 00 00 
  8032ef:	ff d0                	callq  *%rax
		return fd_dest;
  8032f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032f4:	e9 17 01 00 00       	jmpq   803410 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032f9:	eb 74                	jmp    80336f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8032fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032fe:	48 63 d0             	movslq %eax,%rdx
  803301:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803308:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80330b:	48 89 ce             	mov    %rcx,%rsi
  80330e:	89 c7                	mov    %eax,%edi
  803310:	48 b8 2b 2a 80 00 00 	movabs $0x802a2b,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
  80331c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80331f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803323:	79 4a                	jns    80336f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803325:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803328:	89 c6                	mov    %eax,%esi
  80332a:	48 bf 55 47 80 00 00 	movabs $0x804755,%rdi
  803331:	00 00 00 
  803334:	b8 00 00 00 00       	mov    $0x0,%eax
  803339:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
  803340:	00 00 00 
  803343:	ff d2                	callq  *%rdx
			close(fd_src);
  803345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803348:	89 c7                	mov    %eax,%edi
  80334a:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
			close(fd_dest);
  803356:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803359:	89 c7                	mov    %eax,%edi
  80335b:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  803362:	00 00 00 
  803365:	ff d0                	callq  *%rax
			return write_size;
  803367:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80336a:	e9 a1 00 00 00       	jmpq   803410 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80336f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803379:	ba 00 02 00 00       	mov    $0x200,%edx
  80337e:	48 89 ce             	mov    %rcx,%rsi
  803381:	89 c7                	mov    %eax,%edi
  803383:	48 b8 e1 28 80 00 00 	movabs $0x8028e1,%rax
  80338a:	00 00 00 
  80338d:	ff d0                	callq  *%rax
  80338f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803392:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803396:	0f 8f 5f ff ff ff    	jg     8032fb <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80339c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033a0:	79 47                	jns    8033e9 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a5:	89 c6                	mov    %eax,%esi
  8033a7:	48 bf 68 47 80 00 00 	movabs $0x804768,%rdi
  8033ae:	00 00 00 
  8033b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b6:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
  8033bd:	00 00 00 
  8033c0:	ff d2                	callq  *%rdx
		close(fd_src);
  8033c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c5:	89 c7                	mov    %eax,%edi
  8033c7:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
		close(fd_dest);
  8033d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d6:	89 c7                	mov    %eax,%edi
  8033d8:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
		return read_size;
  8033e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033e7:	eb 27                	jmp    803410 <copy+0x1d9>
	}
	close(fd_src);
  8033e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ec:	89 c7                	mov    %eax,%edi
  8033ee:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  8033f5:	00 00 00 
  8033f8:	ff d0                	callq  *%rax
	close(fd_dest);
  8033fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033fd:	89 c7                	mov    %eax,%edi
  8033ff:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
	return 0;
  80340b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803410:	c9                   	leaveq 
  803411:	c3                   	retq   

0000000000803412 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803412:	55                   	push   %rbp
  803413:	48 89 e5             	mov    %rsp,%rbp
  803416:	53                   	push   %rbx
  803417:	48 83 ec 38          	sub    $0x38,%rsp
  80341b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80341f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803423:	48 89 c7             	mov    %rax,%rdi
  803426:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  80342d:	00 00 00 
  803430:	ff d0                	callq  *%rax
  803432:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803435:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803439:	0f 88 bf 01 00 00    	js     8035fe <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80343f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803443:	ba 07 04 00 00       	mov    $0x407,%edx
  803448:	48 89 c6             	mov    %rax,%rsi
  80344b:	bf 00 00 00 00       	mov    $0x0,%edi
  803450:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
  80345c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80345f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803463:	0f 88 95 01 00 00    	js     8035fe <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803469:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80346d:	48 89 c7             	mov    %rax,%rdi
  803470:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80347f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803483:	0f 88 5d 01 00 00    	js     8035e6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803489:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80348d:	ba 07 04 00 00       	mov    $0x407,%edx
  803492:	48 89 c6             	mov    %rax,%rsi
  803495:	bf 00 00 00 00       	mov    $0x0,%edi
  80349a:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
  8034a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ad:	0f 88 33 01 00 00    	js     8035e6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8034b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b7:	48 89 c7             	mov    %rax,%rdi
  8034ba:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  8034c1:	00 00 00 
  8034c4:	ff d0                	callq  *%rax
  8034c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8034d3:	48 89 c6             	mov    %rax,%rsi
  8034d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8034db:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  8034e2:	00 00 00 
  8034e5:	ff d0                	callq  *%rax
  8034e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ee:	79 05                	jns    8034f5 <pipe+0xe3>
		goto err2;
  8034f0:	e9 d9 00 00 00       	jmpq   8035ce <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034f9:	48 89 c7             	mov    %rax,%rdi
  8034fc:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
  803508:	48 89 c2             	mov    %rax,%rdx
  80350b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80350f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803515:	48 89 d1             	mov    %rdx,%rcx
  803518:	ba 00 00 00 00       	mov    $0x0,%edx
  80351d:	48 89 c6             	mov    %rax,%rsi
  803520:	bf 00 00 00 00       	mov    $0x0,%edi
  803525:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	callq  *%rax
  803531:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803534:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803538:	79 1b                	jns    803555 <pipe+0x143>
		goto err3;
  80353a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80353b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353f:	48 89 c6             	mov    %rax,%rsi
  803542:	bf 00 00 00 00       	mov    $0x0,%edi
  803547:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
  803553:	eb 79                	jmp    8035ce <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803559:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803560:	00 00 00 
  803563:	8b 12                	mov    (%rdx),%edx
  803565:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80356b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803576:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80357d:	00 00 00 
  803580:	8b 12                	mov    (%rdx),%edx
  803582:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803584:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803588:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80358f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803593:	48 89 c7             	mov    %rax,%rdi
  803596:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
  8035a2:	89 c2                	mov    %eax,%edx
  8035a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035a8:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8035aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035ae:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8035b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b6:	48 89 c7             	mov    %rax,%rdi
  8035b9:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  8035c0:	00 00 00 
  8035c3:	ff d0                	callq  *%rax
  8035c5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8035c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cc:	eb 33                	jmp    803601 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8035ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d2:	48 89 c6             	mov    %rax,%rsi
  8035d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8035da:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8035e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ea:	48 89 c6             	mov    %rax,%rsi
  8035ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f2:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
err:
	return r;
  8035fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803601:	48 83 c4 38          	add    $0x38,%rsp
  803605:	5b                   	pop    %rbx
  803606:	5d                   	pop    %rbp
  803607:	c3                   	retq   

0000000000803608 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803608:	55                   	push   %rbp
  803609:	48 89 e5             	mov    %rsp,%rbp
  80360c:	53                   	push   %rbx
  80360d:	48 83 ec 28          	sub    $0x28,%rsp
  803611:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803615:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803619:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803620:	00 00 00 
  803623:	48 8b 00             	mov    (%rax),%rax
  803626:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80362c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80362f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803633:	48 89 c7             	mov    %rax,%rdi
  803636:	48 b8 ec 3e 80 00 00 	movabs $0x803eec,%rax
  80363d:	00 00 00 
  803640:	ff d0                	callq  *%rax
  803642:	89 c3                	mov    %eax,%ebx
  803644:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803648:	48 89 c7             	mov    %rax,%rdi
  80364b:	48 b8 ec 3e 80 00 00 	movabs $0x803eec,%rax
  803652:	00 00 00 
  803655:	ff d0                	callq  *%rax
  803657:	39 c3                	cmp    %eax,%ebx
  803659:	0f 94 c0             	sete   %al
  80365c:	0f b6 c0             	movzbl %al,%eax
  80365f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803662:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803669:	00 00 00 
  80366c:	48 8b 00             	mov    (%rax),%rax
  80366f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803675:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803678:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80367b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80367e:	75 05                	jne    803685 <_pipeisclosed+0x7d>
			return ret;
  803680:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803683:	eb 4f                	jmp    8036d4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803685:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803688:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80368b:	74 42                	je     8036cf <_pipeisclosed+0xc7>
  80368d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803691:	75 3c                	jne    8036cf <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803693:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80369a:	00 00 00 
  80369d:	48 8b 00             	mov    (%rax),%rax
  8036a0:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8036a6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ac:	89 c6                	mov    %eax,%esi
  8036ae:	48 bf 83 47 80 00 00 	movabs $0x804783,%rdi
  8036b5:	00 00 00 
  8036b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bd:	49 b8 80 04 80 00 00 	movabs $0x800480,%r8
  8036c4:	00 00 00 
  8036c7:	41 ff d0             	callq  *%r8
	}
  8036ca:	e9 4a ff ff ff       	jmpq   803619 <_pipeisclosed+0x11>
  8036cf:	e9 45 ff ff ff       	jmpq   803619 <_pipeisclosed+0x11>
}
  8036d4:	48 83 c4 28          	add    $0x28,%rsp
  8036d8:	5b                   	pop    %rbx
  8036d9:	5d                   	pop    %rbp
  8036da:	c3                   	retq   

00000000008036db <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8036db:	55                   	push   %rbp
  8036dc:	48 89 e5             	mov    %rsp,%rbp
  8036df:	48 83 ec 30          	sub    $0x30,%rsp
  8036e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036ed:	48 89 d6             	mov    %rdx,%rsi
  8036f0:	89 c7                	mov    %eax,%edi
  8036f2:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
  8036fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803705:	79 05                	jns    80370c <pipeisclosed+0x31>
		return r;
  803707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370a:	eb 31                	jmp    80373d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80370c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803710:	48 89 c7             	mov    %rax,%rdi
  803713:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  80371a:	00 00 00 
  80371d:	ff d0                	callq  *%rax
  80371f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803727:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80372b:	48 89 d6             	mov    %rdx,%rsi
  80372e:	48 89 c7             	mov    %rax,%rdi
  803731:	48 b8 08 36 80 00 00 	movabs $0x803608,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
}
  80373d:	c9                   	leaveq 
  80373e:	c3                   	retq   

000000000080373f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80373f:	55                   	push   %rbp
  803740:	48 89 e5             	mov    %rsp,%rbp
  803743:	48 83 ec 40          	sub    $0x40,%rsp
  803747:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80374b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80374f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803757:	48 89 c7             	mov    %rax,%rdi
  80375a:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  803761:	00 00 00 
  803764:	ff d0                	callq  *%rax
  803766:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80376a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803772:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803779:	00 
  80377a:	e9 92 00 00 00       	jmpq   803811 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80377f:	eb 41                	jmp    8037c2 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803781:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803786:	74 09                	je     803791 <devpipe_read+0x52>
				return i;
  803788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378c:	e9 92 00 00 00       	jmpq   803823 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803791:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803799:	48 89 d6             	mov    %rdx,%rsi
  80379c:	48 89 c7             	mov    %rax,%rdi
  80379f:	48 b8 08 36 80 00 00 	movabs $0x803608,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 07                	je     8037b6 <devpipe_read+0x77>
				return 0;
  8037af:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b4:	eb 6d                	jmp    803823 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8037b6:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c6:	8b 10                	mov    (%rax),%edx
  8037c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cc:	8b 40 04             	mov    0x4(%rax),%eax
  8037cf:	39 c2                	cmp    %eax,%edx
  8037d1:	74 ae                	je     803781 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037db:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8037df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e3:	8b 00                	mov    (%rax),%eax
  8037e5:	99                   	cltd   
  8037e6:	c1 ea 1b             	shr    $0x1b,%edx
  8037e9:	01 d0                	add    %edx,%eax
  8037eb:	83 e0 1f             	and    $0x1f,%eax
  8037ee:	29 d0                	sub    %edx,%eax
  8037f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037f4:	48 98                	cltq   
  8037f6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037fb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803801:	8b 00                	mov    (%rax),%eax
  803803:	8d 50 01             	lea    0x1(%rax),%edx
  803806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80380c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803811:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803815:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803819:	0f 82 60 ff ff ff    	jb     80377f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80381f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803823:	c9                   	leaveq 
  803824:	c3                   	retq   

0000000000803825 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803825:	55                   	push   %rbp
  803826:	48 89 e5             	mov    %rsp,%rbp
  803829:	48 83 ec 40          	sub    $0x40,%rsp
  80382d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803831:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803835:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383d:	48 89 c7             	mov    %rax,%rdi
  803840:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  803847:	00 00 00 
  80384a:	ff d0                	callq  *%rax
  80384c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803850:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803854:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803858:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80385f:	00 
  803860:	e9 8e 00 00 00       	jmpq   8038f3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803865:	eb 31                	jmp    803898 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803867:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80386b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80386f:	48 89 d6             	mov    %rdx,%rsi
  803872:	48 89 c7             	mov    %rax,%rdi
  803875:	48 b8 08 36 80 00 00 	movabs $0x803608,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
  803881:	85 c0                	test   %eax,%eax
  803883:	74 07                	je     80388c <devpipe_write+0x67>
				return 0;
  803885:	b8 00 00 00 00       	mov    $0x0,%eax
  80388a:	eb 79                	jmp    803905 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80388c:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  803893:	00 00 00 
  803896:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389c:	8b 40 04             	mov    0x4(%rax),%eax
  80389f:	48 63 d0             	movslq %eax,%rdx
  8038a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a6:	8b 00                	mov    (%rax),%eax
  8038a8:	48 98                	cltq   
  8038aa:	48 83 c0 20          	add    $0x20,%rax
  8038ae:	48 39 c2             	cmp    %rax,%rdx
  8038b1:	73 b4                	jae    803867 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8038b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b7:	8b 40 04             	mov    0x4(%rax),%eax
  8038ba:	99                   	cltd   
  8038bb:	c1 ea 1b             	shr    $0x1b,%edx
  8038be:	01 d0                	add    %edx,%eax
  8038c0:	83 e0 1f             	and    $0x1f,%eax
  8038c3:	29 d0                	sub    %edx,%eax
  8038c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038c9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8038cd:	48 01 ca             	add    %rcx,%rdx
  8038d0:	0f b6 0a             	movzbl (%rdx),%ecx
  8038d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038d7:	48 98                	cltq   
  8038d9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8038dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e1:	8b 40 04             	mov    0x4(%rax),%eax
  8038e4:	8d 50 01             	lea    0x1(%rax),%edx
  8038e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038eb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038fb:	0f 82 64 ff ff ff    	jb     803865 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803905:	c9                   	leaveq 
  803906:	c3                   	retq   

0000000000803907 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803907:	55                   	push   %rbp
  803908:	48 89 e5             	mov    %rsp,%rbp
  80390b:	48 83 ec 20          	sub    $0x20,%rsp
  80390f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803913:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391b:	48 89 c7             	mov    %rax,%rdi
  80391e:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
  80392a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80392e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803932:	48 be 96 47 80 00 00 	movabs $0x804796,%rsi
  803939:	00 00 00 
  80393c:	48 89 c7             	mov    %rax,%rdi
  80393f:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  803946:	00 00 00 
  803949:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80394b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394f:	8b 50 04             	mov    0x4(%rax),%edx
  803952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803956:	8b 00                	mov    (%rax),%eax
  803958:	29 c2                	sub    %eax,%edx
  80395a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80395e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803968:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80396f:	00 00 00 
	stat->st_dev = &devpipe;
  803972:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803976:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80397d:	00 00 00 
  803980:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80398c:	c9                   	leaveq 
  80398d:	c3                   	retq   

000000000080398e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80398e:	55                   	push   %rbp
  80398f:	48 89 e5             	mov    %rsp,%rbp
  803992:	48 83 ec 10          	sub    $0x10,%rsp
  803996:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80399a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399e:	48 89 c6             	mov    %rax,%rsi
  8039a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039a6:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8039ad:	00 00 00 
  8039b0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8039b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b6:	48 89 c7             	mov    %rax,%rdi
  8039b9:	48 b8 ec 23 80 00 00 	movabs $0x8023ec,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
  8039c5:	48 89 c6             	mov    %rax,%rsi
  8039c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039cd:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8039d4:	00 00 00 
  8039d7:	ff d0                	callq  *%rax
}
  8039d9:	c9                   	leaveq 
  8039da:	c3                   	retq   

00000000008039db <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8039db:	55                   	push   %rbp
  8039dc:	48 89 e5             	mov    %rsp,%rbp
  8039df:	48 83 ec 20          	sub    $0x20,%rsp
  8039e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8039e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8039ec:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8039f0:	be 01 00 00 00       	mov    $0x1,%esi
  8039f5:	48 89 c7             	mov    %rax,%rdi
  8039f8:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  8039ff:	00 00 00 
  803a02:	ff d0                	callq  *%rax
}
  803a04:	c9                   	leaveq 
  803a05:	c3                   	retq   

0000000000803a06 <getchar>:

int
getchar(void)
{
  803a06:	55                   	push   %rbp
  803a07:	48 89 e5             	mov    %rsp,%rbp
  803a0a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a0e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a12:	ba 01 00 00 00       	mov    $0x1,%edx
  803a17:	48 89 c6             	mov    %rax,%rsi
  803a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1f:	48 b8 e1 28 80 00 00 	movabs $0x8028e1,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
  803a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a32:	79 05                	jns    803a39 <getchar+0x33>
		return r;
  803a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a37:	eb 14                	jmp    803a4d <getchar+0x47>
	if (r < 1)
  803a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3d:	7f 07                	jg     803a46 <getchar+0x40>
		return -E_EOF;
  803a3f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803a44:	eb 07                	jmp    803a4d <getchar+0x47>
	return c;
  803a46:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803a4a:	0f b6 c0             	movzbl %al,%eax
}
  803a4d:	c9                   	leaveq 
  803a4e:	c3                   	retq   

0000000000803a4f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803a4f:	55                   	push   %rbp
  803a50:	48 89 e5             	mov    %rsp,%rbp
  803a53:	48 83 ec 20          	sub    $0x20,%rsp
  803a57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a61:	48 89 d6             	mov    %rdx,%rsi
  803a64:	89 c7                	mov    %eax,%edi
  803a66:	48 b8 af 24 80 00 00 	movabs $0x8024af,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
  803a72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a79:	79 05                	jns    803a80 <iscons+0x31>
		return r;
  803a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7e:	eb 1a                	jmp    803a9a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a84:	8b 10                	mov    (%rax),%edx
  803a86:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803a8d:	00 00 00 
  803a90:	8b 00                	mov    (%rax),%eax
  803a92:	39 c2                	cmp    %eax,%edx
  803a94:	0f 94 c0             	sete   %al
  803a97:	0f b6 c0             	movzbl %al,%eax
}
  803a9a:	c9                   	leaveq 
  803a9b:	c3                   	retq   

0000000000803a9c <opencons>:

int
opencons(void)
{
  803a9c:	55                   	push   %rbp
  803a9d:	48 89 e5             	mov    %rsp,%rbp
  803aa0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803aa4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803aa8:	48 89 c7             	mov    %rax,%rdi
  803aab:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
  803ab7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abe:	79 05                	jns    803ac5 <opencons+0x29>
		return r;
  803ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac3:	eb 5b                	jmp    803b20 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ac5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac9:	ba 07 04 00 00       	mov    $0x407,%edx
  803ace:	48 89 c6             	mov    %rax,%rsi
  803ad1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad6:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  803add:	00 00 00 
  803ae0:	ff d0                	callq  *%rax
  803ae2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae9:	79 05                	jns    803af0 <opencons+0x54>
		return r;
  803aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aee:	eb 30                	jmp    803b20 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af4:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803afb:	00 00 00 
  803afe:	8b 12                	mov    (%rdx),%edx
  803b00:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b06:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b11:	48 89 c7             	mov    %rax,%rdi
  803b14:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  803b1b:	00 00 00 
  803b1e:	ff d0                	callq  *%rax
}
  803b20:	c9                   	leaveq 
  803b21:	c3                   	retq   

0000000000803b22 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b22:	55                   	push   %rbp
  803b23:	48 89 e5             	mov    %rsp,%rbp
  803b26:	48 83 ec 30          	sub    $0x30,%rsp
  803b2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b32:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803b36:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b3b:	75 07                	jne    803b44 <devcons_read+0x22>
		return 0;
  803b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b42:	eb 4b                	jmp    803b8f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803b44:	eb 0c                	jmp    803b52 <devcons_read+0x30>
		sys_yield();
  803b46:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  803b4d:	00 00 00 
  803b50:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b52:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
  803b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b65:	74 df                	je     803b46 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6b:	79 05                	jns    803b72 <devcons_read+0x50>
		return c;
  803b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b70:	eb 1d                	jmp    803b8f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803b72:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803b76:	75 07                	jne    803b7f <devcons_read+0x5d>
		return 0;
  803b78:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7d:	eb 10                	jmp    803b8f <devcons_read+0x6d>
	*(char*)vbuf = c;
  803b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b82:	89 c2                	mov    %eax,%edx
  803b84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b88:	88 10                	mov    %dl,(%rax)
	return 1;
  803b8a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803b8f:	c9                   	leaveq 
  803b90:	c3                   	retq   

0000000000803b91 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b91:	55                   	push   %rbp
  803b92:	48 89 e5             	mov    %rsp,%rbp
  803b95:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803b9c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ba3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803baa:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bb8:	eb 76                	jmp    803c30 <devcons_write+0x9f>
		m = n - tot;
  803bba:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803bc1:	89 c2                	mov    %eax,%edx
  803bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc6:	29 c2                	sub    %eax,%edx
  803bc8:	89 d0                	mov    %edx,%eax
  803bca:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803bcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd0:	83 f8 7f             	cmp    $0x7f,%eax
  803bd3:	76 07                	jbe    803bdc <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803bd5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803bdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bdf:	48 63 d0             	movslq %eax,%rdx
  803be2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be5:	48 63 c8             	movslq %eax,%rcx
  803be8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803bef:	48 01 c1             	add    %rax,%rcx
  803bf2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803bf9:	48 89 ce             	mov    %rcx,%rsi
  803bfc:	48 89 c7             	mov    %rax,%rdi
  803bff:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  803c06:	00 00 00 
  803c09:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c0e:	48 63 d0             	movslq %eax,%rdx
  803c11:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c18:	48 89 d6             	mov    %rdx,%rsi
  803c1b:	48 89 c7             	mov    %rax,%rdi
  803c1e:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c2d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c33:	48 98                	cltq   
  803c35:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803c3c:	0f 82 78 ff ff ff    	jb     803bba <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803c42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c45:	c9                   	leaveq 
  803c46:	c3                   	retq   

0000000000803c47 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803c47:	55                   	push   %rbp
  803c48:	48 89 e5             	mov    %rsp,%rbp
  803c4b:	48 83 ec 08          	sub    $0x8,%rsp
  803c4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c58:	c9                   	leaveq 
  803c59:	c3                   	retq   

0000000000803c5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c5a:	55                   	push   %rbp
  803c5b:	48 89 e5             	mov    %rsp,%rbp
  803c5e:	48 83 ec 10          	sub    $0x10,%rsp
  803c62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6e:	48 be a2 47 80 00 00 	movabs $0x8047a2,%rsi
  803c75:	00 00 00 
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
	return 0;
  803c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c8c:	c9                   	leaveq 
  803c8d:	c3                   	retq   

0000000000803c8e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803c8e:	55                   	push   %rbp
  803c8f:	48 89 e5             	mov    %rsp,%rbp
  803c92:	53                   	push   %rbx
  803c93:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803c9a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ca1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803ca7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803cae:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803cb5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803cbc:	84 c0                	test   %al,%al
  803cbe:	74 23                	je     803ce3 <_panic+0x55>
  803cc0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803cc7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803ccb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ccf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803cd3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803cd7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803cdb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803cdf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803ce3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803cea:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803cf1:	00 00 00 
  803cf4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803cfb:	00 00 00 
  803cfe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803d02:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803d09:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803d10:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803d17:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803d1e:	00 00 00 
  803d21:	48 8b 18             	mov    (%rax),%rbx
  803d24:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  803d2b:	00 00 00 
  803d2e:	ff d0                	callq  *%rax
  803d30:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803d36:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803d3d:	41 89 c8             	mov    %ecx,%r8d
  803d40:	48 89 d1             	mov    %rdx,%rcx
  803d43:	48 89 da             	mov    %rbx,%rdx
  803d46:	89 c6                	mov    %eax,%esi
  803d48:	48 bf b0 47 80 00 00 	movabs $0x8047b0,%rdi
  803d4f:	00 00 00 
  803d52:	b8 00 00 00 00       	mov    $0x0,%eax
  803d57:	49 b9 80 04 80 00 00 	movabs $0x800480,%r9
  803d5e:	00 00 00 
  803d61:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803d64:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803d6b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803d72:	48 89 d6             	mov    %rdx,%rsi
  803d75:	48 89 c7             	mov    %rax,%rdi
  803d78:	48 b8 d4 03 80 00 00 	movabs $0x8003d4,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
	cprintf("\n");
  803d84:	48 bf d3 47 80 00 00 	movabs $0x8047d3,%rdi
  803d8b:	00 00 00 
  803d8e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d93:	48 ba 80 04 80 00 00 	movabs $0x800480,%rdx
  803d9a:	00 00 00 
  803d9d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803d9f:	cc                   	int3   
  803da0:	eb fd                	jmp    803d9f <_panic+0x111>

0000000000803da2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803da2:	55                   	push   %rbp
  803da3:	48 89 e5             	mov    %rsp,%rbp
  803da6:	48 83 ec 10          	sub    $0x10,%rsp
  803daa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803dae:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803db5:	00 00 00 
  803db8:	48 8b 00             	mov    (%rax),%rax
  803dbb:	48 85 c0             	test   %rax,%rax
  803dbe:	75 49                	jne    803e09 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803dc0:	ba 07 00 00 00       	mov    $0x7,%edx
  803dc5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803dca:	bf 00 00 00 00       	mov    $0x0,%edi
  803dcf:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  803dd6:	00 00 00 
  803dd9:	ff d0                	callq  *%rax
  803ddb:	85 c0                	test   %eax,%eax
  803ddd:	79 2a                	jns    803e09 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803ddf:	48 ba d8 47 80 00 00 	movabs $0x8047d8,%rdx
  803de6:	00 00 00 
  803de9:	be 21 00 00 00       	mov    $0x21,%esi
  803dee:	48 bf 03 48 80 00 00 	movabs $0x804803,%rdi
  803df5:	00 00 00 
  803df8:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfd:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  803e04:	00 00 00 
  803e07:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803e09:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803e10:	00 00 00 
  803e13:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e17:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803e1a:	48 be 65 3e 80 00 00 	movabs $0x803e65,%rsi
  803e21:	00 00 00 
  803e24:	bf 00 00 00 00       	mov    $0x0,%edi
  803e29:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  803e30:	00 00 00 
  803e33:	ff d0                	callq  *%rax
  803e35:	85 c0                	test   %eax,%eax
  803e37:	79 2a                	jns    803e63 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803e39:	48 ba 18 48 80 00 00 	movabs $0x804818,%rdx
  803e40:	00 00 00 
  803e43:	be 27 00 00 00       	mov    $0x27,%esi
  803e48:	48 bf 03 48 80 00 00 	movabs $0x804803,%rdi
  803e4f:	00 00 00 
  803e52:	b8 00 00 00 00       	mov    $0x0,%eax
  803e57:	48 b9 8e 3c 80 00 00 	movabs $0x803c8e,%rcx
  803e5e:	00 00 00 
  803e61:	ff d1                	callq  *%rcx
}
  803e63:	c9                   	leaveq 
  803e64:	c3                   	retq   

0000000000803e65 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803e65:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803e68:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803e6f:	00 00 00 
call *%rax
  803e72:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803e74:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803e7b:	00 
    movq 152(%rsp), %rcx
  803e7c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803e83:	00 
    subq $8, %rcx
  803e84:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803e88:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803e8b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803e92:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803e93:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803e97:	4c 8b 3c 24          	mov    (%rsp),%r15
  803e9b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803ea0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803ea5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803eaa:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803eaf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803eb4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803eb9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803ebe:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803ec3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803ec8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803ecd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803ed2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803ed7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803edc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803ee1:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803ee5:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803ee9:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803eea:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803eeb:	c3                   	retq   

0000000000803eec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803eec:	55                   	push   %rbp
  803eed:	48 89 e5             	mov    %rsp,%rbp
  803ef0:	48 83 ec 18          	sub    $0x18,%rsp
  803ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803efc:	48 c1 e8 15          	shr    $0x15,%rax
  803f00:	48 89 c2             	mov    %rax,%rdx
  803f03:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f0a:	01 00 00 
  803f0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f11:	83 e0 01             	and    $0x1,%eax
  803f14:	48 85 c0             	test   %rax,%rax
  803f17:	75 07                	jne    803f20 <pageref+0x34>
		return 0;
  803f19:	b8 00 00 00 00       	mov    $0x0,%eax
  803f1e:	eb 53                	jmp    803f73 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f24:	48 c1 e8 0c          	shr    $0xc,%rax
  803f28:	48 89 c2             	mov    %rax,%rdx
  803f2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f32:	01 00 00 
  803f35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f41:	83 e0 01             	and    $0x1,%eax
  803f44:	48 85 c0             	test   %rax,%rax
  803f47:	75 07                	jne    803f50 <pageref+0x64>
		return 0;
  803f49:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4e:	eb 23                	jmp    803f73 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f54:	48 c1 e8 0c          	shr    $0xc,%rax
  803f58:	48 89 c2             	mov    %rax,%rdx
  803f5b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f62:	00 00 00 
  803f65:	48 c1 e2 04          	shl    $0x4,%rdx
  803f69:	48 01 d0             	add    %rdx,%rax
  803f6c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f70:	0f b7 c0             	movzwl %ax,%eax
}
  803f73:	c9                   	leaveq 
  803f74:	c3                   	retq   
