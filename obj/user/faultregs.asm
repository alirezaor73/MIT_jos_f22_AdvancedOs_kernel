
obj/user/faultregs:     file format elf64-x86-64


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
  80003c:	e8 f5 09 00 00       	callq  800a36 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800057:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  80005f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006e:	48 89 d1             	mov    %rdx,%rcx
  800071:	48 89 c2             	mov    %rax,%rdx
  800074:	48 be 80 25 80 00 00 	movabs $0x802580,%rsi
  80007b:	00 00 00 
  80007e:	48 bf 81 25 80 00 00 	movabs $0x802581,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800094:	00 00 00 
  800097:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009e:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a6:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000aa:	48 89 d1             	mov    %rdx,%rcx
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 be 91 25 80 00 00 	movabs $0x802591,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80011e:	00 00 00 
  800121:	ff d2                	callq  *%rdx
  800123:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012e:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800136:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013a:	48 89 d1             	mov    %rdx,%rcx
  80013d:	48 89 c2             	mov    %rax,%rdx
  800140:	48 be b3 25 80 00 00 	movabs $0x8025b3,%rsi
  800147:	00 00 00 
  80014a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8001ae:	00 00 00 
  8001b1:	ff d2                	callq  *%rdx
  8001b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001be:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c6:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	48 be b7 25 80 00 00 	movabs $0x8025b7,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	callq  *%rdx
  800243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024e:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800256:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025a:	48 89 d1             	mov    %rdx,%rcx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	48 be bb 25 80 00 00 	movabs $0x8025bb,%rsi
  800267:	00 00 00 
  80026a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8002ce:	00 00 00 
  8002d1:	ff d2                	callq  *%rdx
  8002d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002de:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e6:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002ea:	48 89 d1             	mov    %rdx,%rcx
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 be bf 25 80 00 00 	movabs $0x8025bf,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	callq  *%rdx
  800363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036e:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	48 be c3 25 80 00 00 	movabs $0x8025c3,%rsi
  800387:	00 00 00 
  80038a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8003ee:	00 00 00 
  8003f1:	ff d2                	callq  *%rdx
  8003f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003fe:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	48 be c7 25 80 00 00 	movabs $0x8025c7,%rsi
  800417:	00 00 00 
  80041a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80047e:	00 00 00 
  800481:	ff d2                	callq  *%rdx
  800483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048e:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	48 be cb 25 80 00 00 	movabs $0x8025cb,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80050e:	00 00 00 
  800511:	ff d2                	callq  *%rdx
  800513:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051e:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800530:	48 89 d1             	mov    %rdx,%rcx
  800533:	48 89 c2             	mov    %rax,%rdx
  800536:	48 be cf 25 80 00 00 	movabs $0x8025cf,%rsi
  80053d:	00 00 00 
  800540:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8005aa:	00 00 00 
  8005ad:	ff d2                	callq  *%rdx
  8005af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ba:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cc:	48 89 d1             	mov    %rdx,%rcx
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 be d6 25 80 00 00 	movabs $0x8025d6,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK


	if (!mismatch)
  800652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800656:	75 24                	jne    80067c <check_regs+0x639>
		cprintf("Registers %s OK\n", testname);
  800658:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80065c:	48 89 c6             	mov    %rax,%rsi
  80065f:	48 bf da 25 80 00 00 	movabs $0x8025da,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf eb 25 80 00 00 	movabs $0x8025eb,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 20          	sub    $0x20,%rsp
  8006a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006b9:	74 43                	je     8006fe <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	49 89 d0             	mov    %rdx,%r8
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba 08 26 80 00 00 	movabs $0x802608,%rdx
  8006da:	00 00 00 
  8006dd:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e2:	48 bf 39 26 80 00 00 	movabs $0x802639,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 de 0a 80 00 00 	movabs $0x800ade,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  800705:	00 00 00 
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  80071f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800723:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  800727:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80072b:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  80072f:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800733:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  800737:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80073b:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  80073f:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800743:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  800747:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80074b:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  80074f:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800753:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  800757:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80075b:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  80075f:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800763:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  800767:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80076b:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  80076f:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800773:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  800777:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80077b:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800782:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800791:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 4a 26 80 00 00 	movabs $0x80264a,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 58 26 80 00 00 	movabs $0x802658,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be 5f 26 80 00 00 	movabs $0x80265f,%rsi
  800804:	00 00 00 
  800807:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  80080e:	00 00 00 
  800811:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081d:	ba 07 00 00 00       	mov    $0x7,%edx
  800822:	be 00 00 40 00       	mov    $0x400000,%esi
  800827:	bf 00 00 00 00       	mov    $0x0,%edi
  80082c:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  800833:	00 00 00 
  800836:	ff d0                	callq  *%rax
  800838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80083f:	79 30                	jns    800871 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800844:	89 c1                	mov    %eax,%ecx
  800846:	48 ba 66 26 80 00 00 	movabs $0x802666,%rdx
  80084d:	00 00 00 
  800850:	be 6a 00 00 00       	mov    $0x6a,%esi
  800855:	48 bf 39 26 80 00 00 	movabs $0x802639,%rdi
  80085c:	00 00 00 
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 de 0a 80 00 00 	movabs $0x800ade,%r8
  80086b:	00 00 00 
  80086e:	41 ff d0             	callq  *%r8
}
  800871:	c9                   	leaveq 
  800872:	c3                   	retq   

0000000000800873 <umain>:

void
umain(int argc, char **argv)
{
  800873:	55                   	push   %rbp
  800874:	48 89 e5             	mov    %rsp,%rbp
  800877:	48 83 ec 10          	sub    $0x10,%rsp
  80087b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800882:	48 bf a0 06 80 00 00 	movabs $0x8006a0,%rdi
  800889:	00 00 00 
  80088c:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  8008a9:	00 00 00 
  8008ac:	50                   	push   %rax
  8008ad:	52                   	push   %rdx
  8008ae:	50                   	push   %rax
  8008af:	9c                   	pushfq 
  8008b0:	58                   	pop    %rax
  8008b1:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008b7:	50                   	push   %rax
  8008b8:	9d                   	popfq  
  8008b9:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008be:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008c5:	48 8d 04 25 11 09 80 	lea    0x800911,%rax
  8008cc:	00 
  8008cd:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008d1:	58                   	pop    %rax
  8008d2:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008d6:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008da:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008de:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008e2:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008e6:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008ea:	4d 89 47 38          	mov    %r8,0x38(%r15)
  8008ee:	49 89 77 40          	mov    %rsi,0x40(%r15)
  8008f2:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  8008f6:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  8008fa:	49 89 57 58          	mov    %rdx,0x58(%r15)
  8008fe:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800902:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800906:	49 89 47 70          	mov    %rax,0x70(%r15)
  80090a:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800911:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800918:	2a 00 00 00 
  80091c:	4c 8b 3c 24          	mov    (%rsp),%r15
  800920:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800924:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800928:	4d 89 67 18          	mov    %r12,0x18(%r15)
  80092c:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800930:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800934:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800938:	4d 89 47 38          	mov    %r8,0x38(%r15)
  80093c:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800940:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800944:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800948:	49 89 57 58          	mov    %rdx,0x58(%r15)
  80094c:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800950:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800954:	49 89 47 70          	mov    %rax,0x70(%r15)
  800958:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  80095f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800964:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800968:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  80096c:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800970:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800974:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800978:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  80097c:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800980:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800984:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800988:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  80098c:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800990:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800994:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800998:	49 8b 47 70          	mov    0x70(%r15),%rax
  80099c:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009a3:	50                   	push   %rax
  8009a4:	9c                   	pushfq 
  8009a5:	58                   	pop    %rax
  8009a6:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009ab:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009b2:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009b3:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	83 f8 2a             	cmp    $0x2a,%eax
  8009bd:	74 1b                	je     8009da <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009bf:	48 bf 80 26 80 00 00 	movabs $0x802680,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 9f 26 80 00 00 	movabs $0x80269f,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 b0 26 80 00 00 	movabs $0x8026b0,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800a11:	00 00 00 
  800a14:	48 be 5f 26 80 00 00 	movabs $0x80265f,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  800a25:	00 00 00 
  800a28:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
}
  800a34:	c9                   	leaveq 
  800a35:	c3                   	retq   

0000000000800a36 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a36:	55                   	push   %rbp
  800a37:	48 89 e5             	mov    %rsp,%rbp
  800a3a:	48 83 ec 20          	sub    $0x20,%rsp
  800a3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800a41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800a45:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a57:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a5c:	48 63 d0             	movslq %eax,%rdx
  800a5f:	48 89 d0             	mov    %rdx,%rax
  800a62:	48 c1 e0 03          	shl    $0x3,%rax
  800a66:	48 01 d0             	add    %rdx,%rax
  800a69:	48 c1 e0 05          	shl    $0x5,%rax
  800a6d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800a74:	00 00 00 
  800a77:	48 01 c2             	add    %rax,%rdx
  800a7a:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  800a81:	00 00 00 
  800a84:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800a8b:	7e 14                	jle    800aa1 <libmain+0x6b>
		binaryname = argv[0];
  800a8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a91:	48 8b 10             	mov    (%rax),%rdx
  800a94:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800a9b:	00 00 00 
  800a9e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800aa1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800aa5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800aa8:	48 89 d6             	mov    %rdx,%rsi
  800aab:	89 c7                	mov    %eax,%edi
  800aad:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ab9:	48 b8 c7 0a 80 00 00 	movabs $0x800ac7,%rax
  800ac0:	00 00 00 
  800ac3:	ff d0                	callq  *%rax
}
  800ac5:	c9                   	leaveq 
  800ac6:	c3                   	retq   

0000000000800ac7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ac7:	55                   	push   %rbp
  800ac8:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800acb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad0:	48 b8 4e 21 80 00 00 	movabs $0x80214e,%rax
  800ad7:	00 00 00 
  800ada:	ff d0                	callq  *%rax
}
  800adc:	5d                   	pop    %rbp
  800add:	c3                   	retq   

0000000000800ade <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ade:	55                   	push   %rbp
  800adf:	48 89 e5             	mov    %rsp,%rbp
  800ae2:	53                   	push   %rbx
  800ae3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800aea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800af1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800af7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800afe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b05:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b0c:	84 c0                	test   %al,%al
  800b0e:	74 23                	je     800b33 <_panic+0x55>
  800b10:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b17:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b1b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b1f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b23:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b27:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b2b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b2f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b33:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b3a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b41:	00 00 00 
  800b44:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b4b:	00 00 00 
  800b4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b52:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b59:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b67:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800b6e:	00 00 00 
  800b71:	48 8b 18             	mov    (%rax),%rbx
  800b74:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  800b7b:	00 00 00 
  800b7e:	ff d0                	callq  *%rax
  800b80:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b86:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b8d:	41 89 c8             	mov    %ecx,%r8d
  800b90:	48 89 d1             	mov    %rdx,%rcx
  800b93:	48 89 da             	mov    %rbx,%rdx
  800b96:	89 c6                	mov    %eax,%esi
  800b98:	48 bf c0 26 80 00 00 	movabs $0x8026c0,%rdi
  800b9f:	00 00 00 
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba7:	49 b9 17 0d 80 00 00 	movabs $0x800d17,%r9
  800bae:	00 00 00 
  800bb1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bb4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bbb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bc2:	48 89 d6             	mov    %rdx,%rsi
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
	cprintf("\n");
  800bd4:	48 bf e3 26 80 00 00 	movabs $0x8026e3,%rdi
  800bdb:	00 00 00 
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
  800be3:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800bea:	00 00 00 
  800bed:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bef:	cc                   	int3   
  800bf0:	eb fd                	jmp    800bef <_panic+0x111>

0000000000800bf2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800bf2:	55                   	push   %rbp
  800bf3:	48 89 e5             	mov    %rsp,%rbp
  800bf6:	48 83 ec 10          	sub    $0x10,%rsp
  800bfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c05:	8b 00                	mov    (%rax),%eax
  800c07:	8d 48 01             	lea    0x1(%rax),%ecx
  800c0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c0e:	89 0a                	mov    %ecx,(%rdx)
  800c10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c13:	89 d1                	mov    %edx,%ecx
  800c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c19:	48 98                	cltq   
  800c1b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c23:	8b 00                	mov    (%rax),%eax
  800c25:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c2a:	75 2c                	jne    800c58 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c30:	8b 00                	mov    (%rax),%eax
  800c32:	48 98                	cltq   
  800c34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c38:	48 83 c2 08          	add    $0x8,%rdx
  800c3c:	48 89 c6             	mov    %rax,%rsi
  800c3f:	48 89 d7             	mov    %rdx,%rdi
  800c42:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  800c49:	00 00 00 
  800c4c:	ff d0                	callq  *%rax
        b->idx = 0;
  800c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c52:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5c:	8b 40 04             	mov    0x4(%rax),%eax
  800c5f:	8d 50 01             	lea    0x1(%rax),%edx
  800c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c66:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c69:	c9                   	leaveq 
  800c6a:	c3                   	retq   

0000000000800c6b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c6b:	55                   	push   %rbp
  800c6c:	48 89 e5             	mov    %rsp,%rbp
  800c6f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c76:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c7d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c84:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c8b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c92:	48 8b 0a             	mov    (%rdx),%rcx
  800c95:	48 89 08             	mov    %rcx,(%rax)
  800c98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ca4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ca8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800caf:	00 00 00 
    b.cnt = 0;
  800cb2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cb9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800cbc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cc3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cd1:	48 89 c6             	mov    %rax,%rsi
  800cd4:	48 bf f2 0b 80 00 00 	movabs $0x800bf2,%rdi
  800cdb:	00 00 00 
  800cde:	48 b8 ca 10 80 00 00 	movabs $0x8010ca,%rax
  800ce5:	00 00 00 
  800ce8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cf0:	48 98                	cltq   
  800cf2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800cf9:	48 83 c2 08          	add    $0x8,%rdx
  800cfd:	48 89 c6             	mov    %rax,%rsi
  800d00:	48 89 d7             	mov    %rdx,%rdi
  800d03:	48 b8 c6 20 80 00 00 	movabs $0x8020c6,%rax
  800d0a:	00 00 00 
  800d0d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d15:	c9                   	leaveq 
  800d16:	c3                   	retq   

0000000000800d17 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d17:	55                   	push   %rbp
  800d18:	48 89 e5             	mov    %rsp,%rbp
  800d1b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d22:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d29:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d45:	84 c0                	test   %al,%al
  800d47:	74 20                	je     800d69 <cprintf+0x52>
  800d49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d69:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d70:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d77:	00 00 00 
  800d7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d81:	00 00 00 
  800d84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800d9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dab:	48 8b 0a             	mov    (%rdx),%rcx
  800dae:	48 89 08             	mov    %rcx,(%rax)
  800db1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dbd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dc1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dc8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dcf:	48 89 d6             	mov    %rdx,%rsi
  800dd2:	48 89 c7             	mov    %rax,%rdi
  800dd5:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  800ddc:	00 00 00 
  800ddf:	ff d0                	callq  *%rax
  800de1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800de7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ded:	c9                   	leaveq 
  800dee:	c3                   	retq   

0000000000800def <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800def:	55                   	push   %rbp
  800df0:	48 89 e5             	mov    %rsp,%rbp
  800df3:	53                   	push   %rbx
  800df4:	48 83 ec 38          	sub    $0x38,%rsp
  800df8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e04:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e07:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e0b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e0f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e16:	77 3b                	ja     800e53 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e18:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e1b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e1f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e26:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2b:	48 f7 f3             	div    %rbx
  800e2e:	48 89 c2             	mov    %rax,%rdx
  800e31:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e34:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e37:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3f:	41 89 f9             	mov    %edi,%r9d
  800e42:	48 89 c7             	mov    %rax,%rdi
  800e45:	48 b8 ef 0d 80 00 00 	movabs $0x800def,%rax
  800e4c:	00 00 00 
  800e4f:	ff d0                	callq  *%rax
  800e51:	eb 1e                	jmp    800e71 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e53:	eb 12                	jmp    800e67 <printnum+0x78>
			putch(padc, putdat);
  800e55:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e59:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e60:	48 89 ce             	mov    %rcx,%rsi
  800e63:	89 d7                	mov    %edx,%edi
  800e65:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e67:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e6b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e6f:	7f e4                	jg     800e55 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e71:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e78:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7d:	48 f7 f1             	div    %rcx
  800e80:	48 89 d0             	mov    %rdx,%rax
  800e83:	48 ba 50 28 80 00 00 	movabs $0x802850,%rdx
  800e8a:	00 00 00 
  800e8d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800e91:	0f be d0             	movsbl %al,%edx
  800e94:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9c:	48 89 ce             	mov    %rcx,%rsi
  800e9f:	89 d7                	mov    %edx,%edi
  800ea1:	ff d0                	callq  *%rax
}
  800ea3:	48 83 c4 38          	add    $0x38,%rsp
  800ea7:	5b                   	pop    %rbx
  800ea8:	5d                   	pop    %rbp
  800ea9:	c3                   	retq   

0000000000800eaa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 83 ec 1c          	sub    $0x1c,%rsp
  800eb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800eb9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ebd:	7e 52                	jle    800f11 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	8b 00                	mov    (%rax),%eax
  800ec5:	83 f8 30             	cmp    $0x30,%eax
  800ec8:	73 24                	jae    800eee <getuint+0x44>
  800eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ece:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed6:	8b 00                	mov    (%rax),%eax
  800ed8:	89 c0                	mov    %eax,%eax
  800eda:	48 01 d0             	add    %rdx,%rax
  800edd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ee1:	8b 12                	mov    (%rdx),%edx
  800ee3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ee6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eea:	89 0a                	mov    %ecx,(%rdx)
  800eec:	eb 17                	jmp    800f05 <getuint+0x5b>
  800eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ef6:	48 89 d0             	mov    %rdx,%rax
  800ef9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800efd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f01:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f05:	48 8b 00             	mov    (%rax),%rax
  800f08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f0c:	e9 a3 00 00 00       	jmpq   800fb4 <getuint+0x10a>
	else if (lflag)
  800f11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f15:	74 4f                	je     800f66 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1b:	8b 00                	mov    (%rax),%eax
  800f1d:	83 f8 30             	cmp    $0x30,%eax
  800f20:	73 24                	jae    800f46 <getuint+0x9c>
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2e:	8b 00                	mov    (%rax),%eax
  800f30:	89 c0                	mov    %eax,%eax
  800f32:	48 01 d0             	add    %rdx,%rax
  800f35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f39:	8b 12                	mov    (%rdx),%edx
  800f3b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f42:	89 0a                	mov    %ecx,(%rdx)
  800f44:	eb 17                	jmp    800f5d <getuint+0xb3>
  800f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f4e:	48 89 d0             	mov    %rdx,%rax
  800f51:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f59:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f5d:	48 8b 00             	mov    (%rax),%rax
  800f60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f64:	eb 4e                	jmp    800fb4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	8b 00                	mov    (%rax),%eax
  800f6c:	83 f8 30             	cmp    $0x30,%eax
  800f6f:	73 24                	jae    800f95 <getuint+0xeb>
  800f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f75:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7d:	8b 00                	mov    (%rax),%eax
  800f7f:	89 c0                	mov    %eax,%eax
  800f81:	48 01 d0             	add    %rdx,%rax
  800f84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f88:	8b 12                	mov    (%rdx),%edx
  800f8a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f91:	89 0a                	mov    %ecx,(%rdx)
  800f93:	eb 17                	jmp    800fac <getuint+0x102>
  800f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f99:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f9d:	48 89 d0             	mov    %rdx,%rax
  800fa0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fa4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fac:	8b 00                	mov    (%rax),%eax
  800fae:	89 c0                	mov    %eax,%eax
  800fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fb8:	c9                   	leaveq 
  800fb9:	c3                   	retq   

0000000000800fba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fba:	55                   	push   %rbp
  800fbb:	48 89 e5             	mov    %rsp,%rbp
  800fbe:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fc9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fcd:	7e 52                	jle    801021 <getint+0x67>
		x=va_arg(*ap, long long);
  800fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd3:	8b 00                	mov    (%rax),%eax
  800fd5:	83 f8 30             	cmp    $0x30,%eax
  800fd8:	73 24                	jae    800ffe <getint+0x44>
  800fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fde:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe6:	8b 00                	mov    (%rax),%eax
  800fe8:	89 c0                	mov    %eax,%eax
  800fea:	48 01 d0             	add    %rdx,%rax
  800fed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff1:	8b 12                	mov    (%rdx),%edx
  800ff3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ff6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffa:	89 0a                	mov    %ecx,(%rdx)
  800ffc:	eb 17                	jmp    801015 <getint+0x5b>
  800ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801002:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801006:	48 89 d0             	mov    %rdx,%rax
  801009:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80100d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801011:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801015:	48 8b 00             	mov    (%rax),%rax
  801018:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80101c:	e9 a3 00 00 00       	jmpq   8010c4 <getint+0x10a>
	else if (lflag)
  801021:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801025:	74 4f                	je     801076 <getint+0xbc>
		x=va_arg(*ap, long);
  801027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102b:	8b 00                	mov    (%rax),%eax
  80102d:	83 f8 30             	cmp    $0x30,%eax
  801030:	73 24                	jae    801056 <getint+0x9c>
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80103a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103e:	8b 00                	mov    (%rax),%eax
  801040:	89 c0                	mov    %eax,%eax
  801042:	48 01 d0             	add    %rdx,%rax
  801045:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801049:	8b 12                	mov    (%rdx),%edx
  80104b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80104e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801052:	89 0a                	mov    %ecx,(%rdx)
  801054:	eb 17                	jmp    80106d <getint+0xb3>
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80105e:	48 89 d0             	mov    %rdx,%rax
  801061:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801065:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801069:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80106d:	48 8b 00             	mov    (%rax),%rax
  801070:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801074:	eb 4e                	jmp    8010c4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107a:	8b 00                	mov    (%rax),%eax
  80107c:	83 f8 30             	cmp    $0x30,%eax
  80107f:	73 24                	jae    8010a5 <getint+0xeb>
  801081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801085:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108d:	8b 00                	mov    (%rax),%eax
  80108f:	89 c0                	mov    %eax,%eax
  801091:	48 01 d0             	add    %rdx,%rax
  801094:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801098:	8b 12                	mov    (%rdx),%edx
  80109a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80109d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a1:	89 0a                	mov    %ecx,(%rdx)
  8010a3:	eb 17                	jmp    8010bc <getint+0x102>
  8010a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010ad:	48 89 d0             	mov    %rdx,%rax
  8010b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010bc:	8b 00                	mov    (%rax),%eax
  8010be:	48 98                	cltq   
  8010c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c8:	c9                   	leaveq 
  8010c9:	c3                   	retq   

00000000008010ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010ca:	55                   	push   %rbp
  8010cb:	48 89 e5             	mov    %rsp,%rbp
  8010ce:	41 54                	push   %r12
  8010d0:	53                   	push   %rbx
  8010d1:	48 83 ec 60          	sub    $0x60,%rsp
  8010d5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010d9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010e1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010e5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010e9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010ed:	48 8b 0a             	mov    (%rdx),%rcx
  8010f0:	48 89 08             	mov    %rcx,(%rax)
  8010f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801103:	eb 17                	jmp    80111c <vprintfmt+0x52>
			if (ch == '\0')
  801105:	85 db                	test   %ebx,%ebx
  801107:	0f 84 df 04 00 00    	je     8015ec <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80110d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801111:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801115:	48 89 d6             	mov    %rdx,%rsi
  801118:	89 df                	mov    %ebx,%edi
  80111a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801120:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801124:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801128:	0f b6 00             	movzbl (%rax),%eax
  80112b:	0f b6 d8             	movzbl %al,%ebx
  80112e:	83 fb 25             	cmp    $0x25,%ebx
  801131:	75 d2                	jne    801105 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801133:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801137:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80113e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801145:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80114c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801153:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801157:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80115f:	0f b6 00             	movzbl (%rax),%eax
  801162:	0f b6 d8             	movzbl %al,%ebx
  801165:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801168:	83 f8 55             	cmp    $0x55,%eax
  80116b:	0f 87 47 04 00 00    	ja     8015b8 <vprintfmt+0x4ee>
  801171:	89 c0                	mov    %eax,%eax
  801173:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80117a:	00 
  80117b:	48 b8 78 28 80 00 00 	movabs $0x802878,%rax
  801182:	00 00 00 
  801185:	48 01 d0             	add    %rdx,%rax
  801188:	48 8b 00             	mov    (%rax),%rax
  80118b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80118d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801191:	eb c0                	jmp    801153 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801193:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801197:	eb ba                	jmp    801153 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801199:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011a0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011a3:	89 d0                	mov    %edx,%eax
  8011a5:	c1 e0 02             	shl    $0x2,%eax
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	01 c0                	add    %eax,%eax
  8011ac:	01 d8                	add    %ebx,%eax
  8011ae:	83 e8 30             	sub    $0x30,%eax
  8011b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011b4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011b8:	0f b6 00             	movzbl (%rax),%eax
  8011bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011be:	83 fb 2f             	cmp    $0x2f,%ebx
  8011c1:	7e 0c                	jle    8011cf <vprintfmt+0x105>
  8011c3:	83 fb 39             	cmp    $0x39,%ebx
  8011c6:	7f 07                	jg     8011cf <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011cd:	eb d1                	jmp    8011a0 <vprintfmt+0xd6>
			goto process_precision;
  8011cf:	eb 58                	jmp    801229 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011d4:	83 f8 30             	cmp    $0x30,%eax
  8011d7:	73 17                	jae    8011f0 <vprintfmt+0x126>
  8011d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011e0:	89 c0                	mov    %eax,%eax
  8011e2:	48 01 d0             	add    %rdx,%rax
  8011e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011e8:	83 c2 08             	add    $0x8,%edx
  8011eb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011ee:	eb 0f                	jmp    8011ff <vprintfmt+0x135>
  8011f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011f4:	48 89 d0             	mov    %rdx,%rax
  8011f7:	48 83 c2 08          	add    $0x8,%rdx
  8011fb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011ff:	8b 00                	mov    (%rax),%eax
  801201:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801204:	eb 23                	jmp    801229 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801206:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80120a:	79 0c                	jns    801218 <vprintfmt+0x14e>
				width = 0;
  80120c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801213:	e9 3b ff ff ff       	jmpq   801153 <vprintfmt+0x89>
  801218:	e9 36 ff ff ff       	jmpq   801153 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80121d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801224:	e9 2a ff ff ff       	jmpq   801153 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801229:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80122d:	79 12                	jns    801241 <vprintfmt+0x177>
				width = precision, precision = -1;
  80122f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801232:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801235:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80123c:	e9 12 ff ff ff       	jmpq   801153 <vprintfmt+0x89>
  801241:	e9 0d ff ff ff       	jmpq   801153 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801246:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80124a:	e9 04 ff ff ff       	jmpq   801153 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80124f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801252:	83 f8 30             	cmp    $0x30,%eax
  801255:	73 17                	jae    80126e <vprintfmt+0x1a4>
  801257:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80125b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80125e:	89 c0                	mov    %eax,%eax
  801260:	48 01 d0             	add    %rdx,%rax
  801263:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801266:	83 c2 08             	add    $0x8,%edx
  801269:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80126c:	eb 0f                	jmp    80127d <vprintfmt+0x1b3>
  80126e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801272:	48 89 d0             	mov    %rdx,%rax
  801275:	48 83 c2 08          	add    $0x8,%rdx
  801279:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80127d:	8b 10                	mov    (%rax),%edx
  80127f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801283:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801287:	48 89 ce             	mov    %rcx,%rsi
  80128a:	89 d7                	mov    %edx,%edi
  80128c:	ff d0                	callq  *%rax
			break;
  80128e:	e9 53 03 00 00       	jmpq   8015e6 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801293:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801296:	83 f8 30             	cmp    $0x30,%eax
  801299:	73 17                	jae    8012b2 <vprintfmt+0x1e8>
  80129b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80129f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a2:	89 c0                	mov    %eax,%eax
  8012a4:	48 01 d0             	add    %rdx,%rax
  8012a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012aa:	83 c2 08             	add    $0x8,%edx
  8012ad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012b0:	eb 0f                	jmp    8012c1 <vprintfmt+0x1f7>
  8012b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012b6:	48 89 d0             	mov    %rdx,%rax
  8012b9:	48 83 c2 08          	add    $0x8,%rdx
  8012bd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012c1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012c3:	85 db                	test   %ebx,%ebx
  8012c5:	79 02                	jns    8012c9 <vprintfmt+0x1ff>
				err = -err;
  8012c7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012c9:	83 fb 15             	cmp    $0x15,%ebx
  8012cc:	7f 16                	jg     8012e4 <vprintfmt+0x21a>
  8012ce:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  8012d5:	00 00 00 
  8012d8:	48 63 d3             	movslq %ebx,%rdx
  8012db:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012df:	4d 85 e4             	test   %r12,%r12
  8012e2:	75 2e                	jne    801312 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012e4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ec:	89 d9                	mov    %ebx,%ecx
  8012ee:	48 ba 61 28 80 00 00 	movabs $0x802861,%rdx
  8012f5:	00 00 00 
  8012f8:	48 89 c7             	mov    %rax,%rdi
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	49 b8 f5 15 80 00 00 	movabs $0x8015f5,%r8
  801307:	00 00 00 
  80130a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80130d:	e9 d4 02 00 00       	jmpq   8015e6 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801312:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801316:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80131a:	4c 89 e1             	mov    %r12,%rcx
  80131d:	48 ba 6a 28 80 00 00 	movabs $0x80286a,%rdx
  801324:	00 00 00 
  801327:	48 89 c7             	mov    %rax,%rdi
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	49 b8 f5 15 80 00 00 	movabs $0x8015f5,%r8
  801336:	00 00 00 
  801339:	41 ff d0             	callq  *%r8
			break;
  80133c:	e9 a5 02 00 00       	jmpq   8015e6 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801341:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801344:	83 f8 30             	cmp    $0x30,%eax
  801347:	73 17                	jae    801360 <vprintfmt+0x296>
  801349:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80134d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801350:	89 c0                	mov    %eax,%eax
  801352:	48 01 d0             	add    %rdx,%rax
  801355:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801358:	83 c2 08             	add    $0x8,%edx
  80135b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80135e:	eb 0f                	jmp    80136f <vprintfmt+0x2a5>
  801360:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801364:	48 89 d0             	mov    %rdx,%rax
  801367:	48 83 c2 08          	add    $0x8,%rdx
  80136b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80136f:	4c 8b 20             	mov    (%rax),%r12
  801372:	4d 85 e4             	test   %r12,%r12
  801375:	75 0a                	jne    801381 <vprintfmt+0x2b7>
				p = "(null)";
  801377:	49 bc 6d 28 80 00 00 	movabs $0x80286d,%r12
  80137e:	00 00 00 
			if (width > 0 && padc != '-')
  801381:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801385:	7e 3f                	jle    8013c6 <vprintfmt+0x2fc>
  801387:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80138b:	74 39                	je     8013c6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80138d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801390:	48 98                	cltq   
  801392:	48 89 c6             	mov    %rax,%rsi
  801395:	4c 89 e7             	mov    %r12,%rdi
  801398:	48 b8 a1 18 80 00 00 	movabs $0x8018a1,%rax
  80139f:	00 00 00 
  8013a2:	ff d0                	callq  *%rax
  8013a4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013a7:	eb 17                	jmp    8013c0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013a9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013ad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b5:	48 89 ce             	mov    %rcx,%rsi
  8013b8:	89 d7                	mov    %edx,%edi
  8013ba:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013bc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013c4:	7f e3                	jg     8013a9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013c6:	eb 37                	jmp    8013ff <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013cc:	74 1e                	je     8013ec <vprintfmt+0x322>
  8013ce:	83 fb 1f             	cmp    $0x1f,%ebx
  8013d1:	7e 05                	jle    8013d8 <vprintfmt+0x30e>
  8013d3:	83 fb 7e             	cmp    $0x7e,%ebx
  8013d6:	7e 14                	jle    8013ec <vprintfmt+0x322>
					putch('?', putdat);
  8013d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e0:	48 89 d6             	mov    %rdx,%rsi
  8013e3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013e8:	ff d0                	callq  *%rax
  8013ea:	eb 0f                	jmp    8013fb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8013ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013f4:	48 89 d6             	mov    %rdx,%rsi
  8013f7:	89 df                	mov    %ebx,%edi
  8013f9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013fb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013ff:	4c 89 e0             	mov    %r12,%rax
  801402:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	0f be d8             	movsbl %al,%ebx
  80140c:	85 db                	test   %ebx,%ebx
  80140e:	74 10                	je     801420 <vprintfmt+0x356>
  801410:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801414:	78 b2                	js     8013c8 <vprintfmt+0x2fe>
  801416:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80141a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80141e:	79 a8                	jns    8013c8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801420:	eb 16                	jmp    801438 <vprintfmt+0x36e>
				putch(' ', putdat);
  801422:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801426:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80142a:	48 89 d6             	mov    %rdx,%rsi
  80142d:	bf 20 00 00 00       	mov    $0x20,%edi
  801432:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801434:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801438:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80143c:	7f e4                	jg     801422 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80143e:	e9 a3 01 00 00       	jmpq   8015e6 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801443:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801447:	be 03 00 00 00       	mov    $0x3,%esi
  80144c:	48 89 c7             	mov    %rax,%rdi
  80144f:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  801456:	00 00 00 
  801459:	ff d0                	callq  *%rax
  80145b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80145f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	79 1d                	jns    801485 <vprintfmt+0x3bb>
				putch('-', putdat);
  801468:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80146c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801470:	48 89 d6             	mov    %rdx,%rsi
  801473:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801478:	ff d0                	callq  *%rax
				num = -(long long) num;
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 f7 d8             	neg    %rax
  801481:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801485:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80148c:	e9 e8 00 00 00       	jmpq   801579 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801491:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801495:	be 03 00 00 00       	mov    $0x3,%esi
  80149a:	48 89 c7             	mov    %rax,%rdi
  80149d:	48 b8 aa 0e 80 00 00 	movabs $0x800eaa,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	callq  *%rax
  8014a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014ad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014b4:	e9 c0 00 00 00       	jmpq   801579 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c1:	48 89 d6             	mov    %rdx,%rsi
  8014c4:	bf 58 00 00 00       	mov    $0x58,%edi
  8014c9:	ff d0                	callq  *%rax
			putch('X', putdat);
  8014cb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d3:	48 89 d6             	mov    %rdx,%rsi
  8014d6:	bf 58 00 00 00       	mov    $0x58,%edi
  8014db:	ff d0                	callq  *%rax
			putch('X', putdat);
  8014dd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014e5:	48 89 d6             	mov    %rdx,%rsi
  8014e8:	bf 58 00 00 00       	mov    $0x58,%edi
  8014ed:	ff d0                	callq  *%rax
			break;
  8014ef:	e9 f2 00 00 00       	jmpq   8015e6 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  8014f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014fc:	48 89 d6             	mov    %rdx,%rsi
  8014ff:	bf 30 00 00 00       	mov    $0x30,%edi
  801504:	ff d0                	callq  *%rax
			putch('x', putdat);
  801506:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80150a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80150e:	48 89 d6             	mov    %rdx,%rsi
  801511:	bf 78 00 00 00       	mov    $0x78,%edi
  801516:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801518:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151b:	83 f8 30             	cmp    $0x30,%eax
  80151e:	73 17                	jae    801537 <vprintfmt+0x46d>
  801520:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801524:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801527:	89 c0                	mov    %eax,%eax
  801529:	48 01 d0             	add    %rdx,%rax
  80152c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80152f:	83 c2 08             	add    $0x8,%edx
  801532:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801535:	eb 0f                	jmp    801546 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  801537:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80153b:	48 89 d0             	mov    %rdx,%rax
  80153e:	48 83 c2 08          	add    $0x8,%rdx
  801542:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801546:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801549:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80154d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801554:	eb 23                	jmp    801579 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801556:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80155a:	be 03 00 00 00       	mov    $0x3,%esi
  80155f:	48 89 c7             	mov    %rax,%rdi
  801562:	48 b8 aa 0e 80 00 00 	movabs $0x800eaa,%rax
  801569:	00 00 00 
  80156c:	ff d0                	callq  *%rax
  80156e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801572:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801579:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80157e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801581:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801588:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80158c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801590:	45 89 c1             	mov    %r8d,%r9d
  801593:	41 89 f8             	mov    %edi,%r8d
  801596:	48 89 c7             	mov    %rax,%rdi
  801599:	48 b8 ef 0d 80 00 00 	movabs $0x800def,%rax
  8015a0:	00 00 00 
  8015a3:	ff d0                	callq  *%rax
			break;
  8015a5:	eb 3f                	jmp    8015e6 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015a7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015ab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015af:	48 89 d6             	mov    %rdx,%rsi
  8015b2:	89 df                	mov    %ebx,%edi
  8015b4:	ff d0                	callq  *%rax
			break;
  8015b6:	eb 2e                	jmp    8015e6 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015c0:	48 89 d6             	mov    %rdx,%rsi
  8015c3:	bf 25 00 00 00       	mov    $0x25,%edi
  8015c8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015ca:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015cf:	eb 05                	jmp    8015d6 <vprintfmt+0x50c>
  8015d1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015da:	48 83 e8 01          	sub    $0x1,%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 25                	cmp    $0x25,%al
  8015e3:	75 ec                	jne    8015d1 <vprintfmt+0x507>
				/* do nothing */;
			break;
  8015e5:	90                   	nop
		}
	}
  8015e6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015e7:	e9 30 fb ff ff       	jmpq   80111c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015ec:	48 83 c4 60          	add    $0x60,%rsp
  8015f0:	5b                   	pop    %rbx
  8015f1:	41 5c                	pop    %r12
  8015f3:	5d                   	pop    %rbp
  8015f4:	c3                   	retq   

00000000008015f5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015f5:	55                   	push   %rbp
  8015f6:	48 89 e5             	mov    %rsp,%rbp
  8015f9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801600:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801607:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80160e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801615:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80161c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801623:	84 c0                	test   %al,%al
  801625:	74 20                	je     801647 <printfmt+0x52>
  801627:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80162b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80162f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801633:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801637:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80163b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80163f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801643:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801647:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80164e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801655:	00 00 00 
  801658:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80165f:	00 00 00 
  801662:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801666:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80166d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801674:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80167b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801682:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801689:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801690:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801697:	48 89 c7             	mov    %rax,%rdi
  80169a:	48 b8 ca 10 80 00 00 	movabs $0x8010ca,%rax
  8016a1:	00 00 00 
  8016a4:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016a6:	c9                   	leaveq 
  8016a7:	c3                   	retq   

00000000008016a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016a8:	55                   	push   %rbp
  8016a9:	48 89 e5             	mov    %rsp,%rbp
  8016ac:	48 83 ec 10          	sub    $0x10,%rsp
  8016b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bb:	8b 40 10             	mov    0x10(%rax),%eax
  8016be:	8d 50 01             	lea    0x1(%rax),%edx
  8016c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	48 8b 10             	mov    (%rax),%rdx
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016d7:	48 39 c2             	cmp    %rax,%rdx
  8016da:	73 17                	jae    8016f3 <sprintputch+0x4b>
		*b->buf++ = ch;
  8016dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e0:	48 8b 00             	mov    (%rax),%rax
  8016e3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016eb:	48 89 0a             	mov    %rcx,(%rdx)
  8016ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016f1:	88 10                	mov    %dl,(%rax)
}
  8016f3:	c9                   	leaveq 
  8016f4:	c3                   	retq   

00000000008016f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016f5:	55                   	push   %rbp
  8016f6:	48 89 e5             	mov    %rsp,%rbp
  8016f9:	48 83 ec 50          	sub    $0x50,%rsp
  8016fd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801701:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801704:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801708:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80170c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801710:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801714:	48 8b 0a             	mov    (%rdx),%rcx
  801717:	48 89 08             	mov    %rcx,(%rax)
  80171a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80171e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801722:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801726:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80172a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80172e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801732:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801735:	48 98                	cltq   
  801737:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80173b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80173f:	48 01 d0             	add    %rdx,%rax
  801742:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801746:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80174d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801752:	74 06                	je     80175a <vsnprintf+0x65>
  801754:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801758:	7f 07                	jg     801761 <vsnprintf+0x6c>
		return -E_INVAL;
  80175a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175f:	eb 2f                	jmp    801790 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801761:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801765:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801769:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80176d:	48 89 c6             	mov    %rax,%rsi
  801770:	48 bf a8 16 80 00 00 	movabs $0x8016a8,%rdi
  801777:	00 00 00 
  80177a:	48 b8 ca 10 80 00 00 	movabs $0x8010ca,%rax
  801781:	00 00 00 
  801784:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801786:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80178d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801790:	c9                   	leaveq 
  801791:	c3                   	retq   

0000000000801792 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801792:	55                   	push   %rbp
  801793:	48 89 e5             	mov    %rsp,%rbp
  801796:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80179d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017a4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017aa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017b1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017b8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017bf:	84 c0                	test   %al,%al
  8017c1:	74 20                	je     8017e3 <snprintf+0x51>
  8017c3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017c7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017cb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017cf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017d3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017d7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017db:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017df:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017e3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017ea:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017f1:	00 00 00 
  8017f4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017fb:	00 00 00 
  8017fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801802:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801809:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801810:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801817:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80181e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801825:	48 8b 0a             	mov    (%rdx),%rcx
  801828:	48 89 08             	mov    %rcx,(%rax)
  80182b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80182f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801833:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801837:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80183b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801842:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801849:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80184f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801856:	48 89 c7             	mov    %rax,%rdi
  801859:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801860:	00 00 00 
  801863:	ff d0                	callq  *%rax
  801865:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80186b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801871:	c9                   	leaveq 
  801872:	c3                   	retq   

0000000000801873 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801873:	55                   	push   %rbp
  801874:	48 89 e5             	mov    %rsp,%rbp
  801877:	48 83 ec 18          	sub    $0x18,%rsp
  80187b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80187f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801886:	eb 09                	jmp    801891 <strlen+0x1e>
		n++;
  801888:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80188c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	84 c0                	test   %al,%al
  80189a:	75 ec                	jne    801888 <strlen+0x15>
		n++;
	return n;
  80189c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80189f:	c9                   	leaveq 
  8018a0:	c3                   	retq   

00000000008018a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018a1:	55                   	push   %rbp
  8018a2:	48 89 e5             	mov    %rsp,%rbp
  8018a5:	48 83 ec 20          	sub    $0x20,%rsp
  8018a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018b8:	eb 0e                	jmp    8018c8 <strnlen+0x27>
		n++;
  8018ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018c3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018cd:	74 0b                	je     8018da <strnlen+0x39>
  8018cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	84 c0                	test   %al,%al
  8018d8:	75 e0                	jne    8018ba <strnlen+0x19>
		n++;
	return n;
  8018da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018dd:	c9                   	leaveq 
  8018de:	c3                   	retq   

00000000008018df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018df:	55                   	push   %rbp
  8018e0:	48 89 e5             	mov    %rsp,%rbp
  8018e3:	48 83 ec 20          	sub    $0x20,%rsp
  8018e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018f7:	90                   	nop
  8018f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801900:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801904:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801908:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80190c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801910:	0f b6 12             	movzbl (%rdx),%edx
  801913:	88 10                	mov    %dl,(%rax)
  801915:	0f b6 00             	movzbl (%rax),%eax
  801918:	84 c0                	test   %al,%al
  80191a:	75 dc                	jne    8018f8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80191c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801920:	c9                   	leaveq 
  801921:	c3                   	retq   

0000000000801922 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	48 83 ec 20          	sub    $0x20,%rsp
  80192a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80192e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801936:	48 89 c7             	mov    %rax,%rdi
  801939:	48 b8 73 18 80 00 00 	movabs $0x801873,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
  801945:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801948:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194b:	48 63 d0             	movslq %eax,%rdx
  80194e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801952:	48 01 c2             	add    %rax,%rdx
  801955:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801959:	48 89 c6             	mov    %rax,%rsi
  80195c:	48 89 d7             	mov    %rdx,%rdi
  80195f:	48 b8 df 18 80 00 00 	movabs $0x8018df,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
	return dst;
  80196b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80196f:	c9                   	leaveq 
  801970:	c3                   	retq   

0000000000801971 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801971:	55                   	push   %rbp
  801972:	48 89 e5             	mov    %rsp,%rbp
  801975:	48 83 ec 28          	sub    $0x28,%rsp
  801979:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80197d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801981:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801989:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80198d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801994:	00 
  801995:	eb 2a                	jmp    8019c1 <strncpy+0x50>
		*dst++ = *src;
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80199f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019a7:	0f b6 12             	movzbl (%rdx),%edx
  8019aa:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019b0:	0f b6 00             	movzbl (%rax),%eax
  8019b3:	84 c0                	test   %al,%al
  8019b5:	74 05                	je     8019bc <strncpy+0x4b>
			src++;
  8019b7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019c9:	72 cc                	jb     801997 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 28          	sub    $0x28,%rsp
  8019d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019f2:	74 3d                	je     801a31 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019f4:	eb 1d                	jmp    801a13 <strlcpy+0x42>
			*dst++ = *src++;
  8019f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a02:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a06:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a0a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a0e:	0f b6 12             	movzbl (%rdx),%edx
  801a11:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a13:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a18:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a1d:	74 0b                	je     801a2a <strlcpy+0x59>
  801a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a23:	0f b6 00             	movzbl (%rax),%eax
  801a26:	84 c0                	test   %al,%al
  801a28:	75 cc                	jne    8019f6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a39:	48 29 c2             	sub    %rax,%rdx
  801a3c:	48 89 d0             	mov    %rdx,%rax
}
  801a3f:	c9                   	leaveq 
  801a40:	c3                   	retq   

0000000000801a41 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a41:	55                   	push   %rbp
  801a42:	48 89 e5             	mov    %rsp,%rbp
  801a45:	48 83 ec 10          	sub    $0x10,%rsp
  801a49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a51:	eb 0a                	jmp    801a5d <strcmp+0x1c>
		p++, q++;
  801a53:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a58:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a61:	0f b6 00             	movzbl (%rax),%eax
  801a64:	84 c0                	test   %al,%al
  801a66:	74 12                	je     801a7a <strcmp+0x39>
  801a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6c:	0f b6 10             	movzbl (%rax),%edx
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	0f b6 00             	movzbl (%rax),%eax
  801a76:	38 c2                	cmp    %al,%dl
  801a78:	74 d9                	je     801a53 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7e:	0f b6 00             	movzbl (%rax),%eax
  801a81:	0f b6 d0             	movzbl %al,%edx
  801a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a88:	0f b6 00             	movzbl (%rax),%eax
  801a8b:	0f b6 c0             	movzbl %al,%eax
  801a8e:	29 c2                	sub    %eax,%edx
  801a90:	89 d0                	mov    %edx,%eax
}
  801a92:	c9                   	leaveq 
  801a93:	c3                   	retq   

0000000000801a94 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a94:	55                   	push   %rbp
  801a95:	48 89 e5             	mov    %rsp,%rbp
  801a98:	48 83 ec 18          	sub    $0x18,%rsp
  801a9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aa4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801aa8:	eb 0f                	jmp    801ab9 <strncmp+0x25>
		n--, p++, q++;
  801aaa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801aaf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ab4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ab9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801abe:	74 1d                	je     801add <strncmp+0x49>
  801ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac4:	0f b6 00             	movzbl (%rax),%eax
  801ac7:	84 c0                	test   %al,%al
  801ac9:	74 12                	je     801add <strncmp+0x49>
  801acb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acf:	0f b6 10             	movzbl (%rax),%edx
  801ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad6:	0f b6 00             	movzbl (%rax),%eax
  801ad9:	38 c2                	cmp    %al,%dl
  801adb:	74 cd                	je     801aaa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801add:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ae2:	75 07                	jne    801aeb <strncmp+0x57>
		return 0;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae9:	eb 18                	jmp    801b03 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aef:	0f b6 00             	movzbl (%rax),%eax
  801af2:	0f b6 d0             	movzbl %al,%edx
  801af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af9:	0f b6 00             	movzbl (%rax),%eax
  801afc:	0f b6 c0             	movzbl %al,%eax
  801aff:	29 c2                	sub    %eax,%edx
  801b01:	89 d0                	mov    %edx,%eax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 0c          	sub    $0xc,%rsp
  801b0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b11:	89 f0                	mov    %esi,%eax
  801b13:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b16:	eb 17                	jmp    801b2f <strchr+0x2a>
		if (*s == c)
  801b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1c:	0f b6 00             	movzbl (%rax),%eax
  801b1f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b22:	75 06                	jne    801b2a <strchr+0x25>
			return (char *) s;
  801b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b28:	eb 15                	jmp    801b3f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b2a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b33:	0f b6 00             	movzbl (%rax),%eax
  801b36:	84 c0                	test   %al,%al
  801b38:	75 de                	jne    801b18 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 0c          	sub    $0xc,%rsp
  801b49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b4d:	89 f0                	mov    %esi,%eax
  801b4f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b52:	eb 13                	jmp    801b67 <strfind+0x26>
		if (*s == c)
  801b54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b58:	0f b6 00             	movzbl (%rax),%eax
  801b5b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b5e:	75 02                	jne    801b62 <strfind+0x21>
			break;
  801b60:	eb 10                	jmp    801b72 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b62:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6b:	0f b6 00             	movzbl (%rax),%eax
  801b6e:	84 c0                	test   %al,%al
  801b70:	75 e2                	jne    801b54 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 18          	sub    $0x18,%rsp
  801b80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b84:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b90:	75 06                	jne    801b98 <memset+0x20>
		return v;
  801b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b96:	eb 69                	jmp    801c01 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9c:	83 e0 03             	and    $0x3,%eax
  801b9f:	48 85 c0             	test   %rax,%rax
  801ba2:	75 48                	jne    801bec <memset+0x74>
  801ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba8:	83 e0 03             	and    $0x3,%eax
  801bab:	48 85 c0             	test   %rax,%rax
  801bae:	75 3c                	jne    801bec <memset+0x74>
		c &= 0xFF;
  801bb0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bba:	c1 e0 18             	shl    $0x18,%eax
  801bbd:	89 c2                	mov    %eax,%edx
  801bbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bc2:	c1 e0 10             	shl    $0x10,%eax
  801bc5:	09 c2                	or     %eax,%edx
  801bc7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bca:	c1 e0 08             	shl    $0x8,%eax
  801bcd:	09 d0                	or     %edx,%eax
  801bcf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd6:	48 c1 e8 02          	shr    $0x2,%rax
  801bda:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bdd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be4:	48 89 d7             	mov    %rdx,%rdi
  801be7:	fc                   	cld    
  801be8:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bea:	eb 11                	jmp    801bfd <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bf7:	48 89 d7             	mov    %rdx,%rdi
  801bfa:	fc                   	cld    
  801bfb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   

0000000000801c03 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	48 83 ec 28          	sub    $0x28,%rsp
  801c0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c23:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c2f:	0f 83 88 00 00 00    	jae    801cbd <memmove+0xba>
  801c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c3d:	48 01 d0             	add    %rdx,%rax
  801c40:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c44:	76 77                	jbe    801cbd <memmove+0xba>
		s += n;
  801c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c52:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5a:	83 e0 03             	and    $0x3,%eax
  801c5d:	48 85 c0             	test   %rax,%rax
  801c60:	75 3b                	jne    801c9d <memmove+0x9a>
  801c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c66:	83 e0 03             	and    $0x3,%eax
  801c69:	48 85 c0             	test   %rax,%rax
  801c6c:	75 2f                	jne    801c9d <memmove+0x9a>
  801c6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c72:	83 e0 03             	and    $0x3,%eax
  801c75:	48 85 c0             	test   %rax,%rax
  801c78:	75 23                	jne    801c9d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7e:	48 83 e8 04          	sub    $0x4,%rax
  801c82:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c86:	48 83 ea 04          	sub    $0x4,%rdx
  801c8a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c8e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c92:	48 89 c7             	mov    %rax,%rdi
  801c95:	48 89 d6             	mov    %rdx,%rsi
  801c98:	fd                   	std    
  801c99:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c9b:	eb 1d                	jmp    801cba <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ca5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801cad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb1:	48 89 d7             	mov    %rdx,%rdi
  801cb4:	48 89 c1             	mov    %rax,%rcx
  801cb7:	fd                   	std    
  801cb8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cba:	fc                   	cld    
  801cbb:	eb 57                	jmp    801d14 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc1:	83 e0 03             	and    $0x3,%eax
  801cc4:	48 85 c0             	test   %rax,%rax
  801cc7:	75 36                	jne    801cff <memmove+0xfc>
  801cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccd:	83 e0 03             	and    $0x3,%eax
  801cd0:	48 85 c0             	test   %rax,%rax
  801cd3:	75 2a                	jne    801cff <memmove+0xfc>
  801cd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd9:	83 e0 03             	and    $0x3,%eax
  801cdc:	48 85 c0             	test   %rax,%rax
  801cdf:	75 1e                	jne    801cff <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ce1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce5:	48 c1 e8 02          	shr    $0x2,%rax
  801ce9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cf4:	48 89 c7             	mov    %rax,%rdi
  801cf7:	48 89 d6             	mov    %rdx,%rsi
  801cfa:	fc                   	cld    
  801cfb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cfd:	eb 15                	jmp    801d14 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d03:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d07:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d0b:	48 89 c7             	mov    %rax,%rdi
  801d0e:	48 89 d6             	mov    %rdx,%rsi
  801d11:	fc                   	cld    
  801d12:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d18:	c9                   	leaveq 
  801d19:	c3                   	retq   

0000000000801d1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d1a:	55                   	push   %rbp
  801d1b:	48 89 e5             	mov    %rsp,%rbp
  801d1e:	48 83 ec 18          	sub    $0x18,%rsp
  801d22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d32:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3a:	48 89 ce             	mov    %rcx,%rsi
  801d3d:	48 89 c7             	mov    %rax,%rdi
  801d40:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
}
  801d4c:	c9                   	leaveq 
  801d4d:	c3                   	retq   

0000000000801d4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d4e:	55                   	push   %rbp
  801d4f:	48 89 e5             	mov    %rsp,%rbp
  801d52:	48 83 ec 28          	sub    $0x28,%rsp
  801d56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d5e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d72:	eb 36                	jmp    801daa <memcmp+0x5c>
		if (*s1 != *s2)
  801d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d78:	0f b6 10             	movzbl (%rax),%edx
  801d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7f:	0f b6 00             	movzbl (%rax),%eax
  801d82:	38 c2                	cmp    %al,%dl
  801d84:	74 1a                	je     801da0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8a:	0f b6 00             	movzbl (%rax),%eax
  801d8d:	0f b6 d0             	movzbl %al,%edx
  801d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d94:	0f b6 00             	movzbl (%rax),%eax
  801d97:	0f b6 c0             	movzbl %al,%eax
  801d9a:	29 c2                	sub    %eax,%edx
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	eb 20                	jmp    801dc0 <memcmp+0x72>
		s1++, s2++;
  801da0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801da5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801daa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dae:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801db2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801db6:	48 85 c0             	test   %rax,%rax
  801db9:	75 b9                	jne    801d74 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 28          	sub    $0x28,%rsp
  801dca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ddd:	48 01 d0             	add    %rdx,%rax
  801de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801de4:	eb 15                	jmp    801dfb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dea:	0f b6 10             	movzbl (%rax),%edx
  801ded:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801df0:	38 c2                	cmp    %al,%dl
  801df2:	75 02                	jne    801df6 <memfind+0x34>
			break;
  801df4:	eb 0f                	jmp    801e05 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801df6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dff:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e03:	72 e1                	jb     801de6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e09:	c9                   	leaveq 
  801e0a:	c3                   	retq   

0000000000801e0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e0b:	55                   	push   %rbp
  801e0c:	48 89 e5             	mov    %rsp,%rbp
  801e0f:	48 83 ec 34          	sub    $0x34,%rsp
  801e13:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e17:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e1b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e25:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e2c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e2d:	eb 05                	jmp    801e34 <strtol+0x29>
		s++;
  801e2f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e38:	0f b6 00             	movzbl (%rax),%eax
  801e3b:	3c 20                	cmp    $0x20,%al
  801e3d:	74 f0                	je     801e2f <strtol+0x24>
  801e3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e43:	0f b6 00             	movzbl (%rax),%eax
  801e46:	3c 09                	cmp    $0x9,%al
  801e48:	74 e5                	je     801e2f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4e:	0f b6 00             	movzbl (%rax),%eax
  801e51:	3c 2b                	cmp    $0x2b,%al
  801e53:	75 07                	jne    801e5c <strtol+0x51>
		s++;
  801e55:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e5a:	eb 17                	jmp    801e73 <strtol+0x68>
	else if (*s == '-')
  801e5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e60:	0f b6 00             	movzbl (%rax),%eax
  801e63:	3c 2d                	cmp    $0x2d,%al
  801e65:	75 0c                	jne    801e73 <strtol+0x68>
		s++, neg = 1;
  801e67:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e6c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e73:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e77:	74 06                	je     801e7f <strtol+0x74>
  801e79:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e7d:	75 28                	jne    801ea7 <strtol+0x9c>
  801e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e83:	0f b6 00             	movzbl (%rax),%eax
  801e86:	3c 30                	cmp    $0x30,%al
  801e88:	75 1d                	jne    801ea7 <strtol+0x9c>
  801e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8e:	48 83 c0 01          	add    $0x1,%rax
  801e92:	0f b6 00             	movzbl (%rax),%eax
  801e95:	3c 78                	cmp    $0x78,%al
  801e97:	75 0e                	jne    801ea7 <strtol+0x9c>
		s += 2, base = 16;
  801e99:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e9e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801ea5:	eb 2c                	jmp    801ed3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ea7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eab:	75 19                	jne    801ec6 <strtol+0xbb>
  801ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb1:	0f b6 00             	movzbl (%rax),%eax
  801eb4:	3c 30                	cmp    $0x30,%al
  801eb6:	75 0e                	jne    801ec6 <strtol+0xbb>
		s++, base = 8;
  801eb8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ebd:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ec4:	eb 0d                	jmp    801ed3 <strtol+0xc8>
	else if (base == 0)
  801ec6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eca:	75 07                	jne    801ed3 <strtol+0xc8>
		base = 10;
  801ecc:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ed3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed7:	0f b6 00             	movzbl (%rax),%eax
  801eda:	3c 2f                	cmp    $0x2f,%al
  801edc:	7e 1d                	jle    801efb <strtol+0xf0>
  801ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee2:	0f b6 00             	movzbl (%rax),%eax
  801ee5:	3c 39                	cmp    $0x39,%al
  801ee7:	7f 12                	jg     801efb <strtol+0xf0>
			dig = *s - '0';
  801ee9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eed:	0f b6 00             	movzbl (%rax),%eax
  801ef0:	0f be c0             	movsbl %al,%eax
  801ef3:	83 e8 30             	sub    $0x30,%eax
  801ef6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef9:	eb 4e                	jmp    801f49 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801efb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eff:	0f b6 00             	movzbl (%rax),%eax
  801f02:	3c 60                	cmp    $0x60,%al
  801f04:	7e 1d                	jle    801f23 <strtol+0x118>
  801f06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0a:	0f b6 00             	movzbl (%rax),%eax
  801f0d:	3c 7a                	cmp    $0x7a,%al
  801f0f:	7f 12                	jg     801f23 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f15:	0f b6 00             	movzbl (%rax),%eax
  801f18:	0f be c0             	movsbl %al,%eax
  801f1b:	83 e8 57             	sub    $0x57,%eax
  801f1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f21:	eb 26                	jmp    801f49 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f27:	0f b6 00             	movzbl (%rax),%eax
  801f2a:	3c 40                	cmp    $0x40,%al
  801f2c:	7e 48                	jle    801f76 <strtol+0x16b>
  801f2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f32:	0f b6 00             	movzbl (%rax),%eax
  801f35:	3c 5a                	cmp    $0x5a,%al
  801f37:	7f 3d                	jg     801f76 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3d:	0f b6 00             	movzbl (%rax),%eax
  801f40:	0f be c0             	movsbl %al,%eax
  801f43:	83 e8 37             	sub    $0x37,%eax
  801f46:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f4c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f4f:	7c 02                	jl     801f53 <strtol+0x148>
			break;
  801f51:	eb 23                	jmp    801f76 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f53:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f58:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f5b:	48 98                	cltq   
  801f5d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f68:	48 98                	cltq   
  801f6a:	48 01 d0             	add    %rdx,%rax
  801f6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f71:	e9 5d ff ff ff       	jmpq   801ed3 <strtol+0xc8>

	if (endptr)
  801f76:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f7b:	74 0b                	je     801f88 <strtol+0x17d>
		*endptr = (char *) s;
  801f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f81:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f85:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f8c:	74 09                	je     801f97 <strtol+0x18c>
  801f8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f92:	48 f7 d8             	neg    %rax
  801f95:	eb 04                	jmp    801f9b <strtol+0x190>
  801f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f9b:	c9                   	leaveq 
  801f9c:	c3                   	retq   

0000000000801f9d <strstr>:

char * strstr(const char *in, const char *str)
{
  801f9d:	55                   	push   %rbp
  801f9e:	48 89 e5             	mov    %rsp,%rbp
  801fa1:	48 83 ec 30          	sub    $0x30,%rsp
  801fa5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fa9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fb1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fb5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fb9:	0f b6 00             	movzbl (%rax),%eax
  801fbc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fbf:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fc3:	75 06                	jne    801fcb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc9:	eb 6b                	jmp    802036 <strstr+0x99>

	len = strlen(str);
  801fcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fcf:	48 89 c7             	mov    %rax,%rdi
  801fd2:	48 b8 73 18 80 00 00 	movabs $0x801873,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	callq  *%rax
  801fde:	48 98                	cltq   
  801fe0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ff0:	0f b6 00             	movzbl (%rax),%eax
  801ff3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ff6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ffa:	75 07                	jne    802003 <strstr+0x66>
				return (char *) 0;
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	eb 33                	jmp    802036 <strstr+0x99>
		} while (sc != c);
  802003:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802007:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80200a:	75 d8                	jne    801fe4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80200c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802010:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802018:	48 89 ce             	mov    %rcx,%rsi
  80201b:	48 89 c7             	mov    %rax,%rdi
  80201e:	48 b8 94 1a 80 00 00 	movabs $0x801a94,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 b6                	jne    801fe4 <strstr+0x47>

	return (char *) (in - 1);
  80202e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802032:	48 83 e8 01          	sub    $0x1,%rax
}
  802036:	c9                   	leaveq 
  802037:	c3                   	retq   

0000000000802038 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802038:	55                   	push   %rbp
  802039:	48 89 e5             	mov    %rsp,%rbp
  80203c:	53                   	push   %rbx
  80203d:	48 83 ec 48          	sub    $0x48,%rsp
  802041:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802044:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802047:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80204b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80204f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802053:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802057:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80205a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80205e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802062:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802066:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80206a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80206e:	4c 89 c3             	mov    %r8,%rbx
  802071:	cd 30                	int    $0x30
  802073:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802077:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80207b:	74 3e                	je     8020bb <syscall+0x83>
  80207d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802082:	7e 37                	jle    8020bb <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802084:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802088:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80208b:	49 89 d0             	mov    %rdx,%r8
  80208e:	89 c1                	mov    %eax,%ecx
  802090:	48 ba 28 2b 80 00 00 	movabs $0x802b28,%rdx
  802097:	00 00 00 
  80209a:	be 23 00 00 00       	mov    $0x23,%esi
  80209f:	48 bf 45 2b 80 00 00 	movabs $0x802b45,%rdi
  8020a6:	00 00 00 
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	49 b9 de 0a 80 00 00 	movabs $0x800ade,%r9
  8020b5:	00 00 00 
  8020b8:	41 ff d1             	callq  *%r9

	return ret;
  8020bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020bf:	48 83 c4 48          	add    $0x48,%rsp
  8020c3:	5b                   	pop    %rbx
  8020c4:	5d                   	pop    %rbp
  8020c5:	c3                   	retq   

00000000008020c6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020c6:	55                   	push   %rbp
  8020c7:	48 89 e5             	mov    %rsp,%rbp
  8020ca:	48 83 ec 20          	sub    $0x20,%rsp
  8020ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e5:	00 
  8020e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f2:	48 89 d1             	mov    %rdx,%rcx
  8020f5:	48 89 c2             	mov    %rax,%rdx
  8020f8:	be 00 00 00 00       	mov    $0x0,%esi
  8020fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802102:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <sys_cgetc>:

int
sys_cgetc(void)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
  802114:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802118:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211f:	00 
  802120:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802126:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802131:	ba 00 00 00 00       	mov    $0x0,%edx
  802136:	be 00 00 00 00       	mov    $0x0,%esi
  80213b:	bf 01 00 00 00       	mov    $0x1,%edi
  802140:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax
}
  80214c:	c9                   	leaveq 
  80214d:	c3                   	retq   

000000000080214e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80214e:	55                   	push   %rbp
  80214f:	48 89 e5             	mov    %rsp,%rbp
  802152:	48 83 ec 10          	sub    $0x10,%rsp
  802156:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215c:	48 98                	cltq   
  80215e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802165:	00 
  802166:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80216c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802172:	b9 00 00 00 00       	mov    $0x0,%ecx
  802177:	48 89 c2             	mov    %rax,%rdx
  80217a:	be 01 00 00 00       	mov    $0x1,%esi
  80217f:	bf 03 00 00 00       	mov    $0x3,%edi
  802184:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	callq  *%rax
}
  802190:	c9                   	leaveq 
  802191:	c3                   	retq   

0000000000802192 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802192:	55                   	push   %rbp
  802193:	48 89 e5             	mov    %rsp,%rbp
  802196:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80219a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a1:	00 
  8021a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b8:	be 00 00 00 00       	mov    $0x0,%esi
  8021bd:	bf 02 00 00 00       	mov    $0x2,%edi
  8021c2:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8021c9:	00 00 00 
  8021cc:	ff d0                	callq  *%rax
}
  8021ce:	c9                   	leaveq 
  8021cf:	c3                   	retq   

00000000008021d0 <sys_yield>:

void
sys_yield(void)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021df:	00 
  8021e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f6:	be 00 00 00 00       	mov    $0x0,%esi
  8021fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  802200:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
}
  80220c:	c9                   	leaveq 
  80220d:	c3                   	retq   

000000000080220e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	48 83 ec 20          	sub    $0x20,%rsp
  802216:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802219:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80221d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802220:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802223:	48 63 c8             	movslq %eax,%rcx
  802226:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80222a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222d:	48 98                	cltq   
  80222f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802236:	00 
  802237:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80223d:	49 89 c8             	mov    %rcx,%r8
  802240:	48 89 d1             	mov    %rdx,%rcx
  802243:	48 89 c2             	mov    %rax,%rdx
  802246:	be 01 00 00 00       	mov    $0x1,%esi
  80224b:	bf 04 00 00 00       	mov    $0x4,%edi
  802250:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802257:	00 00 00 
  80225a:	ff d0                	callq  *%rax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	48 83 ec 30          	sub    $0x30,%rsp
  802266:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802269:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80226d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802270:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802274:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802278:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80227b:	48 63 c8             	movslq %eax,%rcx
  80227e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802282:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802285:	48 63 f0             	movslq %eax,%rsi
  802288:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80228c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228f:	48 98                	cltq   
  802291:	48 89 0c 24          	mov    %rcx,(%rsp)
  802295:	49 89 f9             	mov    %rdi,%r9
  802298:	49 89 f0             	mov    %rsi,%r8
  80229b:	48 89 d1             	mov    %rdx,%rcx
  80229e:	48 89 c2             	mov    %rax,%rdx
  8022a1:	be 01 00 00 00       	mov    $0x1,%esi
  8022a6:	bf 05 00 00 00       	mov    $0x5,%edi
  8022ab:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	callq  *%rax
}
  8022b7:	c9                   	leaveq 
  8022b8:	c3                   	retq   

00000000008022b9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022b9:	55                   	push   %rbp
  8022ba:	48 89 e5             	mov    %rsp,%rbp
  8022bd:	48 83 ec 20          	sub    $0x20,%rsp
  8022c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cf:	48 98                	cltq   
  8022d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022d8:	00 
  8022d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022e5:	48 89 d1             	mov    %rdx,%rcx
  8022e8:	48 89 c2             	mov    %rax,%rdx
  8022eb:	be 01 00 00 00       	mov    $0x1,%esi
  8022f0:	bf 06 00 00 00       	mov    $0x6,%edi
  8022f5:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
}
  802301:	c9                   	leaveq 
  802302:	c3                   	retq   

0000000000802303 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
  802307:	48 83 ec 10          	sub    $0x10,%rsp
  80230b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80230e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802311:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802314:	48 63 d0             	movslq %eax,%rdx
  802317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231a:	48 98                	cltq   
  80231c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802323:	00 
  802324:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80232a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802330:	48 89 d1             	mov    %rdx,%rcx
  802333:	48 89 c2             	mov    %rax,%rdx
  802336:	be 01 00 00 00       	mov    $0x1,%esi
  80233b:	bf 08 00 00 00       	mov    $0x8,%edi
  802340:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 20          	sub    $0x20,%rsp
  802356:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802359:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80235d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802364:	48 98                	cltq   
  802366:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80236d:	00 
  80236e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802374:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80237a:	48 89 d1             	mov    %rdx,%rcx
  80237d:	48 89 c2             	mov    %rax,%rdx
  802380:	be 01 00 00 00       	mov    $0x1,%esi
  802385:	bf 09 00 00 00       	mov    $0x9,%edi
  80238a:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802391:	00 00 00 
  802394:	ff d0                	callq  *%rax
}
  802396:	c9                   	leaveq 
  802397:	c3                   	retq   

0000000000802398 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802398:	55                   	push   %rbp
  802399:	48 89 e5             	mov    %rsp,%rbp
  80239c:	48 83 ec 20          	sub    $0x20,%rsp
  8023a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023ab:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b1:	48 63 f0             	movslq %eax,%rsi
  8023b4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bb:	48 98                	cltq   
  8023bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023c8:	00 
  8023c9:	49 89 f1             	mov    %rsi,%r9
  8023cc:	49 89 c8             	mov    %rcx,%r8
  8023cf:	48 89 d1             	mov    %rdx,%rcx
  8023d2:	48 89 c2             	mov    %rax,%rdx
  8023d5:	be 00 00 00 00       	mov    $0x0,%esi
  8023da:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023df:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
}
  8023eb:	c9                   	leaveq 
  8023ec:	c3                   	retq   

00000000008023ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8023ed:	55                   	push   %rbp
  8023ee:	48 89 e5             	mov    %rsp,%rbp
  8023f1:	48 83 ec 10          	sub    $0x10,%rsp
  8023f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8023f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802404:	00 
  802405:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80240b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802411:	b9 00 00 00 00       	mov    $0x0,%ecx
  802416:	48 89 c2             	mov    %rax,%rdx
  802419:	be 01 00 00 00       	mov    $0x1,%esi
  80241e:	bf 0c 00 00 00       	mov    $0xc,%edi
  802423:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	callq  *%rax
}
  80242f:	c9                   	leaveq 
  802430:	c3                   	retq   

0000000000802431 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802431:	55                   	push   %rbp
  802432:	48 89 e5             	mov    %rsp,%rbp
  802435:	48 83 ec 10          	sub    $0x10,%rsp
  802439:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80243d:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  802444:	00 00 00 
  802447:	48 8b 00             	mov    (%rax),%rax
  80244a:	48 85 c0             	test   %rax,%rax
  80244d:	75 49                	jne    802498 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  80244f:	ba 07 00 00 00       	mov    $0x7,%edx
  802454:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802459:	bf 00 00 00 00       	mov    $0x0,%edi
  80245e:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802465:	00 00 00 
  802468:	ff d0                	callq  *%rax
  80246a:	85 c0                	test   %eax,%eax
  80246c:	79 2a                	jns    802498 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80246e:	48 ba 58 2b 80 00 00 	movabs $0x802b58,%rdx
  802475:	00 00 00 
  802478:	be 21 00 00 00       	mov    $0x21,%esi
  80247d:	48 bf 83 2b 80 00 00 	movabs $0x802b83,%rdi
  802484:	00 00 00 
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
  80248c:	48 b9 de 0a 80 00 00 	movabs $0x800ade,%rcx
  802493:	00 00 00 
  802496:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802498:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  80249f:	00 00 00 
  8024a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024a6:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8024a9:	48 be f4 24 80 00 00 	movabs $0x8024f4,%rsi
  8024b0:	00 00 00 
  8024b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b8:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	callq  *%rax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	79 2a                	jns    8024f2 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8024c8:	48 ba 98 2b 80 00 00 	movabs $0x802b98,%rdx
  8024cf:	00 00 00 
  8024d2:	be 27 00 00 00       	mov    $0x27,%esi
  8024d7:	48 bf 83 2b 80 00 00 	movabs $0x802b83,%rdi
  8024de:	00 00 00 
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	48 b9 de 0a 80 00 00 	movabs $0x800ade,%rcx
  8024ed:	00 00 00 
  8024f0:	ff d1                	callq  *%rcx
}
  8024f2:	c9                   	leaveq 
  8024f3:	c3                   	retq   

00000000008024f4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8024f4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8024f7:	48 a1 f8 41 80 00 00 	movabs 0x8041f8,%rax
  8024fe:	00 00 00 
call *%rax
  802501:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  802503:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80250a:	00 
    movq 152(%rsp), %rcx
  80250b:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  802512:	00 
    subq $8, %rcx
  802513:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  802517:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  80251a:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  802521:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  802522:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  802526:	4c 8b 3c 24          	mov    (%rsp),%r15
  80252a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80252f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802534:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802539:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80253e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802543:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802548:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80254d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802552:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802557:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80255c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802561:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802566:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80256b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802570:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  802574:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  802578:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  802579:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  80257a:	c3                   	retq   
