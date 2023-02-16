
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
  800074:	48 be 00 41 80 00 00 	movabs $0x804100,%rsi
  80007b:	00 00 00 
  80007e:	48 bf 01 41 80 00 00 	movabs $0x804101,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
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
  8000b0:	48 be 11 41 80 00 00 	movabs $0x804111,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  800140:	48 be 33 41 80 00 00 	movabs $0x804133,%rsi
  800147:	00 00 00 
  80014a:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  8001d0:	48 be 37 41 80 00 00 	movabs $0x804137,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  800260:	48 be 3b 41 80 00 00 	movabs $0x80413b,%rsi
  800267:	00 00 00 
  80026a:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  8002f0:	48 be 3f 41 80 00 00 	movabs $0x80413f,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  800380:	48 be 43 41 80 00 00 	movabs $0x804143,%rsi
  800387:	00 00 00 
  80038a:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  800410:	48 be 47 41 80 00 00 	movabs $0x804147,%rsi
  800417:	00 00 00 
  80041a:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  8004a0:	48 be 4b 41 80 00 00 	movabs $0x80414b,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  800536:	48 be 4f 41 80 00 00 	movabs $0x80414f,%rsi
  80053d:	00 00 00 
  800540:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  8005d2:	48 be 56 41 80 00 00 	movabs $0x804156,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf 15 41 80 00 00 	movabs $0x804115,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf 25 41 80 00 00 	movabs $0x804125,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  80065f:	48 bf 5a 41 80 00 00 	movabs $0x80415a,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
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
  8006d3:	48 ba 88 41 80 00 00 	movabs $0x804188,%rdx
  8006da:	00 00 00 
  8006dd:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e2:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 ea 0a 80 00 00 	movabs $0x800aea,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
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
  800791:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 ca 41 80 00 00 	movabs $0x8041ca,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 d8 41 80 00 00 	movabs $0x8041d8,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be df 41 80 00 00 	movabs $0x8041df,%rsi
  800804:	00 00 00 
  800807:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80080e:	00 00 00 
  800811:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081d:	ba 07 00 00 00       	mov    $0x7,%edx
  800822:	be 00 00 40 00       	mov    $0x400000,%esi
  800827:	bf 00 00 00 00       	mov    $0x0,%edi
  80082c:	48 b8 1a 22 80 00 00 	movabs $0x80221a,%rax
  800833:	00 00 00 
  800836:	ff d0                	callq  *%rax
  800838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80083f:	79 30                	jns    800871 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800844:	89 c1                	mov    %eax,%ecx
  800846:	48 ba e6 41 80 00 00 	movabs $0x8041e6,%rdx
  80084d:	00 00 00 
  800850:	be 6a 00 00 00       	mov    $0x6a,%esi
  800855:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  80085c:	00 00 00 
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 ea 0a 80 00 00 	movabs $0x800aea,%r8
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
  80088c:	48 b8 87 24 80 00 00 	movabs $0x802487,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
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
  8009bf:	48 bf 00 42 80 00 00 	movabs $0x804200,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 40 71 80 00 00 	movabs $0x807140,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 1f 42 80 00 00 	movabs $0x80421f,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 30 42 80 00 00 	movabs $0x804230,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  800a11:	00 00 00 
  800a14:	48 be df 41 80 00 00 	movabs $0x8041df,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800a45:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
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
  800a7a:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  800a81:	00 00 00 
  800a84:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800a8b:	7e 14                	jle    800aa1 <libmain+0x6b>
		binaryname = argv[0];
  800a8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a91:	48 8b 10             	mov    (%rax),%rdx
  800a94:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
	close_all();
  800acb:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  800ad2:	00 00 00 
  800ad5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ad7:	bf 00 00 00 00       	mov    $0x0,%edi
  800adc:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  800ae3:	00 00 00 
  800ae6:	ff d0                	callq  *%rax
}
  800ae8:	5d                   	pop    %rbp
  800ae9:	c3                   	retq   

0000000000800aea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800aea:	55                   	push   %rbp
  800aeb:	48 89 e5             	mov    %rsp,%rbp
  800aee:	53                   	push   %rbx
  800aef:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800af6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800afd:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b03:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b0a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b11:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b18:	84 c0                	test   %al,%al
  800b1a:	74 23                	je     800b3f <_panic+0x55>
  800b1c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b23:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b27:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b2b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b2f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b33:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b37:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b3b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b3f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b46:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b4d:	00 00 00 
  800b50:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b57:	00 00 00 
  800b5a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b5e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b65:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b6c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b73:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800b7a:	00 00 00 
  800b7d:	48 8b 18             	mov    (%rax),%rbx
  800b80:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  800b87:	00 00 00 
  800b8a:	ff d0                	callq  *%rax
  800b8c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b92:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b99:	41 89 c8             	mov    %ecx,%r8d
  800b9c:	48 89 d1             	mov    %rdx,%rcx
  800b9f:	48 89 da             	mov    %rbx,%rdx
  800ba2:	89 c6                	mov    %eax,%esi
  800ba4:	48 bf 40 42 80 00 00 	movabs $0x804240,%rdi
  800bab:	00 00 00 
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb3:	49 b9 23 0d 80 00 00 	movabs $0x800d23,%r9
  800bba:	00 00 00 
  800bbd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bc0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bc7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bce:	48 89 d6             	mov    %rdx,%rsi
  800bd1:	48 89 c7             	mov    %rax,%rdi
  800bd4:	48 b8 77 0c 80 00 00 	movabs $0x800c77,%rax
  800bdb:	00 00 00 
  800bde:	ff d0                	callq  *%rax
	cprintf("\n");
  800be0:	48 bf 63 42 80 00 00 	movabs $0x804263,%rdi
  800be7:	00 00 00 
  800bea:	b8 00 00 00 00       	mov    $0x0,%eax
  800bef:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  800bf6:	00 00 00 
  800bf9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bfb:	cc                   	int3   
  800bfc:	eb fd                	jmp    800bfb <_panic+0x111>

0000000000800bfe <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800bfe:	55                   	push   %rbp
  800bff:	48 89 e5             	mov    %rsp,%rbp
  800c02:	48 83 ec 10          	sub    $0x10,%rsp
  800c06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c11:	8b 00                	mov    (%rax),%eax
  800c13:	8d 48 01             	lea    0x1(%rax),%ecx
  800c16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1a:	89 0a                	mov    %ecx,(%rdx)
  800c1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c1f:	89 d1                	mov    %edx,%ecx
  800c21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c25:	48 98                	cltq   
  800c27:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2f:	8b 00                	mov    (%rax),%eax
  800c31:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c36:	75 2c                	jne    800c64 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3c:	8b 00                	mov    (%rax),%eax
  800c3e:	48 98                	cltq   
  800c40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c44:	48 83 c2 08          	add    $0x8,%rdx
  800c48:	48 89 c6             	mov    %rax,%rsi
  800c4b:	48 89 d7             	mov    %rdx,%rdi
  800c4e:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	callq  *%rax
        b->idx = 0;
  800c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c68:	8b 40 04             	mov    0x4(%rax),%eax
  800c6b:	8d 50 01             	lea    0x1(%rax),%edx
  800c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c72:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c75:	c9                   	leaveq 
  800c76:	c3                   	retq   

0000000000800c77 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c77:	55                   	push   %rbp
  800c78:	48 89 e5             	mov    %rsp,%rbp
  800c7b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c82:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c89:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c90:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c97:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c9e:	48 8b 0a             	mov    (%rdx),%rcx
  800ca1:	48 89 08             	mov    %rcx,(%rax)
  800ca4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cb0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800cb4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cbb:	00 00 00 
    b.cnt = 0;
  800cbe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cc5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800cc8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ccf:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cd6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cdd:	48 89 c6             	mov    %rax,%rsi
  800ce0:	48 bf fe 0b 80 00 00 	movabs $0x800bfe,%rdi
  800ce7:	00 00 00 
  800cea:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  800cf1:	00 00 00 
  800cf4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cf6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cfc:	48 98                	cltq   
  800cfe:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d05:	48 83 c2 08          	add    $0x8,%rdx
  800d09:	48 89 c6             	mov    %rax,%rsi
  800d0c:	48 89 d7             	mov    %rdx,%rdi
  800d0f:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d1b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d21:	c9                   	leaveq 
  800d22:	c3                   	retq   

0000000000800d23 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d23:	55                   	push   %rbp
  800d24:	48 89 e5             	mov    %rsp,%rbp
  800d27:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d2e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d35:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d3c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d43:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d4a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d51:	84 c0                	test   %al,%al
  800d53:	74 20                	je     800d75 <cprintf+0x52>
  800d55:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d59:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d5d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d61:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d65:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d69:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d6d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d71:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d75:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d7c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d83:	00 00 00 
  800d86:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d8d:	00 00 00 
  800d90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d94:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d9b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800da9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800db0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db7:	48 8b 0a             	mov    (%rdx),%rcx
  800dba:	48 89 08             	mov    %rcx,(%rax)
  800dbd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dcd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dd4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ddb:	48 89 d6             	mov    %rdx,%rsi
  800dde:	48 89 c7             	mov    %rax,%rdi
  800de1:	48 b8 77 0c 80 00 00 	movabs $0x800c77,%rax
  800de8:	00 00 00 
  800deb:	ff d0                	callq  *%rax
  800ded:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800df3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df9:	c9                   	leaveq 
  800dfa:	c3                   	retq   

0000000000800dfb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	53                   	push   %rbx
  800e00:	48 83 ec 38          	sub    $0x38,%rsp
  800e04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e10:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e13:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e17:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e1b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e1e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e22:	77 3b                	ja     800e5f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e24:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e27:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e2b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e32:	ba 00 00 00 00       	mov    $0x0,%edx
  800e37:	48 f7 f3             	div    %rbx
  800e3a:	48 89 c2             	mov    %rax,%rdx
  800e3d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e40:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e43:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4b:	41 89 f9             	mov    %edi,%r9d
  800e4e:	48 89 c7             	mov    %rax,%rdi
  800e51:	48 b8 fb 0d 80 00 00 	movabs $0x800dfb,%rax
  800e58:	00 00 00 
  800e5b:	ff d0                	callq  *%rax
  800e5d:	eb 1e                	jmp    800e7d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e5f:	eb 12                	jmp    800e73 <printnum+0x78>
			putch(padc, putdat);
  800e61:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e65:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6c:	48 89 ce             	mov    %rcx,%rsi
  800e6f:	89 d7                	mov    %edx,%edi
  800e71:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e73:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e77:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e7b:	7f e4                	jg     800e61 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e7d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e84:	ba 00 00 00 00       	mov    $0x0,%edx
  800e89:	48 f7 f1             	div    %rcx
  800e8c:	48 89 d0             	mov    %rdx,%rax
  800e8f:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  800e96:	00 00 00 
  800e99:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800e9d:	0f be d0             	movsbl %al,%edx
  800ea0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	48 89 ce             	mov    %rcx,%rsi
  800eab:	89 d7                	mov    %edx,%edi
  800ead:	ff d0                	callq  *%rax
}
  800eaf:	48 83 c4 38          	add    $0x38,%rsp
  800eb3:	5b                   	pop    %rbx
  800eb4:	5d                   	pop    %rbp
  800eb5:	c3                   	retq   

0000000000800eb6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eb6:	55                   	push   %rbp
  800eb7:	48 89 e5             	mov    %rsp,%rbp
  800eba:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ebe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800ec5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ec9:	7e 52                	jle    800f1d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ecb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecf:	8b 00                	mov    (%rax),%eax
  800ed1:	83 f8 30             	cmp    $0x30,%eax
  800ed4:	73 24                	jae    800efa <getuint+0x44>
  800ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eda:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee2:	8b 00                	mov    (%rax),%eax
  800ee4:	89 c0                	mov    %eax,%eax
  800ee6:	48 01 d0             	add    %rdx,%rax
  800ee9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eed:	8b 12                	mov    (%rdx),%edx
  800eef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ef2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef6:	89 0a                	mov    %ecx,(%rdx)
  800ef8:	eb 17                	jmp    800f11 <getuint+0x5b>
  800efa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f02:	48 89 d0             	mov    %rdx,%rax
  800f05:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f11:	48 8b 00             	mov    (%rax),%rax
  800f14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f18:	e9 a3 00 00 00       	jmpq   800fc0 <getuint+0x10a>
	else if (lflag)
  800f1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f21:	74 4f                	je     800f72 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f27:	8b 00                	mov    (%rax),%eax
  800f29:	83 f8 30             	cmp    $0x30,%eax
  800f2c:	73 24                	jae    800f52 <getuint+0x9c>
  800f2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f32:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	8b 00                	mov    (%rax),%eax
  800f3c:	89 c0                	mov    %eax,%eax
  800f3e:	48 01 d0             	add    %rdx,%rax
  800f41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f45:	8b 12                	mov    (%rdx),%edx
  800f47:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4e:	89 0a                	mov    %ecx,(%rdx)
  800f50:	eb 17                	jmp    800f69 <getuint+0xb3>
  800f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f56:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f5a:	48 89 d0             	mov    %rdx,%rax
  800f5d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f65:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f69:	48 8b 00             	mov    (%rax),%rax
  800f6c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f70:	eb 4e                	jmp    800fc0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f76:	8b 00                	mov    (%rax),%eax
  800f78:	83 f8 30             	cmp    $0x30,%eax
  800f7b:	73 24                	jae    800fa1 <getuint+0xeb>
  800f7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f81:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f89:	8b 00                	mov    (%rax),%eax
  800f8b:	89 c0                	mov    %eax,%eax
  800f8d:	48 01 d0             	add    %rdx,%rax
  800f90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f94:	8b 12                	mov    (%rdx),%edx
  800f96:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9d:	89 0a                	mov    %ecx,(%rdx)
  800f9f:	eb 17                	jmp    800fb8 <getuint+0x102>
  800fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fa9:	48 89 d0             	mov    %rdx,%rax
  800fac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fb8:	8b 00                	mov    (%rax),%eax
  800fba:	89 c0                	mov    %eax,%eax
  800fbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc4:	c9                   	leaveq 
  800fc5:	c3                   	retq   

0000000000800fc6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fd5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fd9:	7e 52                	jle    80102d <getint+0x67>
		x=va_arg(*ap, long long);
  800fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdf:	8b 00                	mov    (%rax),%eax
  800fe1:	83 f8 30             	cmp    $0x30,%eax
  800fe4:	73 24                	jae    80100a <getint+0x44>
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	8b 00                	mov    (%rax),%eax
  800ff4:	89 c0                	mov    %eax,%eax
  800ff6:	48 01 d0             	add    %rdx,%rax
  800ff9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffd:	8b 12                	mov    (%rdx),%edx
  800fff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801002:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801006:	89 0a                	mov    %ecx,(%rdx)
  801008:	eb 17                	jmp    801021 <getint+0x5b>
  80100a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801012:	48 89 d0             	mov    %rdx,%rax
  801015:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801019:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80101d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801021:	48 8b 00             	mov    (%rax),%rax
  801024:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801028:	e9 a3 00 00 00       	jmpq   8010d0 <getint+0x10a>
	else if (lflag)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801031:	74 4f                	je     801082 <getint+0xbc>
		x=va_arg(*ap, long);
  801033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801037:	8b 00                	mov    (%rax),%eax
  801039:	83 f8 30             	cmp    $0x30,%eax
  80103c:	73 24                	jae    801062 <getint+0x9c>
  80103e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801042:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104a:	8b 00                	mov    (%rax),%eax
  80104c:	89 c0                	mov    %eax,%eax
  80104e:	48 01 d0             	add    %rdx,%rax
  801051:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801055:	8b 12                	mov    (%rdx),%edx
  801057:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80105a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105e:	89 0a                	mov    %ecx,(%rdx)
  801060:	eb 17                	jmp    801079 <getint+0xb3>
  801062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801066:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80106a:	48 89 d0             	mov    %rdx,%rax
  80106d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801071:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801075:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801079:	48 8b 00             	mov    (%rax),%rax
  80107c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801080:	eb 4e                	jmp    8010d0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801086:	8b 00                	mov    (%rax),%eax
  801088:	83 f8 30             	cmp    $0x30,%eax
  80108b:	73 24                	jae    8010b1 <getint+0xeb>
  80108d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801091:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801099:	8b 00                	mov    (%rax),%eax
  80109b:	89 c0                	mov    %eax,%eax
  80109d:	48 01 d0             	add    %rdx,%rax
  8010a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a4:	8b 12                	mov    (%rdx),%edx
  8010a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ad:	89 0a                	mov    %ecx,(%rdx)
  8010af:	eb 17                	jmp    8010c8 <getint+0x102>
  8010b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010b9:	48 89 d0             	mov    %rdx,%rax
  8010bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010c8:	8b 00                	mov    (%rax),%eax
  8010ca:	48 98                	cltq   
  8010cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d4:	c9                   	leaveq 
  8010d5:	c3                   	retq   

00000000008010d6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d6:	55                   	push   %rbp
  8010d7:	48 89 e5             	mov    %rsp,%rbp
  8010da:	41 54                	push   %r12
  8010dc:	53                   	push   %rbx
  8010dd:	48 83 ec 60          	sub    $0x60,%rsp
  8010e1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010e5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010e9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010ed:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010f1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010f5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010f9:	48 8b 0a             	mov    (%rdx),%rcx
  8010fc:	48 89 08             	mov    %rcx,(%rax)
  8010ff:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801103:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801107:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80110b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80110f:	eb 17                	jmp    801128 <vprintfmt+0x52>
			if (ch == '\0')
  801111:	85 db                	test   %ebx,%ebx
  801113:	0f 84 df 04 00 00    	je     8015f8 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  801119:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80111d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801121:	48 89 d6             	mov    %rdx,%rsi
  801124:	89 df                	mov    %ebx,%edi
  801126:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801128:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80112c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801130:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	0f b6 d8             	movzbl %al,%ebx
  80113a:	83 fb 25             	cmp    $0x25,%ebx
  80113d:	75 d2                	jne    801111 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80113f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801143:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80114a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801151:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801158:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80115f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801163:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801167:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80116b:	0f b6 00             	movzbl (%rax),%eax
  80116e:	0f b6 d8             	movzbl %al,%ebx
  801171:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801174:	83 f8 55             	cmp    $0x55,%eax
  801177:	0f 87 47 04 00 00    	ja     8015c4 <vprintfmt+0x4ee>
  80117d:	89 c0                	mov    %eax,%eax
  80117f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801186:	00 
  801187:	48 b8 98 44 80 00 00 	movabs $0x804498,%rax
  80118e:	00 00 00 
  801191:	48 01 d0             	add    %rdx,%rax
  801194:	48 8b 00             	mov    (%rax),%rax
  801197:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801199:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80119d:	eb c0                	jmp    80115f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80119f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011a3:	eb ba                	jmp    80115f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011a5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011ac:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011af:	89 d0                	mov    %edx,%eax
  8011b1:	c1 e0 02             	shl    $0x2,%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	01 c0                	add    %eax,%eax
  8011b8:	01 d8                	add    %ebx,%eax
  8011ba:	83 e8 30             	sub    $0x30,%eax
  8011bd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011c0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011c4:	0f b6 00             	movzbl (%rax),%eax
  8011c7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011ca:	83 fb 2f             	cmp    $0x2f,%ebx
  8011cd:	7e 0c                	jle    8011db <vprintfmt+0x105>
  8011cf:	83 fb 39             	cmp    $0x39,%ebx
  8011d2:	7f 07                	jg     8011db <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011d9:	eb d1                	jmp    8011ac <vprintfmt+0xd6>
			goto process_precision;
  8011db:	eb 58                	jmp    801235 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011e0:	83 f8 30             	cmp    $0x30,%eax
  8011e3:	73 17                	jae    8011fc <vprintfmt+0x126>
  8011e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ec:	89 c0                	mov    %eax,%eax
  8011ee:	48 01 d0             	add    %rdx,%rax
  8011f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011f4:	83 c2 08             	add    $0x8,%edx
  8011f7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011fa:	eb 0f                	jmp    80120b <vprintfmt+0x135>
  8011fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801200:	48 89 d0             	mov    %rdx,%rax
  801203:	48 83 c2 08          	add    $0x8,%rdx
  801207:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80120b:	8b 00                	mov    (%rax),%eax
  80120d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801210:	eb 23                	jmp    801235 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801212:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801216:	79 0c                	jns    801224 <vprintfmt+0x14e>
				width = 0;
  801218:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80121f:	e9 3b ff ff ff       	jmpq   80115f <vprintfmt+0x89>
  801224:	e9 36 ff ff ff       	jmpq   80115f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801229:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801230:	e9 2a ff ff ff       	jmpq   80115f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801235:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801239:	79 12                	jns    80124d <vprintfmt+0x177>
				width = precision, precision = -1;
  80123b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80123e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801241:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801248:	e9 12 ff ff ff       	jmpq   80115f <vprintfmt+0x89>
  80124d:	e9 0d ff ff ff       	jmpq   80115f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801252:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801256:	e9 04 ff ff ff       	jmpq   80115f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80125b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80125e:	83 f8 30             	cmp    $0x30,%eax
  801261:	73 17                	jae    80127a <vprintfmt+0x1a4>
  801263:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801267:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80126a:	89 c0                	mov    %eax,%eax
  80126c:	48 01 d0             	add    %rdx,%rax
  80126f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801272:	83 c2 08             	add    $0x8,%edx
  801275:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801278:	eb 0f                	jmp    801289 <vprintfmt+0x1b3>
  80127a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80127e:	48 89 d0             	mov    %rdx,%rax
  801281:	48 83 c2 08          	add    $0x8,%rdx
  801285:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801289:	8b 10                	mov    (%rax),%edx
  80128b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80128f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801293:	48 89 ce             	mov    %rcx,%rsi
  801296:	89 d7                	mov    %edx,%edi
  801298:	ff d0                	callq  *%rax
			break;
  80129a:	e9 53 03 00 00       	jmpq   8015f2 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80129f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a2:	83 f8 30             	cmp    $0x30,%eax
  8012a5:	73 17                	jae    8012be <vprintfmt+0x1e8>
  8012a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012ae:	89 c0                	mov    %eax,%eax
  8012b0:	48 01 d0             	add    %rdx,%rax
  8012b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012b6:	83 c2 08             	add    $0x8,%edx
  8012b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012bc:	eb 0f                	jmp    8012cd <vprintfmt+0x1f7>
  8012be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012c2:	48 89 d0             	mov    %rdx,%rax
  8012c5:	48 83 c2 08          	add    $0x8,%rdx
  8012c9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012cd:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012cf:	85 db                	test   %ebx,%ebx
  8012d1:	79 02                	jns    8012d5 <vprintfmt+0x1ff>
				err = -err;
  8012d3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012d5:	83 fb 15             	cmp    $0x15,%ebx
  8012d8:	7f 16                	jg     8012f0 <vprintfmt+0x21a>
  8012da:	48 b8 c0 43 80 00 00 	movabs $0x8043c0,%rax
  8012e1:	00 00 00 
  8012e4:	48 63 d3             	movslq %ebx,%rdx
  8012e7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012eb:	4d 85 e4             	test   %r12,%r12
  8012ee:	75 2e                	jne    80131e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012f0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f8:	89 d9                	mov    %ebx,%ecx
  8012fa:	48 ba 81 44 80 00 00 	movabs $0x804481,%rdx
  801301:	00 00 00 
  801304:	48 89 c7             	mov    %rax,%rdi
  801307:	b8 00 00 00 00       	mov    $0x0,%eax
  80130c:	49 b8 01 16 80 00 00 	movabs $0x801601,%r8
  801313:	00 00 00 
  801316:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801319:	e9 d4 02 00 00       	jmpq   8015f2 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80131e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801322:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801326:	4c 89 e1             	mov    %r12,%rcx
  801329:	48 ba 8a 44 80 00 00 	movabs $0x80448a,%rdx
  801330:	00 00 00 
  801333:	48 89 c7             	mov    %rax,%rdi
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
  80133b:	49 b8 01 16 80 00 00 	movabs $0x801601,%r8
  801342:	00 00 00 
  801345:	41 ff d0             	callq  *%r8
			break;
  801348:	e9 a5 02 00 00       	jmpq   8015f2 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80134d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801350:	83 f8 30             	cmp    $0x30,%eax
  801353:	73 17                	jae    80136c <vprintfmt+0x296>
  801355:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801359:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80135c:	89 c0                	mov    %eax,%eax
  80135e:	48 01 d0             	add    %rdx,%rax
  801361:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801364:	83 c2 08             	add    $0x8,%edx
  801367:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80136a:	eb 0f                	jmp    80137b <vprintfmt+0x2a5>
  80136c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801370:	48 89 d0             	mov    %rdx,%rax
  801373:	48 83 c2 08          	add    $0x8,%rdx
  801377:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80137b:	4c 8b 20             	mov    (%rax),%r12
  80137e:	4d 85 e4             	test   %r12,%r12
  801381:	75 0a                	jne    80138d <vprintfmt+0x2b7>
				p = "(null)";
  801383:	49 bc 8d 44 80 00 00 	movabs $0x80448d,%r12
  80138a:	00 00 00 
			if (width > 0 && padc != '-')
  80138d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801391:	7e 3f                	jle    8013d2 <vprintfmt+0x2fc>
  801393:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801397:	74 39                	je     8013d2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801399:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80139c:	48 98                	cltq   
  80139e:	48 89 c6             	mov    %rax,%rsi
  8013a1:	4c 89 e7             	mov    %r12,%rdi
  8013a4:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  8013ab:	00 00 00 
  8013ae:	ff d0                	callq  *%rax
  8013b0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013b3:	eb 17                	jmp    8013cc <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013b5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013b9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c1:	48 89 ce             	mov    %rcx,%rsi
  8013c4:	89 d7                	mov    %edx,%edi
  8013c6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013d0:	7f e3                	jg     8013b5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d2:	eb 37                	jmp    80140b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013d8:	74 1e                	je     8013f8 <vprintfmt+0x322>
  8013da:	83 fb 1f             	cmp    $0x1f,%ebx
  8013dd:	7e 05                	jle    8013e4 <vprintfmt+0x30e>
  8013df:	83 fb 7e             	cmp    $0x7e,%ebx
  8013e2:	7e 14                	jle    8013f8 <vprintfmt+0x322>
					putch('?', putdat);
  8013e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ec:	48 89 d6             	mov    %rdx,%rsi
  8013ef:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013f4:	ff d0                	callq  *%rax
  8013f6:	eb 0f                	jmp    801407 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8013f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801400:	48 89 d6             	mov    %rdx,%rsi
  801403:	89 df                	mov    %ebx,%edi
  801405:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801407:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80140b:	4c 89 e0             	mov    %r12,%rax
  80140e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801412:	0f b6 00             	movzbl (%rax),%eax
  801415:	0f be d8             	movsbl %al,%ebx
  801418:	85 db                	test   %ebx,%ebx
  80141a:	74 10                	je     80142c <vprintfmt+0x356>
  80141c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801420:	78 b2                	js     8013d4 <vprintfmt+0x2fe>
  801422:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801426:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80142a:	79 a8                	jns    8013d4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80142c:	eb 16                	jmp    801444 <vprintfmt+0x36e>
				putch(' ', putdat);
  80142e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801432:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801436:	48 89 d6             	mov    %rdx,%rsi
  801439:	bf 20 00 00 00       	mov    $0x20,%edi
  80143e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801440:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801444:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801448:	7f e4                	jg     80142e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80144a:	e9 a3 01 00 00       	jmpq   8015f2 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80144f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801453:	be 03 00 00 00       	mov    $0x3,%esi
  801458:	48 89 c7             	mov    %rax,%rdi
  80145b:	48 b8 c6 0f 80 00 00 	movabs $0x800fc6,%rax
  801462:	00 00 00 
  801465:	ff d0                	callq  *%rax
  801467:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80146b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146f:	48 85 c0             	test   %rax,%rax
  801472:	79 1d                	jns    801491 <vprintfmt+0x3bb>
				putch('-', putdat);
  801474:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801478:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80147c:	48 89 d6             	mov    %rdx,%rsi
  80147f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801484:	ff d0                	callq  *%rax
				num = -(long long) num;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 f7 d8             	neg    %rax
  80148d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801491:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801498:	e9 e8 00 00 00       	jmpq   801585 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80149d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014a1:	be 03 00 00 00       	mov    $0x3,%esi
  8014a6:	48 89 c7             	mov    %rax,%rdi
  8014a9:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  8014b0:	00 00 00 
  8014b3:	ff d0                	callq  *%rax
  8014b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014b9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014c0:	e9 c0 00 00 00       	jmpq   801585 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014cd:	48 89 d6             	mov    %rdx,%rsi
  8014d0:	bf 58 00 00 00       	mov    $0x58,%edi
  8014d5:	ff d0                	callq  *%rax
			putch('X', putdat);
  8014d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014df:	48 89 d6             	mov    %rdx,%rsi
  8014e2:	bf 58 00 00 00       	mov    $0x58,%edi
  8014e7:	ff d0                	callq  *%rax
			putch('X', putdat);
  8014e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f1:	48 89 d6             	mov    %rdx,%rsi
  8014f4:	bf 58 00 00 00       	mov    $0x58,%edi
  8014f9:	ff d0                	callq  *%rax
			break;
  8014fb:	e9 f2 00 00 00       	jmpq   8015f2 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  801500:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801504:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801508:	48 89 d6             	mov    %rdx,%rsi
  80150b:	bf 30 00 00 00       	mov    $0x30,%edi
  801510:	ff d0                	callq  *%rax
			putch('x', putdat);
  801512:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801516:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80151a:	48 89 d6             	mov    %rdx,%rsi
  80151d:	bf 78 00 00 00       	mov    $0x78,%edi
  801522:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801524:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801527:	83 f8 30             	cmp    $0x30,%eax
  80152a:	73 17                	jae    801543 <vprintfmt+0x46d>
  80152c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801530:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801533:	89 c0                	mov    %eax,%eax
  801535:	48 01 d0             	add    %rdx,%rax
  801538:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80153b:	83 c2 08             	add    $0x8,%edx
  80153e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801541:	eb 0f                	jmp    801552 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  801543:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801547:	48 89 d0             	mov    %rdx,%rax
  80154a:	48 83 c2 08          	add    $0x8,%rdx
  80154e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801552:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801555:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801559:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801560:	eb 23                	jmp    801585 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801562:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801566:	be 03 00 00 00       	mov    $0x3,%esi
  80156b:	48 89 c7             	mov    %rax,%rdi
  80156e:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  801575:	00 00 00 
  801578:	ff d0                	callq  *%rax
  80157a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80157e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801585:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80158a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80158d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801590:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801594:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801598:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80159c:	45 89 c1             	mov    %r8d,%r9d
  80159f:	41 89 f8             	mov    %edi,%r8d
  8015a2:	48 89 c7             	mov    %rax,%rdi
  8015a5:	48 b8 fb 0d 80 00 00 	movabs $0x800dfb,%rax
  8015ac:	00 00 00 
  8015af:	ff d0                	callq  *%rax
			break;
  8015b1:	eb 3f                	jmp    8015f2 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015bb:	48 89 d6             	mov    %rdx,%rsi
  8015be:	89 df                	mov    %ebx,%edi
  8015c0:	ff d0                	callq  *%rax
			break;
  8015c2:	eb 2e                	jmp    8015f2 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015cc:	48 89 d6             	mov    %rdx,%rsi
  8015cf:	bf 25 00 00 00       	mov    $0x25,%edi
  8015d4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015d6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015db:	eb 05                	jmp    8015e2 <vprintfmt+0x50c>
  8015dd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015e6:	48 83 e8 01          	sub    $0x1,%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	3c 25                	cmp    $0x25,%al
  8015ef:	75 ec                	jne    8015dd <vprintfmt+0x507>
				/* do nothing */;
			break;
  8015f1:	90                   	nop
		}
	}
  8015f2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015f3:	e9 30 fb ff ff       	jmpq   801128 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015f8:	48 83 c4 60          	add    $0x60,%rsp
  8015fc:	5b                   	pop    %rbx
  8015fd:	41 5c                	pop    %r12
  8015ff:	5d                   	pop    %rbp
  801600:	c3                   	retq   

0000000000801601 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801601:	55                   	push   %rbp
  801602:	48 89 e5             	mov    %rsp,%rbp
  801605:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80160c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801613:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80161a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801621:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801628:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80162f:	84 c0                	test   %al,%al
  801631:	74 20                	je     801653 <printfmt+0x52>
  801633:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801637:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80163b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80163f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801643:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801647:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80164b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80164f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801653:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80165a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801661:	00 00 00 
  801664:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80166b:	00 00 00 
  80166e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801672:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801679:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801680:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801687:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80168e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801695:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80169c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8016a3:	48 89 c7             	mov    %rax,%rdi
  8016a6:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  8016ad:	00 00 00 
  8016b0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016b2:	c9                   	leaveq 
  8016b3:	c3                   	retq   

00000000008016b4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016b4:	55                   	push   %rbp
  8016b5:	48 89 e5             	mov    %rsp,%rbp
  8016b8:	48 83 ec 10          	sub    $0x10,%rsp
  8016bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c7:	8b 40 10             	mov    0x10(%rax),%eax
  8016ca:	8d 50 01             	lea    0x1(%rax),%edx
  8016cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d8:	48 8b 10             	mov    (%rax),%rdx
  8016db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016df:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016e3:	48 39 c2             	cmp    %rax,%rdx
  8016e6:	73 17                	jae    8016ff <sprintputch+0x4b>
		*b->buf++ = ch;
  8016e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ec:	48 8b 00             	mov    (%rax),%rax
  8016ef:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016f7:	48 89 0a             	mov    %rcx,(%rdx)
  8016fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016fd:	88 10                	mov    %dl,(%rax)
}
  8016ff:	c9                   	leaveq 
  801700:	c3                   	retq   

0000000000801701 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801701:	55                   	push   %rbp
  801702:	48 89 e5             	mov    %rsp,%rbp
  801705:	48 83 ec 50          	sub    $0x50,%rsp
  801709:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80170d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801710:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801714:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801718:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80171c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801720:	48 8b 0a             	mov    (%rdx),%rcx
  801723:	48 89 08             	mov    %rcx,(%rax)
  801726:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80172a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80172e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801732:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801736:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80173a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80173e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801741:	48 98                	cltq   
  801743:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801747:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80174b:	48 01 d0             	add    %rdx,%rax
  80174e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801752:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801759:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80175e:	74 06                	je     801766 <vsnprintf+0x65>
  801760:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801764:	7f 07                	jg     80176d <vsnprintf+0x6c>
		return -E_INVAL;
  801766:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176b:	eb 2f                	jmp    80179c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80176d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801771:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801775:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801779:	48 89 c6             	mov    %rax,%rsi
  80177c:	48 bf b4 16 80 00 00 	movabs $0x8016b4,%rdi
  801783:	00 00 00 
  801786:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  80178d:	00 00 00 
  801790:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801792:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801796:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801799:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80179c:	c9                   	leaveq 
  80179d:	c3                   	retq   

000000000080179e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80179e:	55                   	push   %rbp
  80179f:	48 89 e5             	mov    %rsp,%rbp
  8017a2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8017a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017b0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017b6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017bd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017c4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017cb:	84 c0                	test   %al,%al
  8017cd:	74 20                	je     8017ef <snprintf+0x51>
  8017cf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017d3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017d7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017db:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017df:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017e3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017e7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017eb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017ef:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017f6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017fd:	00 00 00 
  801800:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801807:	00 00 00 
  80180a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80180e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801815:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80181c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801823:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80182a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801831:	48 8b 0a             	mov    (%rdx),%rcx
  801834:	48 89 08             	mov    %rcx,(%rax)
  801837:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80183b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80183f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801843:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801847:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80184e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801855:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80185b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801862:	48 89 c7             	mov    %rax,%rdi
  801865:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  80186c:	00 00 00 
  80186f:	ff d0                	callq  *%rax
  801871:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801877:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 83 ec 18          	sub    $0x18,%rsp
  801887:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80188b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801892:	eb 09                	jmp    80189d <strlen+0x1e>
		n++;
  801894:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801898:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80189d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a1:	0f b6 00             	movzbl (%rax),%eax
  8018a4:	84 c0                	test   %al,%al
  8018a6:	75 ec                	jne    801894 <strlen+0x15>
		n++;
	return n;
  8018a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018ab:	c9                   	leaveq 
  8018ac:	c3                   	retq   

00000000008018ad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018ad:	55                   	push   %rbp
  8018ae:	48 89 e5             	mov    %rsp,%rbp
  8018b1:	48 83 ec 20          	sub    $0x20,%rsp
  8018b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018c4:	eb 0e                	jmp    8018d4 <strnlen+0x27>
		n++;
  8018c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018cf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018d4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018d9:	74 0b                	je     8018e6 <strnlen+0x39>
  8018db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018df:	0f b6 00             	movzbl (%rax),%eax
  8018e2:	84 c0                	test   %al,%al
  8018e4:	75 e0                	jne    8018c6 <strnlen+0x19>
		n++;
	return n;
  8018e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018e9:	c9                   	leaveq 
  8018ea:	c3                   	retq   

00000000008018eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018eb:	55                   	push   %rbp
  8018ec:	48 89 e5             	mov    %rsp,%rbp
  8018ef:	48 83 ec 20          	sub    $0x20,%rsp
  8018f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801903:	90                   	nop
  801904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801908:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80190c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801910:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801914:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801918:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80191c:	0f b6 12             	movzbl (%rdx),%edx
  80191f:	88 10                	mov    %dl,(%rax)
  801921:	0f b6 00             	movzbl (%rax),%eax
  801924:	84 c0                	test   %al,%al
  801926:	75 dc                	jne    801904 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801928:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80192c:	c9                   	leaveq 
  80192d:	c3                   	retq   

000000000080192e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80192e:	55                   	push   %rbp
  80192f:	48 89 e5             	mov    %rsp,%rbp
  801932:	48 83 ec 20          	sub    $0x20,%rsp
  801936:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80193a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80193e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801942:	48 89 c7             	mov    %rax,%rdi
  801945:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	callq  *%rax
  801951:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801957:	48 63 d0             	movslq %eax,%rdx
  80195a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80195e:	48 01 c2             	add    %rax,%rdx
  801961:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801965:	48 89 c6             	mov    %rax,%rsi
  801968:	48 89 d7             	mov    %rdx,%rdi
  80196b:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801972:	00 00 00 
  801975:	ff d0                	callq  *%rax
	return dst;
  801977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80197b:	c9                   	leaveq 
  80197c:	c3                   	retq   

000000000080197d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	48 83 ec 28          	sub    $0x28,%rsp
  801985:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801989:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80198d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801995:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801999:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019a0:	00 
  8019a1:	eb 2a                	jmp    8019cd <strncpy+0x50>
		*dst++ = *src;
  8019a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019b3:	0f b6 12             	movzbl (%rdx),%edx
  8019b6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019bc:	0f b6 00             	movzbl (%rax),%eax
  8019bf:	84 c0                	test   %al,%al
  8019c1:	74 05                	je     8019c8 <strncpy+0x4b>
			src++;
  8019c3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019d5:	72 cc                	jb     8019a3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019db:	c9                   	leaveq 
  8019dc:	c3                   	retq   

00000000008019dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019dd:	55                   	push   %rbp
  8019de:	48 89 e5             	mov    %rsp,%rbp
  8019e1:	48 83 ec 28          	sub    $0x28,%rsp
  8019e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019fe:	74 3d                	je     801a3d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801a00:	eb 1d                	jmp    801a1f <strlcpy+0x42>
			*dst++ = *src++;
  801a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a06:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a0e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a12:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a16:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a1a:	0f b6 12             	movzbl (%rdx),%edx
  801a1d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a1f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a24:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a29:	74 0b                	je     801a36 <strlcpy+0x59>
  801a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a2f:	0f b6 00             	movzbl (%rax),%eax
  801a32:	84 c0                	test   %al,%al
  801a34:	75 cc                	jne    801a02 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a3a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a45:	48 29 c2             	sub    %rax,%rdx
  801a48:	48 89 d0             	mov    %rdx,%rax
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 10          	sub    $0x10,%rsp
  801a55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a5d:	eb 0a                	jmp    801a69 <strcmp+0x1c>
		p++, q++;
  801a5f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a64:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6d:	0f b6 00             	movzbl (%rax),%eax
  801a70:	84 c0                	test   %al,%al
  801a72:	74 12                	je     801a86 <strcmp+0x39>
  801a74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a78:	0f b6 10             	movzbl (%rax),%edx
  801a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7f:	0f b6 00             	movzbl (%rax),%eax
  801a82:	38 c2                	cmp    %al,%dl
  801a84:	74 d9                	je     801a5f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8a:	0f b6 00             	movzbl (%rax),%eax
  801a8d:	0f b6 d0             	movzbl %al,%edx
  801a90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a94:	0f b6 00             	movzbl (%rax),%eax
  801a97:	0f b6 c0             	movzbl %al,%eax
  801a9a:	29 c2                	sub    %eax,%edx
  801a9c:	89 d0                	mov    %edx,%eax
}
  801a9e:	c9                   	leaveq 
  801a9f:	c3                   	retq   

0000000000801aa0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801aa0:	55                   	push   %rbp
  801aa1:	48 89 e5             	mov    %rsp,%rbp
  801aa4:	48 83 ec 18          	sub    $0x18,%rsp
  801aa8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801ab4:	eb 0f                	jmp    801ac5 <strncmp+0x25>
		n--, p++, q++;
  801ab6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801abb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ac0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ac5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aca:	74 1d                	je     801ae9 <strncmp+0x49>
  801acc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad0:	0f b6 00             	movzbl (%rax),%eax
  801ad3:	84 c0                	test   %al,%al
  801ad5:	74 12                	je     801ae9 <strncmp+0x49>
  801ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801adb:	0f b6 10             	movzbl (%rax),%edx
  801ade:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae2:	0f b6 00             	movzbl (%rax),%eax
  801ae5:	38 c2                	cmp    %al,%dl
  801ae7:	74 cd                	je     801ab6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ae9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aee:	75 07                	jne    801af7 <strncmp+0x57>
		return 0;
  801af0:	b8 00 00 00 00       	mov    $0x0,%eax
  801af5:	eb 18                	jmp    801b0f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afb:	0f b6 00             	movzbl (%rax),%eax
  801afe:	0f b6 d0             	movzbl %al,%edx
  801b01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b05:	0f b6 00             	movzbl (%rax),%eax
  801b08:	0f b6 c0             	movzbl %al,%eax
  801b0b:	29 c2                	sub    %eax,%edx
  801b0d:	89 d0                	mov    %edx,%eax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 0c          	sub    $0xc,%rsp
  801b19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b1d:	89 f0                	mov    %esi,%eax
  801b1f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b22:	eb 17                	jmp    801b3b <strchr+0x2a>
		if (*s == c)
  801b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b28:	0f b6 00             	movzbl (%rax),%eax
  801b2b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b2e:	75 06                	jne    801b36 <strchr+0x25>
			return (char *) s;
  801b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b34:	eb 15                	jmp    801b4b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b36:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3f:	0f b6 00             	movzbl (%rax),%eax
  801b42:	84 c0                	test   %al,%al
  801b44:	75 de                	jne    801b24 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 0c          	sub    $0xc,%rsp
  801b55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b59:	89 f0                	mov    %esi,%eax
  801b5b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b5e:	eb 13                	jmp    801b73 <strfind+0x26>
		if (*s == c)
  801b60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b64:	0f b6 00             	movzbl (%rax),%eax
  801b67:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b6a:	75 02                	jne    801b6e <strfind+0x21>
			break;
  801b6c:	eb 10                	jmp    801b7e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b6e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	84 c0                	test   %al,%al
  801b7c:	75 e2                	jne    801b60 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b82:	c9                   	leaveq 
  801b83:	c3                   	retq   

0000000000801b84 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b84:	55                   	push   %rbp
  801b85:	48 89 e5             	mov    %rsp,%rbp
  801b88:	48 83 ec 18          	sub    $0x18,%rsp
  801b8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b90:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b97:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b9c:	75 06                	jne    801ba4 <memset+0x20>
		return v;
  801b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba2:	eb 69                	jmp    801c0d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801ba4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba8:	83 e0 03             	and    $0x3,%eax
  801bab:	48 85 c0             	test   %rax,%rax
  801bae:	75 48                	jne    801bf8 <memset+0x74>
  801bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb4:	83 e0 03             	and    $0x3,%eax
  801bb7:	48 85 c0             	test   %rax,%rax
  801bba:	75 3c                	jne    801bf8 <memset+0x74>
		c &= 0xFF;
  801bbc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bc3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bc6:	c1 e0 18             	shl    $0x18,%eax
  801bc9:	89 c2                	mov    %eax,%edx
  801bcb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bce:	c1 e0 10             	shl    $0x10,%eax
  801bd1:	09 c2                	or     %eax,%edx
  801bd3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd6:	c1 e0 08             	shl    $0x8,%eax
  801bd9:	09 d0                	or     %edx,%eax
  801bdb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be2:	48 c1 e8 02          	shr    $0x2,%rax
  801be6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801be9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf0:	48 89 d7             	mov    %rdx,%rdi
  801bf3:	fc                   	cld    
  801bf4:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bf6:	eb 11                	jmp    801c09 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bf8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bfc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c03:	48 89 d7             	mov    %rdx,%rdi
  801c06:	fc                   	cld    
  801c07:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c0d:	c9                   	leaveq 
  801c0e:	c3                   	retq   

0000000000801c0f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c0f:	55                   	push   %rbp
  801c10:	48 89 e5             	mov    %rsp,%rbp
  801c13:	48 83 ec 28          	sub    $0x28,%rsp
  801c17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c37:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c3b:	0f 83 88 00 00 00    	jae    801cc9 <memmove+0xba>
  801c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c45:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c49:	48 01 d0             	add    %rdx,%rax
  801c4c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c50:	76 77                	jbe    801cc9 <memmove+0xba>
		s += n;
  801c52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c56:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c66:	83 e0 03             	and    $0x3,%eax
  801c69:	48 85 c0             	test   %rax,%rax
  801c6c:	75 3b                	jne    801ca9 <memmove+0x9a>
  801c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c72:	83 e0 03             	and    $0x3,%eax
  801c75:	48 85 c0             	test   %rax,%rax
  801c78:	75 2f                	jne    801ca9 <memmove+0x9a>
  801c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7e:	83 e0 03             	and    $0x3,%eax
  801c81:	48 85 c0             	test   %rax,%rax
  801c84:	75 23                	jne    801ca9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8a:	48 83 e8 04          	sub    $0x4,%rax
  801c8e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c92:	48 83 ea 04          	sub    $0x4,%rdx
  801c96:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c9a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c9e:	48 89 c7             	mov    %rax,%rdi
  801ca1:	48 89 d6             	mov    %rdx,%rsi
  801ca4:	fd                   	std    
  801ca5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ca7:	eb 1d                	jmp    801cc6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ca9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cad:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801cb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801cb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbd:	48 89 d7             	mov    %rdx,%rdi
  801cc0:	48 89 c1             	mov    %rax,%rcx
  801cc3:	fd                   	std    
  801cc4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cc6:	fc                   	cld    
  801cc7:	eb 57                	jmp    801d20 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ccd:	83 e0 03             	and    $0x3,%eax
  801cd0:	48 85 c0             	test   %rax,%rax
  801cd3:	75 36                	jne    801d0b <memmove+0xfc>
  801cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd9:	83 e0 03             	and    $0x3,%eax
  801cdc:	48 85 c0             	test   %rax,%rax
  801cdf:	75 2a                	jne    801d0b <memmove+0xfc>
  801ce1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce5:	83 e0 03             	and    $0x3,%eax
  801ce8:	48 85 c0             	test   %rax,%rax
  801ceb:	75 1e                	jne    801d0b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ced:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf1:	48 c1 e8 02          	shr    $0x2,%rax
  801cf5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d00:	48 89 c7             	mov    %rax,%rdi
  801d03:	48 89 d6             	mov    %rdx,%rsi
  801d06:	fc                   	cld    
  801d07:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d09:	eb 15                	jmp    801d20 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d13:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d17:	48 89 c7             	mov    %rax,%rdi
  801d1a:	48 89 d6             	mov    %rdx,%rsi
  801d1d:	fc                   	cld    
  801d1e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d24:	c9                   	leaveq 
  801d25:	c3                   	retq   

0000000000801d26 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
  801d2a:	48 83 ec 18          	sub    $0x18,%rsp
  801d2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d36:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d3e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d46:	48 89 ce             	mov    %rcx,%rsi
  801d49:	48 89 c7             	mov    %rax,%rdi
  801d4c:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
}
  801d58:	c9                   	leaveq 
  801d59:	c3                   	retq   

0000000000801d5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d5a:	55                   	push   %rbp
  801d5b:	48 89 e5             	mov    %rsp,%rbp
  801d5e:	48 83 ec 28          	sub    $0x28,%rsp
  801d62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d7e:	eb 36                	jmp    801db6 <memcmp+0x5c>
		if (*s1 != *s2)
  801d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d84:	0f b6 10             	movzbl (%rax),%edx
  801d87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8b:	0f b6 00             	movzbl (%rax),%eax
  801d8e:	38 c2                	cmp    %al,%dl
  801d90:	74 1a                	je     801dac <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d96:	0f b6 00             	movzbl (%rax),%eax
  801d99:	0f b6 d0             	movzbl %al,%edx
  801d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da0:	0f b6 00             	movzbl (%rax),%eax
  801da3:	0f b6 c0             	movzbl %al,%eax
  801da6:	29 c2                	sub    %eax,%edx
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	eb 20                	jmp    801dcc <memcmp+0x72>
		s1++, s2++;
  801dac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801db1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801db6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801dbe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801dc2:	48 85 c0             	test   %rax,%rax
  801dc5:	75 b9                	jne    801d80 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcc:	c9                   	leaveq 
  801dcd:	c3                   	retq   

0000000000801dce <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dce:	55                   	push   %rbp
  801dcf:	48 89 e5             	mov    %rsp,%rbp
  801dd2:	48 83 ec 28          	sub    $0x28,%rsp
  801dd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dda:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801ddd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801de1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801de9:	48 01 d0             	add    %rdx,%rax
  801dec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801df0:	eb 15                	jmp    801e07 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801df2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df6:	0f b6 10             	movzbl (%rax),%edx
  801df9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dfc:	38 c2                	cmp    %al,%dl
  801dfe:	75 02                	jne    801e02 <memfind+0x34>
			break;
  801e00:	eb 0f                	jmp    801e11 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e02:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e0f:	72 e1                	jb     801df2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e15:	c9                   	leaveq 
  801e16:	c3                   	retq   

0000000000801e17 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
  801e1b:	48 83 ec 34          	sub    $0x34,%rsp
  801e1f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e27:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e31:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e38:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e39:	eb 05                	jmp    801e40 <strtol+0x29>
		s++;
  801e3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e44:	0f b6 00             	movzbl (%rax),%eax
  801e47:	3c 20                	cmp    $0x20,%al
  801e49:	74 f0                	je     801e3b <strtol+0x24>
  801e4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4f:	0f b6 00             	movzbl (%rax),%eax
  801e52:	3c 09                	cmp    $0x9,%al
  801e54:	74 e5                	je     801e3b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5a:	0f b6 00             	movzbl (%rax),%eax
  801e5d:	3c 2b                	cmp    $0x2b,%al
  801e5f:	75 07                	jne    801e68 <strtol+0x51>
		s++;
  801e61:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e66:	eb 17                	jmp    801e7f <strtol+0x68>
	else if (*s == '-')
  801e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6c:	0f b6 00             	movzbl (%rax),%eax
  801e6f:	3c 2d                	cmp    $0x2d,%al
  801e71:	75 0c                	jne    801e7f <strtol+0x68>
		s++, neg = 1;
  801e73:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e78:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e7f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e83:	74 06                	je     801e8b <strtol+0x74>
  801e85:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e89:	75 28                	jne    801eb3 <strtol+0x9c>
  801e8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8f:	0f b6 00             	movzbl (%rax),%eax
  801e92:	3c 30                	cmp    $0x30,%al
  801e94:	75 1d                	jne    801eb3 <strtol+0x9c>
  801e96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9a:	48 83 c0 01          	add    $0x1,%rax
  801e9e:	0f b6 00             	movzbl (%rax),%eax
  801ea1:	3c 78                	cmp    $0x78,%al
  801ea3:	75 0e                	jne    801eb3 <strtol+0x9c>
		s += 2, base = 16;
  801ea5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801eaa:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801eb1:	eb 2c                	jmp    801edf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801eb3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eb7:	75 19                	jne    801ed2 <strtol+0xbb>
  801eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebd:	0f b6 00             	movzbl (%rax),%eax
  801ec0:	3c 30                	cmp    $0x30,%al
  801ec2:	75 0e                	jne    801ed2 <strtol+0xbb>
		s++, base = 8;
  801ec4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ec9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ed0:	eb 0d                	jmp    801edf <strtol+0xc8>
	else if (base == 0)
  801ed2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ed6:	75 07                	jne    801edf <strtol+0xc8>
		base = 10;
  801ed8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801edf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee3:	0f b6 00             	movzbl (%rax),%eax
  801ee6:	3c 2f                	cmp    $0x2f,%al
  801ee8:	7e 1d                	jle    801f07 <strtol+0xf0>
  801eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eee:	0f b6 00             	movzbl (%rax),%eax
  801ef1:	3c 39                	cmp    $0x39,%al
  801ef3:	7f 12                	jg     801f07 <strtol+0xf0>
			dig = *s - '0';
  801ef5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef9:	0f b6 00             	movzbl (%rax),%eax
  801efc:	0f be c0             	movsbl %al,%eax
  801eff:	83 e8 30             	sub    $0x30,%eax
  801f02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f05:	eb 4e                	jmp    801f55 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801f07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0b:	0f b6 00             	movzbl (%rax),%eax
  801f0e:	3c 60                	cmp    $0x60,%al
  801f10:	7e 1d                	jle    801f2f <strtol+0x118>
  801f12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f16:	0f b6 00             	movzbl (%rax),%eax
  801f19:	3c 7a                	cmp    $0x7a,%al
  801f1b:	7f 12                	jg     801f2f <strtol+0x118>
			dig = *s - 'a' + 10;
  801f1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f21:	0f b6 00             	movzbl (%rax),%eax
  801f24:	0f be c0             	movsbl %al,%eax
  801f27:	83 e8 57             	sub    $0x57,%eax
  801f2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f2d:	eb 26                	jmp    801f55 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f33:	0f b6 00             	movzbl (%rax),%eax
  801f36:	3c 40                	cmp    $0x40,%al
  801f38:	7e 48                	jle    801f82 <strtol+0x16b>
  801f3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3e:	0f b6 00             	movzbl (%rax),%eax
  801f41:	3c 5a                	cmp    $0x5a,%al
  801f43:	7f 3d                	jg     801f82 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f49:	0f b6 00             	movzbl (%rax),%eax
  801f4c:	0f be c0             	movsbl %al,%eax
  801f4f:	83 e8 37             	sub    $0x37,%eax
  801f52:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f58:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f5b:	7c 02                	jl     801f5f <strtol+0x148>
			break;
  801f5d:	eb 23                	jmp    801f82 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f5f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f64:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f67:	48 98                	cltq   
  801f69:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f6e:	48 89 c2             	mov    %rax,%rdx
  801f71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f74:	48 98                	cltq   
  801f76:	48 01 d0             	add    %rdx,%rax
  801f79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f7d:	e9 5d ff ff ff       	jmpq   801edf <strtol+0xc8>

	if (endptr)
  801f82:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f87:	74 0b                	je     801f94 <strtol+0x17d>
		*endptr = (char *) s;
  801f89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f91:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f98:	74 09                	je     801fa3 <strtol+0x18c>
  801f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9e:	48 f7 d8             	neg    %rax
  801fa1:	eb 04                	jmp    801fa7 <strtol+0x190>
  801fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801fa7:	c9                   	leaveq 
  801fa8:	c3                   	retq   

0000000000801fa9 <strstr>:

char * strstr(const char *in, const char *str)
{
  801fa9:	55                   	push   %rbp
  801faa:	48 89 e5             	mov    %rsp,%rbp
  801fad:	48 83 ec 30          	sub    $0x30,%rsp
  801fb1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fb5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fc1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fc5:	0f b6 00             	movzbl (%rax),%eax
  801fc8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fcb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fcf:	75 06                	jne    801fd7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd5:	eb 6b                	jmp    802042 <strstr+0x99>

	len = strlen(str);
  801fd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fdb:	48 89 c7             	mov    %rax,%rdi
  801fde:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	callq  *%rax
  801fea:	48 98                	cltq   
  801fec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ff8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ffc:	0f b6 00             	movzbl (%rax),%eax
  801fff:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802002:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802006:	75 07                	jne    80200f <strstr+0x66>
				return (char *) 0;
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	eb 33                	jmp    802042 <strstr+0x99>
		} while (sc != c);
  80200f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802013:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802016:	75 d8                	jne    801ff0 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802018:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802020:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802024:	48 89 ce             	mov    %rcx,%rsi
  802027:	48 89 c7             	mov    %rax,%rdi
  80202a:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  802031:	00 00 00 
  802034:	ff d0                	callq  *%rax
  802036:	85 c0                	test   %eax,%eax
  802038:	75 b6                	jne    801ff0 <strstr+0x47>

	return (char *) (in - 1);
  80203a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80203e:	48 83 e8 01          	sub    $0x1,%rax
}
  802042:	c9                   	leaveq 
  802043:	c3                   	retq   

0000000000802044 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	53                   	push   %rbx
  802049:	48 83 ec 48          	sub    $0x48,%rsp
  80204d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802050:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802053:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802057:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80205b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80205f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802063:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80206a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80206e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802072:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802076:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80207a:	4c 89 c3             	mov    %r8,%rbx
  80207d:	cd 30                	int    $0x30
  80207f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802083:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802087:	74 3e                	je     8020c7 <syscall+0x83>
  802089:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80208e:	7e 37                	jle    8020c7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802090:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802094:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802097:	49 89 d0             	mov    %rdx,%r8
  80209a:	89 c1                	mov    %eax,%ecx
  80209c:	48 ba 48 47 80 00 00 	movabs $0x804748,%rdx
  8020a3:	00 00 00 
  8020a6:	be 23 00 00 00       	mov    $0x23,%esi
  8020ab:	48 bf 65 47 80 00 00 	movabs $0x804765,%rdi
  8020b2:	00 00 00 
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	49 b9 ea 0a 80 00 00 	movabs $0x800aea,%r9
  8020c1:	00 00 00 
  8020c4:	41 ff d1             	callq  *%r9

	return ret;
  8020c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020cb:	48 83 c4 48          	add    $0x48,%rsp
  8020cf:	5b                   	pop    %rbx
  8020d0:	5d                   	pop    %rbp
  8020d1:	c3                   	retq   

00000000008020d2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020d2:	55                   	push   %rbp
  8020d3:	48 89 e5             	mov    %rsp,%rbp
  8020d6:	48 83 ec 20          	sub    $0x20,%rsp
  8020da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020f1:	00 
  8020f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020fe:	48 89 d1             	mov    %rdx,%rcx
  802101:	48 89 c2             	mov    %rax,%rdx
  802104:	be 00 00 00 00       	mov    $0x0,%esi
  802109:	bf 00 00 00 00       	mov    $0x0,%edi
  80210e:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
}
  80211a:	c9                   	leaveq 
  80211b:	c3                   	retq   

000000000080211c <sys_cgetc>:

int
sys_cgetc(void)
{
  80211c:	55                   	push   %rbp
  80211d:	48 89 e5             	mov    %rsp,%rbp
  802120:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802124:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80212b:	00 
  80212c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802132:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802138:	b9 00 00 00 00       	mov    $0x0,%ecx
  80213d:	ba 00 00 00 00       	mov    $0x0,%edx
  802142:	be 00 00 00 00       	mov    $0x0,%esi
  802147:	bf 01 00 00 00       	mov    $0x1,%edi
  80214c:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802153:	00 00 00 
  802156:	ff d0                	callq  *%rax
}
  802158:	c9                   	leaveq 
  802159:	c3                   	retq   

000000000080215a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	48 83 ec 10          	sub    $0x10,%rsp
  802162:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802168:	48 98                	cltq   
  80216a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802171:	00 
  802172:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802178:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80217e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802183:	48 89 c2             	mov    %rax,%rdx
  802186:	be 01 00 00 00       	mov    $0x1,%esi
  80218b:	bf 03 00 00 00       	mov    $0x3,%edi
  802190:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802197:	00 00 00 
  80219a:	ff d0                	callq  *%rax
}
  80219c:	c9                   	leaveq 
  80219d:	c3                   	retq   

000000000080219e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80219e:	55                   	push   %rbp
  80219f:	48 89 e5             	mov    %rsp,%rbp
  8021a2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8021a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021ad:	00 
  8021ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c4:	be 00 00 00 00       	mov    $0x0,%esi
  8021c9:	bf 02 00 00 00       	mov    $0x2,%edi
  8021ce:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  8021d5:	00 00 00 
  8021d8:	ff d0                	callq  *%rax
}
  8021da:	c9                   	leaveq 
  8021db:	c3                   	retq   

00000000008021dc <sys_yield>:

void
sys_yield(void)
{
  8021dc:	55                   	push   %rbp
  8021dd:	48 89 e5             	mov    %rsp,%rbp
  8021e0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021eb:	00 
  8021ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802202:	be 00 00 00 00       	mov    $0x0,%esi
  802207:	bf 0b 00 00 00       	mov    $0xb,%edi
  80220c:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802213:	00 00 00 
  802216:	ff d0                	callq  *%rax
}
  802218:	c9                   	leaveq 
  802219:	c3                   	retq   

000000000080221a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80221a:	55                   	push   %rbp
  80221b:	48 89 e5             	mov    %rsp,%rbp
  80221e:	48 83 ec 20          	sub    $0x20,%rsp
  802222:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802225:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802229:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80222c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80222f:	48 63 c8             	movslq %eax,%rcx
  802232:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802239:	48 98                	cltq   
  80223b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802242:	00 
  802243:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802249:	49 89 c8             	mov    %rcx,%r8
  80224c:	48 89 d1             	mov    %rdx,%rcx
  80224f:	48 89 c2             	mov    %rax,%rdx
  802252:	be 01 00 00 00       	mov    $0x1,%esi
  802257:	bf 04 00 00 00       	mov    $0x4,%edi
  80225c:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802263:	00 00 00 
  802266:	ff d0                	callq  *%rax
}
  802268:	c9                   	leaveq 
  802269:	c3                   	retq   

000000000080226a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80226a:	55                   	push   %rbp
  80226b:	48 89 e5             	mov    %rsp,%rbp
  80226e:	48 83 ec 30          	sub    $0x30,%rsp
  802272:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802275:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802279:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80227c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802280:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802284:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802287:	48 63 c8             	movslq %eax,%rcx
  80228a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80228e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802291:	48 63 f0             	movslq %eax,%rsi
  802294:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802298:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229b:	48 98                	cltq   
  80229d:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022a1:	49 89 f9             	mov    %rdi,%r9
  8022a4:	49 89 f0             	mov    %rsi,%r8
  8022a7:	48 89 d1             	mov    %rdx,%rcx
  8022aa:	48 89 c2             	mov    %rax,%rdx
  8022ad:	be 01 00 00 00       	mov    $0x1,%esi
  8022b2:	bf 05 00 00 00       	mov    $0x5,%edi
  8022b7:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	callq  *%rax
}
  8022c3:	c9                   	leaveq 
  8022c4:	c3                   	retq   

00000000008022c5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022c5:	55                   	push   %rbp
  8022c6:	48 89 e5             	mov    %rsp,%rbp
  8022c9:	48 83 ec 20          	sub    $0x20,%rsp
  8022cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022db:	48 98                	cltq   
  8022dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022e4:	00 
  8022e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022f1:	48 89 d1             	mov    %rdx,%rcx
  8022f4:	48 89 c2             	mov    %rax,%rdx
  8022f7:	be 01 00 00 00       	mov    $0x1,%esi
  8022fc:	bf 06 00 00 00       	mov    $0x6,%edi
  802301:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802308:	00 00 00 
  80230b:	ff d0                	callq  *%rax
}
  80230d:	c9                   	leaveq 
  80230e:	c3                   	retq   

000000000080230f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80230f:	55                   	push   %rbp
  802310:	48 89 e5             	mov    %rsp,%rbp
  802313:	48 83 ec 10          	sub    $0x10,%rsp
  802317:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80231a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80231d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802320:	48 63 d0             	movslq %eax,%rdx
  802323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802326:	48 98                	cltq   
  802328:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80232f:	00 
  802330:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802336:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80233c:	48 89 d1             	mov    %rdx,%rcx
  80233f:	48 89 c2             	mov    %rax,%rdx
  802342:	be 01 00 00 00       	mov    $0x1,%esi
  802347:	bf 08 00 00 00       	mov    $0x8,%edi
  80234c:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802353:	00 00 00 
  802356:	ff d0                	callq  *%rax
}
  802358:	c9                   	leaveq 
  802359:	c3                   	retq   

000000000080235a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80235a:	55                   	push   %rbp
  80235b:	48 89 e5             	mov    %rsp,%rbp
  80235e:	48 83 ec 20          	sub    $0x20,%rsp
  802362:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802365:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802369:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802370:	48 98                	cltq   
  802372:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802379:	00 
  80237a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802380:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802386:	48 89 d1             	mov    %rdx,%rcx
  802389:	48 89 c2             	mov    %rax,%rdx
  80238c:	be 01 00 00 00       	mov    $0x1,%esi
  802391:	bf 09 00 00 00       	mov    $0x9,%edi
  802396:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
}
  8023a2:	c9                   	leaveq 
  8023a3:	c3                   	retq   

00000000008023a4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
  8023a8:	48 83 ec 20          	sub    $0x20,%rsp
  8023ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8023b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ba:	48 98                	cltq   
  8023bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023c3:	00 
  8023c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023d0:	48 89 d1             	mov    %rdx,%rcx
  8023d3:	48 89 c2             	mov    %rax,%rdx
  8023d6:	be 01 00 00 00       	mov    $0x1,%esi
  8023db:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023e0:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
}
  8023ec:	c9                   	leaveq 
  8023ed:	c3                   	retq   

00000000008023ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	48 83 ec 20          	sub    $0x20,%rsp
  8023f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802401:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802404:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802407:	48 63 f0             	movslq %eax,%rsi
  80240a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80240e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802411:	48 98                	cltq   
  802413:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802417:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80241e:	00 
  80241f:	49 89 f1             	mov    %rsi,%r9
  802422:	49 89 c8             	mov    %rcx,%r8
  802425:	48 89 d1             	mov    %rdx,%rcx
  802428:	48 89 c2             	mov    %rax,%rdx
  80242b:	be 00 00 00 00       	mov    $0x0,%esi
  802430:	bf 0c 00 00 00       	mov    $0xc,%edi
  802435:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax
}
  802441:	c9                   	leaveq 
  802442:	c3                   	retq   

0000000000802443 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802443:	55                   	push   %rbp
  802444:	48 89 e5             	mov    %rsp,%rbp
  802447:	48 83 ec 10          	sub    $0x10,%rsp
  80244b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80244f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802453:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80245a:	00 
  80245b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802461:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802467:	b9 00 00 00 00       	mov    $0x0,%ecx
  80246c:	48 89 c2             	mov    %rax,%rdx
  80246f:	be 01 00 00 00       	mov    $0x1,%esi
  802474:	bf 0d 00 00 00       	mov    $0xd,%edi
  802479:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802480:	00 00 00 
  802483:	ff d0                	callq  *%rax
}
  802485:	c9                   	leaveq 
  802486:	c3                   	retq   

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
  802493:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
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
  8024b4:	48 b8 1a 22 80 00 00 	movabs $0x80221a,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	79 2a                	jns    8024ee <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8024c4:	48 ba 78 47 80 00 00 	movabs $0x804778,%rdx
  8024cb:	00 00 00 
  8024ce:	be 21 00 00 00       	mov    $0x21,%esi
  8024d3:	48 bf a3 47 80 00 00 	movabs $0x8047a3,%rdi
  8024da:	00 00 00 
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	48 b9 ea 0a 80 00 00 	movabs $0x800aea,%rcx
  8024e9:	00 00 00 
  8024ec:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024ee:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  8024f5:	00 00 00 
  8024f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024fc:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8024ff:	48 be 4a 25 80 00 00 	movabs $0x80254a,%rsi
  802506:	00 00 00 
  802509:	bf 00 00 00 00       	mov    $0x0,%edi
  80250e:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802515:	00 00 00 
  802518:	ff d0                	callq  *%rax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	79 2a                	jns    802548 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80251e:	48 ba b8 47 80 00 00 	movabs $0x8047b8,%rdx
  802525:	00 00 00 
  802528:	be 27 00 00 00       	mov    $0x27,%esi
  80252d:	48 bf a3 47 80 00 00 	movabs $0x8047a3,%rdi
  802534:	00 00 00 
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
  80253c:	48 b9 ea 0a 80 00 00 	movabs $0x800aea,%rcx
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
  80254d:	48 a1 e0 71 80 00 00 	movabs 0x8071e0,%rax
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

00000000008025d1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025d1:	55                   	push   %rbp
  8025d2:	48 89 e5             	mov    %rsp,%rbp
  8025d5:	48 83 ec 08          	sub    $0x8,%rsp
  8025d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025e1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025e8:	ff ff ff 
  8025eb:	48 01 d0             	add    %rdx,%rax
  8025ee:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025f2:	c9                   	leaveq 
  8025f3:	c3                   	retq   

00000000008025f4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 08          	sub    $0x8,%rsp
  8025fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802604:	48 89 c7             	mov    %rax,%rdi
  802607:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  80260e:	00 00 00 
  802611:	ff d0                	callq  *%rax
  802613:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802619:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80261d:	c9                   	leaveq 
  80261e:	c3                   	retq   

000000000080261f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80261f:	55                   	push   %rbp
  802620:	48 89 e5             	mov    %rsp,%rbp
  802623:	48 83 ec 18          	sub    $0x18,%rsp
  802627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80262b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802632:	eb 6b                	jmp    80269f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802637:	48 98                	cltq   
  802639:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80263f:	48 c1 e0 0c          	shl    $0xc,%rax
  802643:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264b:	48 c1 e8 15          	shr    $0x15,%rax
  80264f:	48 89 c2             	mov    %rax,%rdx
  802652:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802659:	01 00 00 
  80265c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802660:	83 e0 01             	and    $0x1,%eax
  802663:	48 85 c0             	test   %rax,%rax
  802666:	74 21                	je     802689 <fd_alloc+0x6a>
  802668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266c:	48 c1 e8 0c          	shr    $0xc,%rax
  802670:	48 89 c2             	mov    %rax,%rdx
  802673:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267a:	01 00 00 
  80267d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802681:	83 e0 01             	and    $0x1,%eax
  802684:	48 85 c0             	test   %rax,%rax
  802687:	75 12                	jne    80269b <fd_alloc+0x7c>
			*fd_store = fd;
  802689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802691:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
  802699:	eb 1a                	jmp    8026b5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80269b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80269f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026a3:	7e 8f                	jle    802634 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026b0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026b5:	c9                   	leaveq 
  8026b6:	c3                   	retq   

00000000008026b7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	48 83 ec 20          	sub    $0x20,%rsp
  8026bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026ca:	78 06                	js     8026d2 <fd_lookup+0x1b>
  8026cc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026d0:	7e 07                	jle    8026d9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026d7:	eb 6c                	jmp    802745 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026dc:	48 98                	cltq   
  8026de:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026e4:	48 c1 e0 0c          	shl    $0xc,%rax
  8026e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f0:	48 c1 e8 15          	shr    $0x15,%rax
  8026f4:	48 89 c2             	mov    %rax,%rdx
  8026f7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026fe:	01 00 00 
  802701:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802705:	83 e0 01             	and    $0x1,%eax
  802708:	48 85 c0             	test   %rax,%rax
  80270b:	74 21                	je     80272e <fd_lookup+0x77>
  80270d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802711:	48 c1 e8 0c          	shr    $0xc,%rax
  802715:	48 89 c2             	mov    %rax,%rdx
  802718:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80271f:	01 00 00 
  802722:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802726:	83 e0 01             	and    $0x1,%eax
  802729:	48 85 c0             	test   %rax,%rax
  80272c:	75 07                	jne    802735 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80272e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802733:	eb 10                	jmp    802745 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802735:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802739:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80273d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802745:	c9                   	leaveq 
  802746:	c3                   	retq   

0000000000802747 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802747:	55                   	push   %rbp
  802748:	48 89 e5             	mov    %rsp,%rbp
  80274b:	48 83 ec 30          	sub    $0x30,%rsp
  80274f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802753:	89 f0                	mov    %esi,%eax
  802755:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80275c:	48 89 c7             	mov    %rax,%rdi
  80275f:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  802766:	00 00 00 
  802769:	ff d0                	callq  *%rax
  80276b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80276f:	48 89 d6             	mov    %rdx,%rsi
  802772:	89 c7                	mov    %eax,%edi
  802774:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	callq  *%rax
  802780:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802783:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802787:	78 0a                	js     802793 <fd_close+0x4c>
	    || fd != fd2)
  802789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802791:	74 12                	je     8027a5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802793:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802797:	74 05                	je     80279e <fd_close+0x57>
  802799:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279c:	eb 05                	jmp    8027a3 <fd_close+0x5c>
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	eb 69                	jmp    80280e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	8b 00                	mov    (%rax),%eax
  8027ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027af:	48 89 d6             	mov    %rdx,%rsi
  8027b2:	89 c7                	mov    %eax,%edi
  8027b4:	48 b8 10 28 80 00 00 	movabs $0x802810,%rax
  8027bb:	00 00 00 
  8027be:	ff d0                	callq  *%rax
  8027c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c7:	78 2a                	js     8027f3 <fd_close+0xac>
		if (dev->dev_close)
  8027c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027d1:	48 85 c0             	test   %rax,%rax
  8027d4:	74 16                	je     8027ec <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027da:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e2:	48 89 d7             	mov    %rdx,%rdi
  8027e5:	ff d0                	callq  *%rax
  8027e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ea:	eb 07                	jmp    8027f3 <fd_close+0xac>
		else
			r = 0;
  8027ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f7:	48 89 c6             	mov    %rax,%rsi
  8027fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ff:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  802806:	00 00 00 
  802809:	ff d0                	callq  *%rax
	return r;
  80280b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80280e:	c9                   	leaveq 
  80280f:	c3                   	retq   

0000000000802810 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802810:	55                   	push   %rbp
  802811:	48 89 e5             	mov    %rsp,%rbp
  802814:	48 83 ec 20          	sub    $0x20,%rsp
  802818:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80281b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80281f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802826:	eb 41                	jmp    802869 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802828:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80282f:	00 00 00 
  802832:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802835:	48 63 d2             	movslq %edx,%rdx
  802838:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80283c:	8b 00                	mov    (%rax),%eax
  80283e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802841:	75 22                	jne    802865 <dev_lookup+0x55>
			*dev = devtab[i];
  802843:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80284a:	00 00 00 
  80284d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802850:	48 63 d2             	movslq %edx,%rdx
  802853:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802857:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80285b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80285e:	b8 00 00 00 00       	mov    $0x0,%eax
  802863:	eb 60                	jmp    8028c5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802865:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802869:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802870:	00 00 00 
  802873:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802876:	48 63 d2             	movslq %edx,%rdx
  802879:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287d:	48 85 c0             	test   %rax,%rax
  802880:	75 a6                	jne    802828 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802882:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802889:	00 00 00 
  80288c:	48 8b 00             	mov    (%rax),%rax
  80288f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802895:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802898:	89 c6                	mov    %eax,%esi
  80289a:	48 bf f0 47 80 00 00 	movabs $0x8047f0,%rdi
  8028a1:	00 00 00 
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a9:	48 b9 23 0d 80 00 00 	movabs $0x800d23,%rcx
  8028b0:	00 00 00 
  8028b3:	ff d1                	callq  *%rcx
	*dev = 0;
  8028b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028c5:	c9                   	leaveq 
  8028c6:	c3                   	retq   

00000000008028c7 <close>:

int
close(int fdnum)
{
  8028c7:	55                   	push   %rbp
  8028c8:	48 89 e5             	mov    %rsp,%rbp
  8028cb:	48 83 ec 20          	sub    $0x20,%rsp
  8028cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d9:	48 89 d6             	mov    %rdx,%rsi
  8028dc:	89 c7                	mov    %eax,%edi
  8028de:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
  8028ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f1:	79 05                	jns    8028f8 <close+0x31>
		return r;
  8028f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f6:	eb 18                	jmp    802910 <close+0x49>
	else
		return fd_close(fd, 1);
  8028f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fc:	be 01 00 00 00       	mov    $0x1,%esi
  802901:	48 89 c7             	mov    %rax,%rdi
  802904:	48 b8 47 27 80 00 00 	movabs $0x802747,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <close_all>:

void
close_all(void)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80291a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802921:	eb 15                	jmp    802938 <close_all+0x26>
		close(i);
  802923:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802926:	89 c7                	mov    %eax,%edi
  802928:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  80292f:	00 00 00 
  802932:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802934:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802938:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80293c:	7e e5                	jle    802923 <close_all+0x11>
		close(i);
}
  80293e:	c9                   	leaveq 
  80293f:	c3                   	retq   

0000000000802940 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802940:	55                   	push   %rbp
  802941:	48 89 e5             	mov    %rsp,%rbp
  802944:	48 83 ec 40          	sub    $0x40,%rsp
  802948:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80294b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80294e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802952:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802955:	48 89 d6             	mov    %rdx,%rsi
  802958:	89 c7                	mov    %eax,%edi
  80295a:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
  802966:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802969:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296d:	79 08                	jns    802977 <dup+0x37>
		return r;
  80296f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802972:	e9 70 01 00 00       	jmpq   802ae7 <dup+0x1a7>
	close(newfdnum);
  802977:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80297a:	89 c7                	mov    %eax,%edi
  80297c:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802988:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80298b:	48 98                	cltq   
  80298d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802993:	48 c1 e0 0c          	shl    $0xc,%rax
  802997:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80299b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80299f:	48 89 c7             	mov    %rax,%rdi
  8029a2:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
  8029ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b6:	48 89 c7             	mov    %rax,%rdi
  8029b9:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cd:	48 c1 e8 15          	shr    $0x15,%rax
  8029d1:	48 89 c2             	mov    %rax,%rdx
  8029d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029db:	01 00 00 
  8029de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e2:	83 e0 01             	and    $0x1,%eax
  8029e5:	48 85 c0             	test   %rax,%rax
  8029e8:	74 73                	je     802a5d <dup+0x11d>
  8029ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f2:	48 89 c2             	mov    %rax,%rdx
  8029f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029fc:	01 00 00 
  8029ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a03:	83 e0 01             	and    $0x1,%eax
  802a06:	48 85 c0             	test   %rax,%rax
  802a09:	74 52                	je     802a5d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0f:	48 c1 e8 0c          	shr    $0xc,%rax
  802a13:	48 89 c2             	mov    %rax,%rdx
  802a16:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a1d:	01 00 00 
  802a20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a24:	25 07 0e 00 00       	and    $0xe07,%eax
  802a29:	89 c1                	mov    %eax,%ecx
  802a2b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a33:	41 89 c8             	mov    %ecx,%r8d
  802a36:	48 89 d1             	mov    %rdx,%rcx
  802a39:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3e:	48 89 c6             	mov    %rax,%rsi
  802a41:	bf 00 00 00 00       	mov    $0x0,%edi
  802a46:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
  802a52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a59:	79 02                	jns    802a5d <dup+0x11d>
			goto err;
  802a5b:	eb 57                	jmp    802ab4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a61:	48 c1 e8 0c          	shr    $0xc,%rax
  802a65:	48 89 c2             	mov    %rax,%rdx
  802a68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a6f:	01 00 00 
  802a72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a76:	25 07 0e 00 00       	and    $0xe07,%eax
  802a7b:	89 c1                	mov    %eax,%ecx
  802a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a85:	41 89 c8             	mov    %ecx,%r8d
  802a88:	48 89 d1             	mov    %rdx,%rcx
  802a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a90:	48 89 c6             	mov    %rax,%rsi
  802a93:	bf 00 00 00 00       	mov    $0x0,%edi
  802a98:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
  802aa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aab:	79 02                	jns    802aaf <dup+0x16f>
		goto err;
  802aad:	eb 05                	jmp    802ab4 <dup+0x174>

	return newfdnum;
  802aaf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ab2:	eb 33                	jmp    802ae7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab8:	48 89 c6             	mov    %rax,%rsi
  802abb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac0:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802acc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad0:	48 89 c6             	mov    %rax,%rsi
  802ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad8:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax
	return r;
  802ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ae7:	c9                   	leaveq 
  802ae8:	c3                   	retq   

0000000000802ae9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ae9:	55                   	push   %rbp
  802aea:	48 89 e5             	mov    %rsp,%rbp
  802aed:	48 83 ec 40          	sub    $0x40,%rsp
  802af1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802af4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802af8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802afc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b00:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b03:	48 89 d6             	mov    %rdx,%rsi
  802b06:	89 c7                	mov    %eax,%edi
  802b08:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	callq  *%rax
  802b14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1b:	78 24                	js     802b41 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b21:	8b 00                	mov    (%rax),%eax
  802b23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b27:	48 89 d6             	mov    %rdx,%rsi
  802b2a:	89 c7                	mov    %eax,%edi
  802b2c:	48 b8 10 28 80 00 00 	movabs $0x802810,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3f:	79 05                	jns    802b46 <read+0x5d>
		return r;
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b44:	eb 76                	jmp    802bbc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4a:	8b 40 08             	mov    0x8(%rax),%eax
  802b4d:	83 e0 03             	and    $0x3,%eax
  802b50:	83 f8 01             	cmp    $0x1,%eax
  802b53:	75 3a                	jne    802b8f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b55:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802b5c:	00 00 00 
  802b5f:	48 8b 00             	mov    (%rax),%rax
  802b62:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b68:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b6b:	89 c6                	mov    %eax,%esi
  802b6d:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  802b74:	00 00 00 
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7c:	48 b9 23 0d 80 00 00 	movabs $0x800d23,%rcx
  802b83:	00 00 00 
  802b86:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b8d:	eb 2d                	jmp    802bbc <read+0xd3>
	}
	if (!dev->dev_read)
  802b8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b93:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b97:	48 85 c0             	test   %rax,%rax
  802b9a:	75 07                	jne    802ba3 <read+0xba>
		return -E_NOT_SUPP;
  802b9c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ba1:	eb 19                	jmp    802bbc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba7:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802baf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bb3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bb7:	48 89 cf             	mov    %rcx,%rdi
  802bba:	ff d0                	callq  *%rax
}
  802bbc:	c9                   	leaveq 
  802bbd:	c3                   	retq   

0000000000802bbe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bbe:	55                   	push   %rbp
  802bbf:	48 89 e5             	mov    %rsp,%rbp
  802bc2:	48 83 ec 30          	sub    $0x30,%rsp
  802bc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bc9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bcd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bd8:	eb 49                	jmp    802c23 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdd:	48 98                	cltq   
  802bdf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802be3:	48 29 c2             	sub    %rax,%rdx
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	48 63 c8             	movslq %eax,%rcx
  802bec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf0:	48 01 c1             	add    %rax,%rcx
  802bf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf6:	48 89 ce             	mov    %rcx,%rsi
  802bf9:	89 c7                	mov    %eax,%edi
  802bfb:	48 b8 e9 2a 80 00 00 	movabs $0x802ae9,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
  802c07:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c0e:	79 05                	jns    802c15 <readn+0x57>
			return m;
  802c10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c13:	eb 1c                	jmp    802c31 <readn+0x73>
		if (m == 0)
  802c15:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c19:	75 02                	jne    802c1d <readn+0x5f>
			break;
  802c1b:	eb 11                	jmp    802c2e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c20:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c26:	48 98                	cltq   
  802c28:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c2c:	72 ac                	jb     802bda <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c31:	c9                   	leaveq 
  802c32:	c3                   	retq   

0000000000802c33 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c33:	55                   	push   %rbp
  802c34:	48 89 e5             	mov    %rsp,%rbp
  802c37:	48 83 ec 40          	sub    $0x40,%rsp
  802c3b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c3e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c42:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c46:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c4a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c4d:	48 89 d6             	mov    %rdx,%rsi
  802c50:	89 c7                	mov    %eax,%edi
  802c52:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802c59:	00 00 00 
  802c5c:	ff d0                	callq  *%rax
  802c5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c65:	78 24                	js     802c8b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6b:	8b 00                	mov    (%rax),%eax
  802c6d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c71:	48 89 d6             	mov    %rdx,%rsi
  802c74:	89 c7                	mov    %eax,%edi
  802c76:	48 b8 10 28 80 00 00 	movabs $0x802810,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c89:	79 05                	jns    802c90 <write+0x5d>
		return r;
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	eb 75                	jmp    802d05 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c94:	8b 40 08             	mov    0x8(%rax),%eax
  802c97:	83 e0 03             	and    $0x3,%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	75 3a                	jne    802cd8 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c9e:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802ca5:	00 00 00 
  802ca8:	48 8b 00             	mov    (%rax),%rax
  802cab:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cb4:	89 c6                	mov    %eax,%esi
  802cb6:	48 bf 2b 48 80 00 00 	movabs $0x80482b,%rdi
  802cbd:	00 00 00 
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	48 b9 23 0d 80 00 00 	movabs $0x800d23,%rcx
  802ccc:	00 00 00 
  802ccf:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cd1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cd6:	eb 2d                	jmp    802d05 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cdc:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ce0:	48 85 c0             	test   %rax,%rax
  802ce3:	75 07                	jne    802cec <write+0xb9>
		return -E_NOT_SUPP;
  802ce5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cea:	eb 19                	jmp    802d05 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf0:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cf4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cf8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cfc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d00:	48 89 cf             	mov    %rcx,%rdi
  802d03:	ff d0                	callq  *%rax
}
  802d05:	c9                   	leaveq 
  802d06:	c3                   	retq   

0000000000802d07 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d07:	55                   	push   %rbp
  802d08:	48 89 e5             	mov    %rsp,%rbp
  802d0b:	48 83 ec 18          	sub    $0x18,%rsp
  802d0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d12:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d1c:	48 89 d6             	mov    %rdx,%rsi
  802d1f:	89 c7                	mov    %eax,%edi
  802d21:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
  802d2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d34:	79 05                	jns    802d3b <seek+0x34>
		return r;
  802d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d39:	eb 0f                	jmp    802d4a <seek+0x43>
	fd->fd_offset = offset;
  802d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4a:	c9                   	leaveq 
  802d4b:	c3                   	retq   

0000000000802d4c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d4c:	55                   	push   %rbp
  802d4d:	48 89 e5             	mov    %rsp,%rbp
  802d50:	48 83 ec 30          	sub    $0x30,%rsp
  802d54:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d57:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d5a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d61:	48 89 d6             	mov    %rdx,%rsi
  802d64:	89 c7                	mov    %eax,%edi
  802d66:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
  802d72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d79:	78 24                	js     802d9f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7f:	8b 00                	mov    (%rax),%eax
  802d81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d85:	48 89 d6             	mov    %rdx,%rsi
  802d88:	89 c7                	mov    %eax,%edi
  802d8a:	48 b8 10 28 80 00 00 	movabs $0x802810,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
  802d96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9d:	79 05                	jns    802da4 <ftruncate+0x58>
		return r;
  802d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da2:	eb 72                	jmp    802e16 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da8:	8b 40 08             	mov    0x8(%rax),%eax
  802dab:	83 e0 03             	and    $0x3,%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	75 3a                	jne    802dec <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802db2:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802db9:	00 00 00 
  802dbc:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dbf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dc5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dc8:	89 c6                	mov    %eax,%esi
  802dca:	48 bf 48 48 80 00 00 	movabs $0x804848,%rdi
  802dd1:	00 00 00 
  802dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd9:	48 b9 23 0d 80 00 00 	movabs $0x800d23,%rcx
  802de0:	00 00 00 
  802de3:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802de5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dea:	eb 2a                	jmp    802e16 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df0:	48 8b 40 30          	mov    0x30(%rax),%rax
  802df4:	48 85 c0             	test   %rax,%rax
  802df7:	75 07                	jne    802e00 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802df9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dfe:	eb 16                	jmp    802e16 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e04:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e0c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e0f:	89 ce                	mov    %ecx,%esi
  802e11:	48 89 d7             	mov    %rdx,%rdi
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 30          	sub    $0x30,%rsp
  802e20:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e27:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e2b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e2e:	48 89 d6             	mov    %rdx,%rsi
  802e31:	89 c7                	mov    %eax,%edi
  802e33:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  802e3a:	00 00 00 
  802e3d:	ff d0                	callq  *%rax
  802e3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e46:	78 24                	js     802e6c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4c:	8b 00                	mov    (%rax),%eax
  802e4e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e52:	48 89 d6             	mov    %rdx,%rsi
  802e55:	89 c7                	mov    %eax,%edi
  802e57:	48 b8 10 28 80 00 00 	movabs $0x802810,%rax
  802e5e:	00 00 00 
  802e61:	ff d0                	callq  *%rax
  802e63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6a:	79 05                	jns    802e71 <fstat+0x59>
		return r;
  802e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6f:	eb 5e                	jmp    802ecf <fstat+0xb7>
	if (!dev->dev_stat)
  802e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e75:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e79:	48 85 c0             	test   %rax,%rax
  802e7c:	75 07                	jne    802e85 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e7e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e83:	eb 4a                	jmp    802ecf <fstat+0xb7>
	stat->st_name[0] = 0;
  802e85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e89:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e90:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e97:	00 00 00 
	stat->st_isdir = 0;
  802e9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e9e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ea5:	00 00 00 
	stat->st_dev = dev;
  802ea8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebb:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ebf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ec3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ec7:	48 89 ce             	mov    %rcx,%rsi
  802eca:	48 89 d7             	mov    %rdx,%rdi
  802ecd:	ff d0                	callq  *%rax
}
  802ecf:	c9                   	leaveq 
  802ed0:	c3                   	retq   

0000000000802ed1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ed1:	55                   	push   %rbp
  802ed2:	48 89 e5             	mov    %rsp,%rbp
  802ed5:	48 83 ec 20          	sub    $0x20,%rsp
  802ed9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802edd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee5:	be 00 00 00 00       	mov    $0x0,%esi
  802eea:	48 89 c7             	mov    %rax,%rdi
  802eed:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
  802ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f00:	79 05                	jns    802f07 <stat+0x36>
		return fd;
  802f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f05:	eb 2f                	jmp    802f36 <stat+0x65>
	r = fstat(fd, stat);
  802f07:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0e:	48 89 d6             	mov    %rdx,%rsi
  802f11:	89 c7                	mov    %eax,%edi
  802f13:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  802f1a:	00 00 00 
  802f1d:	ff d0                	callq  *%rax
  802f1f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f25:	89 c7                	mov    %eax,%edi
  802f27:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
	return r;
  802f33:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f36:	c9                   	leaveq 
  802f37:	c3                   	retq   

0000000000802f38 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f38:	55                   	push   %rbp
  802f39:	48 89 e5             	mov    %rsp,%rbp
  802f3c:	48 83 ec 10          	sub    $0x10,%rsp
  802f40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f47:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  802f4e:	00 00 00 
  802f51:	8b 00                	mov    (%rax),%eax
  802f53:	85 c0                	test   %eax,%eax
  802f55:	75 1d                	jne    802f74 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f57:	bf 01 00 00 00       	mov    $0x1,%edi
  802f5c:	48 b8 ef 3f 80 00 00 	movabs $0x803fef,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
  802f68:	48 ba d0 71 80 00 00 	movabs $0x8071d0,%rdx
  802f6f:	00 00 00 
  802f72:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f74:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  802f7b:	00 00 00 
  802f7e:	8b 00                	mov    (%rax),%eax
  802f80:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f83:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f88:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f8f:	00 00 00 
  802f92:	89 c7                	mov    %eax,%edi
  802f94:	48 b8 57 3f 80 00 00 	movabs $0x803f57,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa4:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa9:	48 89 c6             	mov    %rax,%rsi
  802fac:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb1:	48 b8 96 3e 80 00 00 	movabs $0x803e96,%rax
  802fb8:	00 00 00 
  802fbb:	ff d0                	callq  *%rax
}
  802fbd:	c9                   	leaveq 
  802fbe:	c3                   	retq   

0000000000802fbf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fbf:	55                   	push   %rbp
  802fc0:	48 89 e5             	mov    %rsp,%rbp
  802fc3:	48 83 ec 20          	sub    $0x20,%rsp
  802fc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fcb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd2:	48 89 c7             	mov    %rax,%rdi
  802fd5:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  802fdc:	00 00 00 
  802fdf:	ff d0                	callq  *%rax
  802fe1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fe6:	7e 0a                	jle    802ff2 <open+0x33>
		return -E_BAD_PATH;
  802fe8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fed:	e9 a5 00 00 00       	jmpq   803097 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ff2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ff6:	48 89 c7             	mov    %rax,%rdi
  802ff9:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803000:	00 00 00 
  803003:	ff d0                	callq  *%rax
  803005:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803008:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300c:	79 08                	jns    803016 <open+0x57>
		return r;
  80300e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803011:	e9 81 00 00 00       	jmpq   803097 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301a:	48 89 c6             	mov    %rax,%rsi
  80301d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803024:	00 00 00 
  803027:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803033:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80303a:	00 00 00 
  80303d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803040:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803046:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304a:	48 89 c6             	mov    %rax,%rsi
  80304d:	bf 01 00 00 00       	mov    $0x1,%edi
  803052:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax
  80305e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803061:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803065:	79 1d                	jns    803084 <open+0xc5>
		fd_close(fd, 0);
  803067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306b:	be 00 00 00 00       	mov    $0x0,%esi
  803070:	48 89 c7             	mov    %rax,%rdi
  803073:	48 b8 47 27 80 00 00 	movabs $0x802747,%rax
  80307a:	00 00 00 
  80307d:	ff d0                	callq  *%rax
		return r;
  80307f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803082:	eb 13                	jmp    803097 <open+0xd8>
	}

	return fd2num(fd);
  803084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803088:	48 89 c7             	mov    %rax,%rdi
  80308b:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  803092:	00 00 00 
  803095:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  803097:	c9                   	leaveq 
  803098:	c3                   	retq   

0000000000803099 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803099:	55                   	push   %rbp
  80309a:	48 89 e5             	mov    %rsp,%rbp
  80309d:	48 83 ec 10          	sub    $0x10,%rsp
  8030a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b3:	00 00 00 
  8030b6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030b8:	be 00 00 00 00       	mov    $0x0,%esi
  8030bd:	bf 06 00 00 00       	mov    $0x6,%edi
  8030c2:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
}
  8030ce:	c9                   	leaveq 
  8030cf:	c3                   	retq   

00000000008030d0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030d0:	55                   	push   %rbp
  8030d1:	48 89 e5             	mov    %rsp,%rbp
  8030d4:	48 83 ec 30          	sub    $0x30,%rsp
  8030d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8030eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f2:	00 00 00 
  8030f5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030f7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030fe:	00 00 00 
  803101:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803105:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803109:	be 00 00 00 00       	mov    $0x0,%esi
  80310e:	bf 03 00 00 00       	mov    $0x3,%edi
  803113:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  80311a:	00 00 00 
  80311d:	ff d0                	callq  *%rax
  80311f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803122:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803126:	79 08                	jns    803130 <devfile_read+0x60>
		return r;
  803128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312b:	e9 a4 00 00 00       	jmpq   8031d4 <devfile_read+0x104>
	assert(r <= n);
  803130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803133:	48 98                	cltq   
  803135:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803139:	76 35                	jbe    803170 <devfile_read+0xa0>
  80313b:	48 b9 75 48 80 00 00 	movabs $0x804875,%rcx
  803142:	00 00 00 
  803145:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  80314c:	00 00 00 
  80314f:	be 84 00 00 00       	mov    $0x84,%esi
  803154:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  80315b:	00 00 00 
  80315e:	b8 00 00 00 00       	mov    $0x0,%eax
  803163:	49 b8 ea 0a 80 00 00 	movabs $0x800aea,%r8
  80316a:	00 00 00 
  80316d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803170:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803177:	7e 35                	jle    8031ae <devfile_read+0xde>
  803179:	48 b9 9c 48 80 00 00 	movabs $0x80489c,%rcx
  803180:	00 00 00 
  803183:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  80318a:	00 00 00 
  80318d:	be 85 00 00 00       	mov    $0x85,%esi
  803192:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  803199:	00 00 00 
  80319c:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a1:	49 b8 ea 0a 80 00 00 	movabs $0x800aea,%r8
  8031a8:	00 00 00 
  8031ab:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8031ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b1:	48 63 d0             	movslq %eax,%rdx
  8031b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031b8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031bf:	00 00 00 
  8031c2:	48 89 c7             	mov    %rax,%rdi
  8031c5:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  8031cc:	00 00 00 
  8031cf:	ff d0                	callq  *%rax
	return r;
  8031d1:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8031d4:	c9                   	leaveq 
  8031d5:	c3                   	retq   

00000000008031d6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031d6:	55                   	push   %rbp
  8031d7:	48 89 e5             	mov    %rsp,%rbp
  8031da:	48 83 ec 30          	sub    $0x30,%rsp
  8031de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f8:	00 00 00 
  8031fb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8031fd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803204:	00 00 00 
  803207:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80320f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803216:	00 
  803217:	76 35                	jbe    80324e <devfile_write+0x78>
  803219:	48 b9 a8 48 80 00 00 	movabs $0x8048a8,%rcx
  803220:	00 00 00 
  803223:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  80322a:	00 00 00 
  80322d:	be 9e 00 00 00       	mov    $0x9e,%esi
  803232:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  803239:	00 00 00 
  80323c:	b8 00 00 00 00       	mov    $0x0,%eax
  803241:	49 b8 ea 0a 80 00 00 	movabs $0x800aea,%r8
  803248:	00 00 00 
  80324b:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80324e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803256:	48 89 c6             	mov    %rax,%rsi
  803259:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803260:	00 00 00 
  803263:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80326f:	be 00 00 00 00       	mov    $0x0,%esi
  803274:	bf 04 00 00 00       	mov    $0x4,%edi
  803279:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
  803285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80328c:	79 05                	jns    803293 <devfile_write+0xbd>
		return r;
  80328e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803291:	eb 43                	jmp    8032d6 <devfile_write+0x100>
	assert(r <= n);
  803293:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803296:	48 98                	cltq   
  803298:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80329c:	76 35                	jbe    8032d3 <devfile_write+0xfd>
  80329e:	48 b9 75 48 80 00 00 	movabs $0x804875,%rcx
  8032a5:	00 00 00 
  8032a8:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  8032af:	00 00 00 
  8032b2:	be a2 00 00 00       	mov    $0xa2,%esi
  8032b7:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  8032be:	00 00 00 
  8032c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c6:	49 b8 ea 0a 80 00 00 	movabs $0x800aea,%r8
  8032cd:	00 00 00 
  8032d0:	41 ff d0             	callq  *%r8
	return r;
  8032d3:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8032d6:	c9                   	leaveq 
  8032d7:	c3                   	retq   

00000000008032d8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032d8:	55                   	push   %rbp
  8032d9:	48 89 e5             	mov    %rsp,%rbp
  8032dc:	48 83 ec 20          	sub    $0x20,%rsp
  8032e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8032ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f6:	00 00 00 
  8032f9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032fb:	be 00 00 00 00       	mov    $0x0,%esi
  803300:	bf 05 00 00 00       	mov    $0x5,%edi
  803305:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
  803311:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803314:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803318:	79 05                	jns    80331f <devfile_stat+0x47>
		return r;
  80331a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331d:	eb 56                	jmp    803375 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80331f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803323:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80332a:	00 00 00 
  80332d:	48 89 c7             	mov    %rax,%rdi
  803330:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80333c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803343:	00 00 00 
  803346:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80334c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803350:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803356:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80335d:	00 00 00 
  803360:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803366:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80336a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803370:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803375:	c9                   	leaveq 
  803376:	c3                   	retq   

0000000000803377 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803377:	55                   	push   %rbp
  803378:	48 89 e5             	mov    %rsp,%rbp
  80337b:	48 83 ec 10          	sub    $0x10,%rsp
  80337f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803383:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80338a:	8b 50 0c             	mov    0xc(%rax),%edx
  80338d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803394:	00 00 00 
  803397:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803399:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033a0:	00 00 00 
  8033a3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033a6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033a9:	be 00 00 00 00       	mov    $0x0,%esi
  8033ae:	bf 02 00 00 00       	mov    $0x2,%edi
  8033b3:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  8033ba:	00 00 00 
  8033bd:	ff d0                	callq  *%rax
}
  8033bf:	c9                   	leaveq 
  8033c0:	c3                   	retq   

00000000008033c1 <remove>:

// Delete a file
int
remove(const char *path)
{
  8033c1:	55                   	push   %rbp
  8033c2:	48 89 e5             	mov    %rsp,%rbp
  8033c5:	48 83 ec 10          	sub    $0x10,%rsp
  8033c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033d1:	48 89 c7             	mov    %rax,%rdi
  8033d4:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
  8033e0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033e5:	7e 07                	jle    8033ee <remove+0x2d>
		return -E_BAD_PATH;
  8033e7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033ec:	eb 33                	jmp    803421 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f2:	48 89 c6             	mov    %rax,%rsi
  8033f5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8033fc:	00 00 00 
  8033ff:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80340b:	be 00 00 00 00       	mov    $0x0,%esi
  803410:	bf 07 00 00 00       	mov    $0x7,%edi
  803415:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
}
  803421:	c9                   	leaveq 
  803422:	c3                   	retq   

0000000000803423 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803423:	55                   	push   %rbp
  803424:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803427:	be 00 00 00 00       	mov    $0x0,%esi
  80342c:	bf 08 00 00 00       	mov    $0x8,%edi
  803431:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
}
  80343d:	5d                   	pop    %rbp
  80343e:	c3                   	retq   

000000000080343f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80343f:	55                   	push   %rbp
  803440:	48 89 e5             	mov    %rsp,%rbp
  803443:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80344a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803451:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803458:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80345f:	be 00 00 00 00       	mov    $0x0,%esi
  803464:	48 89 c7             	mov    %rax,%rdi
  803467:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
  803473:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803476:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347a:	79 28                	jns    8034a4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80347c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347f:	89 c6                	mov    %eax,%esi
  803481:	48 bf d5 48 80 00 00 	movabs $0x8048d5,%rdi
  803488:	00 00 00 
  80348b:	b8 00 00 00 00       	mov    $0x0,%eax
  803490:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  803497:	00 00 00 
  80349a:	ff d2                	callq  *%rdx
		return fd_src;
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	e9 74 01 00 00       	jmpq   803618 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8034a4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8034ab:	be 01 01 00 00       	mov    $0x101,%esi
  8034b0:	48 89 c7             	mov    %rax,%rdi
  8034b3:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8034c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034c6:	79 39                	jns    803501 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8034c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034cb:	89 c6                	mov    %eax,%esi
  8034cd:	48 bf eb 48 80 00 00 	movabs $0x8048eb,%rdi
  8034d4:	00 00 00 
  8034d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dc:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  8034e3:	00 00 00 
  8034e6:	ff d2                	callq  *%rdx
		close(fd_src);
  8034e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034eb:	89 c7                	mov    %eax,%edi
  8034ed:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  8034f4:	00 00 00 
  8034f7:	ff d0                	callq  *%rax
		return fd_dest;
  8034f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034fc:	e9 17 01 00 00       	jmpq   803618 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803501:	eb 74                	jmp    803577 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803503:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803506:	48 63 d0             	movslq %eax,%rdx
  803509:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803510:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803513:	48 89 ce             	mov    %rcx,%rsi
  803516:	89 c7                	mov    %eax,%edi
  803518:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
  803524:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803527:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80352b:	79 4a                	jns    803577 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80352d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803530:	89 c6                	mov    %eax,%esi
  803532:	48 bf 05 49 80 00 00 	movabs $0x804905,%rdi
  803539:	00 00 00 
  80353c:	b8 00 00 00 00       	mov    $0x0,%eax
  803541:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  803548:	00 00 00 
  80354b:	ff d2                	callq  *%rdx
			close(fd_src);
  80354d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803550:	89 c7                	mov    %eax,%edi
  803552:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
			close(fd_dest);
  80355e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803561:	89 c7                	mov    %eax,%edi
  803563:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
			return write_size;
  80356f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803572:	e9 a1 00 00 00       	jmpq   803618 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803577:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80357e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803581:	ba 00 02 00 00       	mov    $0x200,%edx
  803586:	48 89 ce             	mov    %rcx,%rsi
  803589:	89 c7                	mov    %eax,%edi
  80358b:	48 b8 e9 2a 80 00 00 	movabs $0x802ae9,%rax
  803592:	00 00 00 
  803595:	ff d0                	callq  *%rax
  803597:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80359a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80359e:	0f 8f 5f ff ff ff    	jg     803503 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8035a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035a8:	79 47                	jns    8035f1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8035aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035ad:	89 c6                	mov    %eax,%esi
  8035af:	48 bf 18 49 80 00 00 	movabs $0x804918,%rdi
  8035b6:	00 00 00 
  8035b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035be:	48 ba 23 0d 80 00 00 	movabs $0x800d23,%rdx
  8035c5:	00 00 00 
  8035c8:	ff d2                	callq  *%rdx
		close(fd_src);
  8035ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cd:	89 c7                	mov    %eax,%edi
  8035cf:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
		close(fd_dest);
  8035db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035de:	89 c7                	mov    %eax,%edi
  8035e0:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
		return read_size;
  8035ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035ef:	eb 27                	jmp    803618 <copy+0x1d9>
	}
	close(fd_src);
  8035f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f4:	89 c7                	mov    %eax,%edi
  8035f6:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
	close(fd_dest);
  803602:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803605:	89 c7                	mov    %eax,%edi
  803607:	48 b8 c7 28 80 00 00 	movabs $0x8028c7,%rax
  80360e:	00 00 00 
  803611:	ff d0                	callq  *%rax
	return 0;
  803613:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803618:	c9                   	leaveq 
  803619:	c3                   	retq   

000000000080361a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80361a:	55                   	push   %rbp
  80361b:	48 89 e5             	mov    %rsp,%rbp
  80361e:	53                   	push   %rbx
  80361f:	48 83 ec 38          	sub    $0x38,%rsp
  803623:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803627:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80362b:	48 89 c7             	mov    %rax,%rdi
  80362e:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803635:	00 00 00 
  803638:	ff d0                	callq  *%rax
  80363a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803641:	0f 88 bf 01 00 00    	js     803806 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364b:	ba 07 04 00 00       	mov    $0x407,%edx
  803650:	48 89 c6             	mov    %rax,%rsi
  803653:	bf 00 00 00 00       	mov    $0x0,%edi
  803658:	48 b8 1a 22 80 00 00 	movabs $0x80221a,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
  803664:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803667:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80366b:	0f 88 95 01 00 00    	js     803806 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803671:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803687:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80368b:	0f 88 5d 01 00 00    	js     8037ee <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803691:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803695:	ba 07 04 00 00       	mov    $0x407,%edx
  80369a:	48 89 c6             	mov    %rax,%rsi
  80369d:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a2:	48 b8 1a 22 80 00 00 	movabs $0x80221a,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
  8036ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b5:	0f 88 33 01 00 00    	js     8037ee <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bf:	48 89 c7             	mov    %rax,%rdi
  8036c2:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
  8036ce:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036db:	48 89 c6             	mov    %rax,%rsi
  8036de:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e3:	48 b8 1a 22 80 00 00 	movabs $0x80221a,%rax
  8036ea:	00 00 00 
  8036ed:	ff d0                	callq  *%rax
  8036ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036f6:	79 05                	jns    8036fd <pipe+0xe3>
		goto err2;
  8036f8:	e9 d9 00 00 00       	jmpq   8037d6 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803701:	48 89 c7             	mov    %rax,%rdi
  803704:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	48 89 c2             	mov    %rax,%rdx
  803713:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803717:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80371d:	48 89 d1             	mov    %rdx,%rcx
  803720:	ba 00 00 00 00       	mov    $0x0,%edx
  803725:	48 89 c6             	mov    %rax,%rsi
  803728:	bf 00 00 00 00       	mov    $0x0,%edi
  80372d:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  803734:	00 00 00 
  803737:	ff d0                	callq  *%rax
  803739:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80373c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803740:	79 1b                	jns    80375d <pipe+0x143>
		goto err3;
  803742:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803743:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803747:	48 89 c6             	mov    %rax,%rsi
  80374a:	bf 00 00 00 00       	mov    $0x0,%edi
  80374f:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  803756:	00 00 00 
  803759:	ff d0                	callq  *%rax
  80375b:	eb 79                	jmp    8037d6 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80375d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803761:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803768:	00 00 00 
  80376b:	8b 12                	mov    (%rdx),%edx
  80376d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80376f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803773:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80377a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80377e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803785:	00 00 00 
  803788:	8b 12                	mov    (%rdx),%edx
  80378a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80378c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803790:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379b:	48 89 c7             	mov    %rax,%rdi
  80379e:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
  8037aa:	89 c2                	mov    %eax,%edx
  8037ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037b0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8037b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037b6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8037ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037be:	48 89 c7             	mov    %rax,%rdi
  8037c1:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  8037c8:	00 00 00 
  8037cb:	ff d0                	callq  *%rax
  8037cd:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d4:	eb 33                	jmp    803809 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037da:	48 89 c6             	mov    %rax,%rsi
  8037dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e2:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  8037e9:	00 00 00 
  8037ec:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f2:	48 89 c6             	mov    %rax,%rsi
  8037f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037fa:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
err:
	return r;
  803806:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803809:	48 83 c4 38          	add    $0x38,%rsp
  80380d:	5b                   	pop    %rbx
  80380e:	5d                   	pop    %rbp
  80380f:	c3                   	retq   

0000000000803810 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803810:	55                   	push   %rbp
  803811:	48 89 e5             	mov    %rsp,%rbp
  803814:	53                   	push   %rbx
  803815:	48 83 ec 28          	sub    $0x28,%rsp
  803819:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80381d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803821:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803828:	00 00 00 
  80382b:	48 8b 00             	mov    (%rax),%rax
  80382e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803834:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383b:	48 89 c7             	mov    %rax,%rdi
  80383e:	48 b8 71 40 80 00 00 	movabs $0x804071,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
  80384a:	89 c3                	mov    %eax,%ebx
  80384c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803850:	48 89 c7             	mov    %rax,%rdi
  803853:	48 b8 71 40 80 00 00 	movabs $0x804071,%rax
  80385a:	00 00 00 
  80385d:	ff d0                	callq  *%rax
  80385f:	39 c3                	cmp    %eax,%ebx
  803861:	0f 94 c0             	sete   %al
  803864:	0f b6 c0             	movzbl %al,%eax
  803867:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80386a:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803871:	00 00 00 
  803874:	48 8b 00             	mov    (%rax),%rax
  803877:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80387d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803880:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803883:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803886:	75 05                	jne    80388d <_pipeisclosed+0x7d>
			return ret;
  803888:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80388b:	eb 4f                	jmp    8038dc <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80388d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803890:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803893:	74 42                	je     8038d7 <_pipeisclosed+0xc7>
  803895:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803899:	75 3c                	jne    8038d7 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80389b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  8038a2:	00 00 00 
  8038a5:	48 8b 00             	mov    (%rax),%rax
  8038a8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038ae:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038b4:	89 c6                	mov    %eax,%esi
  8038b6:	48 bf 33 49 80 00 00 	movabs $0x804933,%rdi
  8038bd:	00 00 00 
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c5:	49 b8 23 0d 80 00 00 	movabs $0x800d23,%r8
  8038cc:	00 00 00 
  8038cf:	41 ff d0             	callq  *%r8
	}
  8038d2:	e9 4a ff ff ff       	jmpq   803821 <_pipeisclosed+0x11>
  8038d7:	e9 45 ff ff ff       	jmpq   803821 <_pipeisclosed+0x11>
}
  8038dc:	48 83 c4 28          	add    $0x28,%rsp
  8038e0:	5b                   	pop    %rbx
  8038e1:	5d                   	pop    %rbp
  8038e2:	c3                   	retq   

00000000008038e3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038e3:	55                   	push   %rbp
  8038e4:	48 89 e5             	mov    %rsp,%rbp
  8038e7:	48 83 ec 30          	sub    $0x30,%rsp
  8038eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038f5:	48 89 d6             	mov    %rdx,%rsi
  8038f8:	89 c7                	mov    %eax,%edi
  8038fa:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803901:	00 00 00 
  803904:	ff d0                	callq  *%rax
  803906:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80390d:	79 05                	jns    803914 <pipeisclosed+0x31>
		return r;
  80390f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803912:	eb 31                	jmp    803945 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803918:	48 89 c7             	mov    %rax,%rdi
  80391b:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803922:	00 00 00 
  803925:	ff d0                	callq  *%rax
  803927:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80392b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803933:	48 89 d6             	mov    %rdx,%rsi
  803936:	48 89 c7             	mov    %rax,%rdi
  803939:	48 b8 10 38 80 00 00 	movabs $0x803810,%rax
  803940:	00 00 00 
  803943:	ff d0                	callq  *%rax
}
  803945:	c9                   	leaveq 
  803946:	c3                   	retq   

0000000000803947 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803947:	55                   	push   %rbp
  803948:	48 89 e5             	mov    %rsp,%rbp
  80394b:	48 83 ec 40          	sub    $0x40,%rsp
  80394f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803953:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803957:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80395b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80395f:	48 89 c7             	mov    %rax,%rdi
  803962:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
  80396e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803972:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803976:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80397a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803981:	00 
  803982:	e9 92 00 00 00       	jmpq   803a19 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803987:	eb 41                	jmp    8039ca <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803989:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80398e:	74 09                	je     803999 <devpipe_read+0x52>
				return i;
  803990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803994:	e9 92 00 00 00       	jmpq   803a2b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803999:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80399d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a1:	48 89 d6             	mov    %rdx,%rsi
  8039a4:	48 89 c7             	mov    %rax,%rdi
  8039a7:	48 b8 10 38 80 00 00 	movabs $0x803810,%rax
  8039ae:	00 00 00 
  8039b1:	ff d0                	callq  *%rax
  8039b3:	85 c0                	test   %eax,%eax
  8039b5:	74 07                	je     8039be <devpipe_read+0x77>
				return 0;
  8039b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bc:	eb 6d                	jmp    803a2b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039be:	48 b8 dc 21 80 00 00 	movabs $0x8021dc,%rax
  8039c5:	00 00 00 
  8039c8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ce:	8b 10                	mov    (%rax),%edx
  8039d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d4:	8b 40 04             	mov    0x4(%rax),%eax
  8039d7:	39 c2                	cmp    %eax,%edx
  8039d9:	74 ae                	je     803989 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039e3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039eb:	8b 00                	mov    (%rax),%eax
  8039ed:	99                   	cltd   
  8039ee:	c1 ea 1b             	shr    $0x1b,%edx
  8039f1:	01 d0                	add    %edx,%eax
  8039f3:	83 e0 1f             	and    $0x1f,%eax
  8039f6:	29 d0                	sub    %edx,%eax
  8039f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039fc:	48 98                	cltq   
  8039fe:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a03:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a09:	8b 00                	mov    (%rax),%eax
  803a0b:	8d 50 01             	lea    0x1(%rax),%edx
  803a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a12:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a14:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a21:	0f 82 60 ff ff ff    	jb     803987 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a2b:	c9                   	leaveq 
  803a2c:	c3                   	retq   

0000000000803a2d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 40          	sub    $0x40,%rsp
  803a35:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a39:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a3d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a45:	48 89 c7             	mov    %rax,%rdi
  803a48:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803a4f:	00 00 00 
  803a52:	ff d0                	callq  *%rax
  803a54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a60:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a67:	00 
  803a68:	e9 8e 00 00 00       	jmpq   803afb <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a6d:	eb 31                	jmp    803aa0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a77:	48 89 d6             	mov    %rdx,%rsi
  803a7a:	48 89 c7             	mov    %rax,%rdi
  803a7d:	48 b8 10 38 80 00 00 	movabs $0x803810,%rax
  803a84:	00 00 00 
  803a87:	ff d0                	callq  *%rax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 07                	je     803a94 <devpipe_write+0x67>
				return 0;
  803a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a92:	eb 79                	jmp    803b0d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a94:	48 b8 dc 21 80 00 00 	movabs $0x8021dc,%rax
  803a9b:	00 00 00 
  803a9e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa4:	8b 40 04             	mov    0x4(%rax),%eax
  803aa7:	48 63 d0             	movslq %eax,%rdx
  803aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aae:	8b 00                	mov    (%rax),%eax
  803ab0:	48 98                	cltq   
  803ab2:	48 83 c0 20          	add    $0x20,%rax
  803ab6:	48 39 c2             	cmp    %rax,%rdx
  803ab9:	73 b4                	jae    803a6f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803abb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abf:	8b 40 04             	mov    0x4(%rax),%eax
  803ac2:	99                   	cltd   
  803ac3:	c1 ea 1b             	shr    $0x1b,%edx
  803ac6:	01 d0                	add    %edx,%eax
  803ac8:	83 e0 1f             	and    $0x1f,%eax
  803acb:	29 d0                	sub    %edx,%eax
  803acd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ad1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ad5:	48 01 ca             	add    %rcx,%rdx
  803ad8:	0f b6 0a             	movzbl (%rdx),%ecx
  803adb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803adf:	48 98                	cltq   
  803ae1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ae5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae9:	8b 40 04             	mov    0x4(%rax),%eax
  803aec:	8d 50 01             	lea    0x1(%rax),%edx
  803aef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803af6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803afb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b03:	0f 82 64 ff ff ff    	jb     803a6d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b0d:	c9                   	leaveq 
  803b0e:	c3                   	retq   

0000000000803b0f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b0f:	55                   	push   %rbp
  803b10:	48 89 e5             	mov    %rsp,%rbp
  803b13:	48 83 ec 20          	sub    $0x20,%rsp
  803b17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b23:	48 89 c7             	mov    %rax,%rdi
  803b26:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803b2d:	00 00 00 
  803b30:	ff d0                	callq  *%rax
  803b32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b3a:	48 be 46 49 80 00 00 	movabs $0x804946,%rsi
  803b41:	00 00 00 
  803b44:	48 89 c7             	mov    %rax,%rdi
  803b47:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  803b4e:	00 00 00 
  803b51:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b57:	8b 50 04             	mov    0x4(%rax),%edx
  803b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b5e:	8b 00                	mov    (%rax),%eax
  803b60:	29 c2                	sub    %eax,%edx
  803b62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b66:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b70:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b77:	00 00 00 
	stat->st_dev = &devpipe;
  803b7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7e:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803b85:	00 00 00 
  803b88:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b94:	c9                   	leaveq 
  803b95:	c3                   	retq   

0000000000803b96 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b96:	55                   	push   %rbp
  803b97:	48 89 e5             	mov    %rsp,%rbp
  803b9a:	48 83 ec 10          	sub    $0x10,%rsp
  803b9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803ba2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba6:	48 89 c6             	mov    %rax,%rsi
  803ba9:	bf 00 00 00 00       	mov    $0x0,%edi
  803bae:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  803bb5:	00 00 00 
  803bb8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bbe:	48 89 c7             	mov    %rax,%rdi
  803bc1:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  803bc8:	00 00 00 
  803bcb:	ff d0                	callq  *%rax
  803bcd:	48 89 c6             	mov    %rax,%rsi
  803bd0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd5:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  803bdc:	00 00 00 
  803bdf:	ff d0                	callq  *%rax
}
  803be1:	c9                   	leaveq 
  803be2:	c3                   	retq   

0000000000803be3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803be3:	55                   	push   %rbp
  803be4:	48 89 e5             	mov    %rsp,%rbp
  803be7:	48 83 ec 20          	sub    $0x20,%rsp
  803beb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bf4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bf8:	be 01 00 00 00       	mov    $0x1,%esi
  803bfd:	48 89 c7             	mov    %rax,%rdi
  803c00:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  803c07:	00 00 00 
  803c0a:	ff d0                	callq  *%rax
}
  803c0c:	c9                   	leaveq 
  803c0d:	c3                   	retq   

0000000000803c0e <getchar>:

int
getchar(void)
{
  803c0e:	55                   	push   %rbp
  803c0f:	48 89 e5             	mov    %rsp,%rbp
  803c12:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c16:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c1a:	ba 01 00 00 00       	mov    $0x1,%edx
  803c1f:	48 89 c6             	mov    %rax,%rsi
  803c22:	bf 00 00 00 00       	mov    $0x0,%edi
  803c27:	48 b8 e9 2a 80 00 00 	movabs $0x802ae9,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax
  803c33:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c3a:	79 05                	jns    803c41 <getchar+0x33>
		return r;
  803c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3f:	eb 14                	jmp    803c55 <getchar+0x47>
	if (r < 1)
  803c41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c45:	7f 07                	jg     803c4e <getchar+0x40>
		return -E_EOF;
  803c47:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c4c:	eb 07                	jmp    803c55 <getchar+0x47>
	return c;
  803c4e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c52:	0f b6 c0             	movzbl %al,%eax
}
  803c55:	c9                   	leaveq 
  803c56:	c3                   	retq   

0000000000803c57 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c57:	55                   	push   %rbp
  803c58:	48 89 e5             	mov    %rsp,%rbp
  803c5b:	48 83 ec 20          	sub    $0x20,%rsp
  803c5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c69:	48 89 d6             	mov    %rdx,%rsi
  803c6c:	89 c7                	mov    %eax,%edi
  803c6e:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803c75:	00 00 00 
  803c78:	ff d0                	callq  *%rax
  803c7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c81:	79 05                	jns    803c88 <iscons+0x31>
		return r;
  803c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c86:	eb 1a                	jmp    803ca2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8c:	8b 10                	mov    (%rax),%edx
  803c8e:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803c95:	00 00 00 
  803c98:	8b 00                	mov    (%rax),%eax
  803c9a:	39 c2                	cmp    %eax,%edx
  803c9c:	0f 94 c0             	sete   %al
  803c9f:	0f b6 c0             	movzbl %al,%eax
}
  803ca2:	c9                   	leaveq 
  803ca3:	c3                   	retq   

0000000000803ca4 <opencons>:

int
opencons(void)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803cac:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cb0:	48 89 c7             	mov    %rax,%rdi
  803cb3:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  803cba:	00 00 00 
  803cbd:	ff d0                	callq  *%rax
  803cbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc6:	79 05                	jns    803ccd <opencons+0x29>
		return r;
  803cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccb:	eb 5b                	jmp    803d28 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd1:	ba 07 04 00 00       	mov    $0x407,%edx
  803cd6:	48 89 c6             	mov    %rax,%rsi
  803cd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cde:	48 b8 1a 22 80 00 00 	movabs $0x80221a,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
  803cea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ced:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf1:	79 05                	jns    803cf8 <opencons+0x54>
		return r;
  803cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf6:	eb 30                	jmp    803d28 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfc:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803d03:	00 00 00 
  803d06:	8b 12                	mov    (%rdx),%edx
  803d08:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d19:	48 89 c7             	mov    %rax,%rdi
  803d1c:	48 b8 d1 25 80 00 00 	movabs $0x8025d1,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
}
  803d28:	c9                   	leaveq 
  803d29:	c3                   	retq   

0000000000803d2a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	48 83 ec 30          	sub    $0x30,%rsp
  803d32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d36:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d3a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d3e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d43:	75 07                	jne    803d4c <devcons_read+0x22>
		return 0;
  803d45:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4a:	eb 4b                	jmp    803d97 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d4c:	eb 0c                	jmp    803d5a <devcons_read+0x30>
		sys_yield();
  803d4e:	48 b8 dc 21 80 00 00 	movabs $0x8021dc,%rax
  803d55:	00 00 00 
  803d58:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d5a:	48 b8 1c 21 80 00 00 	movabs $0x80211c,%rax
  803d61:	00 00 00 
  803d64:	ff d0                	callq  *%rax
  803d66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6d:	74 df                	je     803d4e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d73:	79 05                	jns    803d7a <devcons_read+0x50>
		return c;
  803d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d78:	eb 1d                	jmp    803d97 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d7e:	75 07                	jne    803d87 <devcons_read+0x5d>
		return 0;
  803d80:	b8 00 00 00 00       	mov    $0x0,%eax
  803d85:	eb 10                	jmp    803d97 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8a:	89 c2                	mov    %eax,%edx
  803d8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d90:	88 10                	mov    %dl,(%rax)
	return 1;
  803d92:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d97:	c9                   	leaveq 
  803d98:	c3                   	retq   

0000000000803d99 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d99:	55                   	push   %rbp
  803d9a:	48 89 e5             	mov    %rsp,%rbp
  803d9d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803da4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803dab:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803db2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dc0:	eb 76                	jmp    803e38 <devcons_write+0x9f>
		m = n - tot;
  803dc2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dc9:	89 c2                	mov    %eax,%edx
  803dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dce:	29 c2                	sub    %eax,%edx
  803dd0:	89 d0                	mov    %edx,%eax
  803dd2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd8:	83 f8 7f             	cmp    $0x7f,%eax
  803ddb:	76 07                	jbe    803de4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ddd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803de4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de7:	48 63 d0             	movslq %eax,%rdx
  803dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ded:	48 63 c8             	movslq %eax,%rcx
  803df0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803df7:	48 01 c1             	add    %rax,%rcx
  803dfa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e01:	48 89 ce             	mov    %rcx,%rsi
  803e04:	48 89 c7             	mov    %rax,%rdi
  803e07:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e16:	48 63 d0             	movslq %eax,%rdx
  803e19:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e20:	48 89 d6             	mov    %rdx,%rsi
  803e23:	48 89 c7             	mov    %rax,%rdi
  803e26:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  803e2d:	00 00 00 
  803e30:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e35:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3b:	48 98                	cltq   
  803e3d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e44:	0f 82 78 ff ff ff    	jb     803dc2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e4d:	c9                   	leaveq 
  803e4e:	c3                   	retq   

0000000000803e4f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e4f:	55                   	push   %rbp
  803e50:	48 89 e5             	mov    %rsp,%rbp
  803e53:	48 83 ec 08          	sub    $0x8,%rsp
  803e57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e60:	c9                   	leaveq 
  803e61:	c3                   	retq   

0000000000803e62 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e62:	55                   	push   %rbp
  803e63:	48 89 e5             	mov    %rsp,%rbp
  803e66:	48 83 ec 10          	sub    $0x10,%rsp
  803e6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e76:	48 be 52 49 80 00 00 	movabs $0x804952,%rsi
  803e7d:	00 00 00 
  803e80:	48 89 c7             	mov    %rax,%rdi
  803e83:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  803e8a:	00 00 00 
  803e8d:	ff d0                	callq  *%rax
	return 0;
  803e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e94:	c9                   	leaveq 
  803e95:	c3                   	retq   

0000000000803e96 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e96:	55                   	push   %rbp
  803e97:	48 89 e5             	mov    %rsp,%rbp
  803e9a:	48 83 ec 30          	sub    $0x30,%rsp
  803e9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803eaa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eaf:	75 0e                	jne    803ebf <ipc_recv+0x29>
        pg = (void *)UTOP;
  803eb1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803eb8:	00 00 00 
  803ebb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803ebf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec3:	48 89 c7             	mov    %rax,%rdi
  803ec6:	48 b8 43 24 80 00 00 	movabs $0x802443,%rax
  803ecd:	00 00 00 
  803ed0:	ff d0                	callq  *%rax
  803ed2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ed5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed9:	79 27                	jns    803f02 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803edb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ee0:	74 0a                	je     803eec <ipc_recv+0x56>
            *from_env_store = 0;
  803ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803eec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ef1:	74 0a                	je     803efd <ipc_recv+0x67>
            *perm_store = 0;
  803ef3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803efd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f00:	eb 53                	jmp    803f55 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803f02:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f07:	74 19                	je     803f22 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803f09:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803f10:	00 00 00 
  803f13:	48 8b 00             	mov    (%rax),%rax
  803f16:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f20:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803f22:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f27:	74 19                	je     803f42 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803f29:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803f30:	00 00 00 
  803f33:	48 8b 00             	mov    (%rax),%rax
  803f36:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f40:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803f42:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803f49:	00 00 00 
  803f4c:	48 8b 00             	mov    (%rax),%rax
  803f4f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803f55:	c9                   	leaveq 
  803f56:	c3                   	retq   

0000000000803f57 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f57:	55                   	push   %rbp
  803f58:	48 89 e5             	mov    %rsp,%rbp
  803f5b:	48 83 ec 30          	sub    $0x30,%rsp
  803f5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f62:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f65:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f69:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803f6c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f71:	75 0e                	jne    803f81 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803f73:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f7a:	00 00 00 
  803f7d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803f81:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f84:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f87:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8e:	89 c7                	mov    %eax,%edi
  803f90:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  803f97:	00 00 00 
  803f9a:	ff d0                	callq  *%rax
  803f9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803f9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fa3:	79 36                	jns    803fdb <ipc_send+0x84>
  803fa5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fa9:	74 30                	je     803fdb <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fae:	89 c1                	mov    %eax,%ecx
  803fb0:	48 ba 59 49 80 00 00 	movabs $0x804959,%rdx
  803fb7:	00 00 00 
  803fba:	be 49 00 00 00       	mov    $0x49,%esi
  803fbf:	48 bf 66 49 80 00 00 	movabs $0x804966,%rdi
  803fc6:	00 00 00 
  803fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fce:	49 b8 ea 0a 80 00 00 	movabs $0x800aea,%r8
  803fd5:	00 00 00 
  803fd8:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803fdb:	48 b8 dc 21 80 00 00 	movabs $0x8021dc,%rax
  803fe2:	00 00 00 
  803fe5:	ff d0                	callq  *%rax
    } while(r != 0);
  803fe7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803feb:	75 94                	jne    803f81 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803fed:	c9                   	leaveq 
  803fee:	c3                   	retq   

0000000000803fef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fef:	55                   	push   %rbp
  803ff0:	48 89 e5             	mov    %rsp,%rbp
  803ff3:	48 83 ec 14          	sub    $0x14,%rsp
  803ff7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ffa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804001:	eb 5e                	jmp    804061 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804003:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80400a:	00 00 00 
  80400d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804010:	48 63 d0             	movslq %eax,%rdx
  804013:	48 89 d0             	mov    %rdx,%rax
  804016:	48 c1 e0 03          	shl    $0x3,%rax
  80401a:	48 01 d0             	add    %rdx,%rax
  80401d:	48 c1 e0 05          	shl    $0x5,%rax
  804021:	48 01 c8             	add    %rcx,%rax
  804024:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80402a:	8b 00                	mov    (%rax),%eax
  80402c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80402f:	75 2c                	jne    80405d <ipc_find_env+0x6e>
			return envs[i].env_id;
  804031:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804038:	00 00 00 
  80403b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403e:	48 63 d0             	movslq %eax,%rdx
  804041:	48 89 d0             	mov    %rdx,%rax
  804044:	48 c1 e0 03          	shl    $0x3,%rax
  804048:	48 01 d0             	add    %rdx,%rax
  80404b:	48 c1 e0 05          	shl    $0x5,%rax
  80404f:	48 01 c8             	add    %rcx,%rax
  804052:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804058:	8b 40 08             	mov    0x8(%rax),%eax
  80405b:	eb 12                	jmp    80406f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80405d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804061:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804068:	7e 99                	jle    804003 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80406a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80406f:	c9                   	leaveq 
  804070:	c3                   	retq   

0000000000804071 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804071:	55                   	push   %rbp
  804072:	48 89 e5             	mov    %rsp,%rbp
  804075:	48 83 ec 18          	sub    $0x18,%rsp
  804079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80407d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804081:	48 c1 e8 15          	shr    $0x15,%rax
  804085:	48 89 c2             	mov    %rax,%rdx
  804088:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80408f:	01 00 00 
  804092:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804096:	83 e0 01             	and    $0x1,%eax
  804099:	48 85 c0             	test   %rax,%rax
  80409c:	75 07                	jne    8040a5 <pageref+0x34>
		return 0;
  80409e:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a3:	eb 53                	jmp    8040f8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ad:	48 89 c2             	mov    %rax,%rdx
  8040b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040b7:	01 00 00 
  8040ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c6:	83 e0 01             	and    $0x1,%eax
  8040c9:	48 85 c0             	test   %rax,%rax
  8040cc:	75 07                	jne    8040d5 <pageref+0x64>
		return 0;
  8040ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d3:	eb 23                	jmp    8040f8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8040dd:	48 89 c2             	mov    %rax,%rdx
  8040e0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040e7:	00 00 00 
  8040ea:	48 c1 e2 04          	shl    $0x4,%rdx
  8040ee:	48 01 d0             	add    %rdx,%rax
  8040f1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040f5:	0f b7 c0             	movzwl %ax,%eax
}
  8040f8:	c9                   	leaveq 
  8040f9:	c3                   	retq   
