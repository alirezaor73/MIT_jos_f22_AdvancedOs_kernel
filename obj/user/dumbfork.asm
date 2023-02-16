
obj/user/dumbfork:     file format elf64-x86-64


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
  80003c:	e8 1c 03 00 00       	callq  80035d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800052:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 4f                	jmp    8000b9 <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006e:	74 0c                	je     80007c <umain+0x39>
  800070:	48 b8 e0 38 80 00 00 	movabs $0x8038e0,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 e7 38 80 00 00 	movabs $0x8038e7,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf ed 38 80 00 00 	movabs $0x8038ed,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 4a 06 80 00 00 	movabs $0x80064a,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000bd:	74 07                	je     8000c6 <umain+0x83>
  8000bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c4:	eb 05                	jmp    8000cb <umain+0x88>
  8000c6:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000ce:	7f 9a                	jg     80006a <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d0:	c9                   	leaveq 
  8000d1:	c3                   	retq   

00000000008000d2 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d2:	55                   	push   %rbp
  8000d3:	48 89 e5             	mov    %rsp,%rbp
  8000d6:	48 83 ec 20          	sub    $0x20,%rsp
  8000da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ed:	48 89 ce             	mov    %rcx,%rsi
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800105:	79 30                	jns    800137 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba ff 38 80 00 00 	movabs $0x8038ff,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf 12 39 80 00 00 	movabs $0x803912,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800137:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800144:	b9 00 00 40 00       	mov    $0x400000,%ecx
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 30                	jns    800195 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba 22 39 80 00 00 	movabs $0x803922,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf 12 39 80 00 00 	movabs $0x803912,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  80018f:	00 00 00 
  800192:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019e:	48 89 c6             	mov    %rax,%rsi
  8001a1:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a6:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bc:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	79 30                	jns    800201 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d4:	89 c1                	mov    %eax,%ecx
  8001d6:	48 ba 33 39 80 00 00 	movabs $0x803933,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf 12 39 80 00 00 	movabs $0x803912,%rdi
  8001ec:	00 00 00 
  8001ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f4:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  8001fb:	00 00 00 
  8001fe:	41 ff d0             	callq  *%r8
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <dumbfork>:

envid_t
dumbfork(void)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 20          	sub    $0x20,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020b:	b8 07 00 00 00       	mov    $0x7,%eax
  800210:	cd 30                	int    $0x30
  800212:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  800215:	8b 45 e8             	mov    -0x18(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  800218:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (envid < 0)
  80021b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021f:	79 30                	jns    800251 <dumbfork+0x4e>
		panic("sys_exofork: %e", envid);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	89 c1                	mov    %eax,%ecx
  800226:	48 ba 46 39 80 00 00 	movabs $0x803946,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf 12 39 80 00 00 	movabs $0x803912,%rdi
  80023c:	00 00 00 
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  80024b:	00 00 00 
  80024e:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  800251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800255:	75 46                	jne    80029d <dumbfork+0x9a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800257:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	48 63 d0             	movslq %eax,%rdx
  80026b:	48 89 d0             	mov    %rdx,%rax
  80026e:	48 c1 e0 03          	shl    $0x3,%rax
  800272:	48 01 d0             	add    %rdx,%rax
  800275:	48 c1 e0 05          	shl    $0x5,%rax
  800279:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800280:	00 00 00 
  800283:	48 01 c2             	add    %rax,%rdx
  800286:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80028d:	00 00 00 
  800290:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	e9 be 00 00 00       	jmpq   80035b <dumbfork+0x158>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80029d:	48 c7 45 e0 00 00 80 	movq   $0x800000,-0x20(%rbp)
  8002a4:	00 
  8002a5:	eb 26                	jmp    8002cd <dumbfork+0xca>
		duppage(envid, addr);
  8002a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	48 89 d6             	mov    %rdx,%rsi
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002c3:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002d8:	00 00 00 
  8002db:	48 39 c2             	cmp    %rax,%rdx
  8002de:	72 c7                	jb     8002a7 <dumbfork+0xa4>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002e0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8002f2:	48 89 c2             	mov    %rax,%rdx
  8002f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f8:	48 89 d6             	mov    %rdx,%rsi
  8002fb:	89 c7                	mov    %eax,%edi
  8002fd:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	be 02 00 00 00       	mov    $0x2,%esi
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800326:	79 30                	jns    800358 <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  800328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 56 39 80 00 00 	movabs $0x803956,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf 12 39 80 00 00 	movabs $0x803912,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8

	return envid;
  800358:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80035b:	c9                   	leaveq 
  80035c:	c3                   	retq   

000000000080035d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %rbp
  80035e:	48 89 e5             	mov    %rsp,%rbp
  800361:	48 83 ec 20          	sub    $0x20,%rsp
  800365:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800368:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80036c:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
  800378:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80037b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800383:	48 63 d0             	movslq %eax,%rdx
  800386:	48 89 d0             	mov    %rdx,%rax
  800389:	48 c1 e0 03          	shl    $0x3,%rax
  80038d:	48 01 d0             	add    %rdx,%rax
  800390:	48 c1 e0 05          	shl    $0x5,%rax
  800394:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80039b:	00 00 00 
  80039e:	48 01 c2             	add    %rax,%rdx
  8003a1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003a8:	00 00 00 
  8003ab:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003b2:	7e 14                	jle    8003c8 <libmain+0x6b>
		binaryname = argv[0];
  8003b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b8:	48 8b 10             	mov    (%rax),%rdx
  8003bb:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003c2:	00 00 00 
  8003c5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8003cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003cf:	48 89 d6             	mov    %rdx,%rsi
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003e0:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax
}
  8003ec:	c9                   	leaveq 
  8003ed:	c3                   	retq   

00000000008003ee <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003f2:	48 b8 ef 20 80 00 00 	movabs $0x8020ef,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800403:	48 b8 81 1a 80 00 00 	movabs $0x801a81,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
}
  80040f:	5d                   	pop    %rbp
  800410:	c3                   	retq   

0000000000800411 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800411:	55                   	push   %rbp
  800412:	48 89 e5             	mov    %rsp,%rbp
  800415:	53                   	push   %rbx
  800416:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80041d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800424:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80042a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800431:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800438:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80043f:	84 c0                	test   %al,%al
  800441:	74 23                	je     800466 <_panic+0x55>
  800443:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80044a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80044e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800452:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800456:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80045a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80045e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800462:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800466:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80046d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800474:	00 00 00 
  800477:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80047e:	00 00 00 
  800481:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800485:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80048c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800493:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80049a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004a1:	00 00 00 
  8004a4:	48 8b 18             	mov    (%rax),%rbx
  8004a7:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  8004ae:	00 00 00 
  8004b1:	ff d0                	callq  *%rax
  8004b3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004c0:	41 89 c8             	mov    %ecx,%r8d
  8004c3:	48 89 d1             	mov    %rdx,%rcx
  8004c6:	48 89 da             	mov    %rbx,%rdx
  8004c9:	89 c6                	mov    %eax,%esi
  8004cb:	48 bf 78 39 80 00 00 	movabs $0x803978,%rdi
  8004d2:	00 00 00 
  8004d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004da:	49 b9 4a 06 80 00 00 	movabs $0x80064a,%r9
  8004e1:	00 00 00 
  8004e4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004f5:	48 89 d6             	mov    %rdx,%rsi
  8004f8:	48 89 c7             	mov    %rax,%rdi
  8004fb:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
	cprintf("\n");
  800507:	48 bf 9b 39 80 00 00 	movabs $0x80399b,%rdi
  80050e:	00 00 00 
  800511:	b8 00 00 00 00       	mov    $0x0,%eax
  800516:	48 ba 4a 06 80 00 00 	movabs $0x80064a,%rdx
  80051d:	00 00 00 
  800520:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800522:	cc                   	int3   
  800523:	eb fd                	jmp    800522 <_panic+0x111>

0000000000800525 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800525:	55                   	push   %rbp
  800526:	48 89 e5             	mov    %rsp,%rbp
  800529:	48 83 ec 10          	sub    $0x10,%rsp
  80052d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800530:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800538:	8b 00                	mov    (%rax),%eax
  80053a:	8d 48 01             	lea    0x1(%rax),%ecx
  80053d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800541:	89 0a                	mov    %ecx,(%rdx)
  800543:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800546:	89 d1                	mov    %edx,%ecx
  800548:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80054c:	48 98                	cltq   
  80054e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800556:	8b 00                	mov    (%rax),%eax
  800558:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055d:	75 2c                	jne    80058b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80055f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800563:	8b 00                	mov    (%rax),%eax
  800565:	48 98                	cltq   
  800567:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056b:	48 83 c2 08          	add    $0x8,%rdx
  80056f:	48 89 c6             	mov    %rax,%rsi
  800572:	48 89 d7             	mov    %rdx,%rdi
  800575:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
        b->idx = 0;
  800581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800585:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80058b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058f:	8b 40 04             	mov    0x4(%rax),%eax
  800592:	8d 50 01             	lea    0x1(%rax),%edx
  800595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800599:	89 50 04             	mov    %edx,0x4(%rax)
}
  80059c:	c9                   	leaveq 
  80059d:	c3                   	retq   

000000000080059e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
  8005a2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005b0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005b7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005be:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005c5:	48 8b 0a             	mov    (%rdx),%rcx
  8005c8:	48 89 08             	mov    %rcx,(%rax)
  8005cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005e2:	00 00 00 
    b.cnt = 0;
  8005e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005ec:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005ef:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005f6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005fd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800604:	48 89 c6             	mov    %rax,%rsi
  800607:	48 bf 25 05 80 00 00 	movabs $0x800525,%rdi
  80060e:	00 00 00 
  800611:	48 b8 fd 09 80 00 00 	movabs $0x8009fd,%rax
  800618:	00 00 00 
  80061b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80061d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800623:	48 98                	cltq   
  800625:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80062c:	48 83 c2 08          	add    $0x8,%rdx
  800630:	48 89 c6             	mov    %rax,%rsi
  800633:	48 89 d7             	mov    %rdx,%rdi
  800636:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800642:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800648:	c9                   	leaveq 
  800649:	c3                   	retq   

000000000080064a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80064a:	55                   	push   %rbp
  80064b:	48 89 e5             	mov    %rsp,%rbp
  80064e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800655:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80065c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800663:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80066a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800671:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800678:	84 c0                	test   %al,%al
  80067a:	74 20                	je     80069c <cprintf+0x52>
  80067c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800680:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800684:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800688:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80068c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800690:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800694:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800698:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80069c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006a3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006aa:	00 00 00 
  8006ad:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006b4:	00 00 00 
  8006b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006d0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006de:	48 8b 0a             	mov    (%rdx),%rcx
  8006e1:	48 89 08             	mov    %rcx,(%rax)
  8006e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006f4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800702:	48 89 d6             	mov    %rdx,%rsi
  800705:	48 89 c7             	mov    %rax,%rdi
  800708:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  80070f:	00 00 00 
  800712:	ff d0                	callq  *%rax
  800714:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80071a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800720:	c9                   	leaveq 
  800721:	c3                   	retq   

0000000000800722 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
  800726:	53                   	push   %rbx
  800727:	48 83 ec 38          	sub    $0x38,%rsp
  80072b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800733:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800737:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80073a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80073e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800742:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800745:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800749:	77 3b                	ja     800786 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80074b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80074e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800752:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
  80075e:	48 f7 f3             	div    %rbx
  800761:	48 89 c2             	mov    %rax,%rdx
  800764:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800767:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80076a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80076e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800772:	41 89 f9             	mov    %edi,%r9d
  800775:	48 89 c7             	mov    %rax,%rdi
  800778:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  80077f:	00 00 00 
  800782:	ff d0                	callq  *%rax
  800784:	eb 1e                	jmp    8007a4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800786:	eb 12                	jmp    80079a <printnum+0x78>
			putch(padc, putdat);
  800788:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80078c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	48 89 ce             	mov    %rcx,%rsi
  800796:	89 d7                	mov    %edx,%edi
  800798:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80079a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80079e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007a2:	7f e4                	jg     800788 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b0:	48 f7 f1             	div    %rcx
  8007b3:	48 89 d0             	mov    %rdx,%rax
  8007b6:	48 ba 90 3b 80 00 00 	movabs $0x803b90,%rdx
  8007bd:	00 00 00 
  8007c0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007c4:	0f be d0             	movsbl %al,%edx
  8007c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	48 89 ce             	mov    %rcx,%rsi
  8007d2:	89 d7                	mov    %edx,%edi
  8007d4:	ff d0                	callq  *%rax
}
  8007d6:	48 83 c4 38          	add    $0x38,%rsp
  8007da:	5b                   	pop    %rbx
  8007db:	5d                   	pop    %rbp
  8007dc:	c3                   	retq   

00000000008007dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007dd:	55                   	push   %rbp
  8007de:	48 89 e5             	mov    %rsp,%rbp
  8007e1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8007ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007f0:	7e 52                	jle    800844 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	8b 00                	mov    (%rax),%eax
  8007f8:	83 f8 30             	cmp    $0x30,%eax
  8007fb:	73 24                	jae    800821 <getuint+0x44>
  8007fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800801:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800809:	8b 00                	mov    (%rax),%eax
  80080b:	89 c0                	mov    %eax,%eax
  80080d:	48 01 d0             	add    %rdx,%rax
  800810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800814:	8b 12                	mov    (%rdx),%edx
  800816:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	89 0a                	mov    %ecx,(%rdx)
  80081f:	eb 17                	jmp    800838 <getuint+0x5b>
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800829:	48 89 d0             	mov    %rdx,%rax
  80082c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800830:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800834:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800838:	48 8b 00             	mov    (%rax),%rax
  80083b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083f:	e9 a3 00 00 00       	jmpq   8008e7 <getuint+0x10a>
	else if (lflag)
  800844:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800848:	74 4f                	je     800899 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	8b 00                	mov    (%rax),%eax
  800850:	83 f8 30             	cmp    $0x30,%eax
  800853:	73 24                	jae    800879 <getuint+0x9c>
  800855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800859:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800861:	8b 00                	mov    (%rax),%eax
  800863:	89 c0                	mov    %eax,%eax
  800865:	48 01 d0             	add    %rdx,%rax
  800868:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086c:	8b 12                	mov    (%rdx),%edx
  80086e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800871:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800875:	89 0a                	mov    %ecx,(%rdx)
  800877:	eb 17                	jmp    800890 <getuint+0xb3>
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800881:	48 89 d0             	mov    %rdx,%rax
  800884:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800890:	48 8b 00             	mov    (%rax),%rax
  800893:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800897:	eb 4e                	jmp    8008e7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089d:	8b 00                	mov    (%rax),%eax
  80089f:	83 f8 30             	cmp    $0x30,%eax
  8008a2:	73 24                	jae    8008c8 <getuint+0xeb>
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b0:	8b 00                	mov    (%rax),%eax
  8008b2:	89 c0                	mov    %eax,%eax
  8008b4:	48 01 d0             	add    %rdx,%rax
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	8b 12                	mov    (%rdx),%edx
  8008bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c4:	89 0a                	mov    %ecx,(%rdx)
  8008c6:	eb 17                	jmp    8008df <getuint+0x102>
  8008c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d0:	48 89 d0             	mov    %rdx,%rax
  8008d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008df:	8b 00                	mov    (%rax),%eax
  8008e1:	89 c0                	mov    %eax,%eax
  8008e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008eb:	c9                   	leaveq 
  8008ec:	c3                   	retq   

00000000008008ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ed:	55                   	push   %rbp
  8008ee:	48 89 e5             	mov    %rsp,%rbp
  8008f1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008fc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800900:	7e 52                	jle    800954 <getint+0x67>
		x=va_arg(*ap, long long);
  800902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800906:	8b 00                	mov    (%rax),%eax
  800908:	83 f8 30             	cmp    $0x30,%eax
  80090b:	73 24                	jae    800931 <getint+0x44>
  80090d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800911:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	8b 00                	mov    (%rax),%eax
  80091b:	89 c0                	mov    %eax,%eax
  80091d:	48 01 d0             	add    %rdx,%rax
  800920:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800924:	8b 12                	mov    (%rdx),%edx
  800926:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800929:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092d:	89 0a                	mov    %ecx,(%rdx)
  80092f:	eb 17                	jmp    800948 <getint+0x5b>
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800939:	48 89 d0             	mov    %rdx,%rax
  80093c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800944:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800948:	48 8b 00             	mov    (%rax),%rax
  80094b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094f:	e9 a3 00 00 00       	jmpq   8009f7 <getint+0x10a>
	else if (lflag)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800958:	74 4f                	je     8009a9 <getint+0xbc>
		x=va_arg(*ap, long);
  80095a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095e:	8b 00                	mov    (%rax),%eax
  800960:	83 f8 30             	cmp    $0x30,%eax
  800963:	73 24                	jae    800989 <getint+0x9c>
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800971:	8b 00                	mov    (%rax),%eax
  800973:	89 c0                	mov    %eax,%eax
  800975:	48 01 d0             	add    %rdx,%rax
  800978:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097c:	8b 12                	mov    (%rdx),%edx
  80097e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800981:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800985:	89 0a                	mov    %ecx,(%rdx)
  800987:	eb 17                	jmp    8009a0 <getint+0xb3>
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800991:	48 89 d0             	mov    %rdx,%rax
  800994:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a0:	48 8b 00             	mov    (%rax),%rax
  8009a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a7:	eb 4e                	jmp    8009f7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ad:	8b 00                	mov    (%rax),%eax
  8009af:	83 f8 30             	cmp    $0x30,%eax
  8009b2:	73 24                	jae    8009d8 <getint+0xeb>
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c0:	8b 00                	mov    (%rax),%eax
  8009c2:	89 c0                	mov    %eax,%eax
  8009c4:	48 01 d0             	add    %rdx,%rax
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	8b 12                	mov    (%rdx),%edx
  8009cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d4:	89 0a                	mov    %ecx,(%rdx)
  8009d6:	eb 17                	jmp    8009ef <getint+0x102>
  8009d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e0:	48 89 d0             	mov    %rdx,%rax
  8009e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ef:	8b 00                	mov    (%rax),%eax
  8009f1:	48 98                	cltq   
  8009f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009fb:	c9                   	leaveq 
  8009fc:	c3                   	retq   

00000000008009fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009fd:	55                   	push   %rbp
  8009fe:	48 89 e5             	mov    %rsp,%rbp
  800a01:	41 54                	push   %r12
  800a03:	53                   	push   %rbx
  800a04:	48 83 ec 60          	sub    $0x60,%rsp
  800a08:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a0c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a10:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a14:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a18:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a20:	48 8b 0a             	mov    (%rdx),%rcx
  800a23:	48 89 08             	mov    %rcx,(%rax)
  800a26:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a2a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a32:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a36:	eb 17                	jmp    800a4f <vprintfmt+0x52>
			if (ch == '\0')
  800a38:	85 db                	test   %ebx,%ebx
  800a3a:	0f 84 df 04 00 00    	je     800f1f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800a40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a48:	48 89 d6             	mov    %rdx,%rsi
  800a4b:	89 df                	mov    %ebx,%edi
  800a4d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5b:	0f b6 00             	movzbl (%rax),%eax
  800a5e:	0f b6 d8             	movzbl %al,%ebx
  800a61:	83 fb 25             	cmp    $0x25,%ebx
  800a64:	75 d2                	jne    800a38 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a66:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a6a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a71:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a7f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a8e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a92:	0f b6 00             	movzbl (%rax),%eax
  800a95:	0f b6 d8             	movzbl %al,%ebx
  800a98:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a9b:	83 f8 55             	cmp    $0x55,%eax
  800a9e:	0f 87 47 04 00 00    	ja     800eeb <vprintfmt+0x4ee>
  800aa4:	89 c0                	mov    %eax,%eax
  800aa6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aad:	00 
  800aae:	48 b8 b8 3b 80 00 00 	movabs $0x803bb8,%rax
  800ab5:	00 00 00 
  800ab8:	48 01 d0             	add    %rdx,%rax
  800abb:	48 8b 00             	mov    (%rax),%rax
  800abe:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ac0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ac4:	eb c0                	jmp    800a86 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aca:	eb ba                	jmp    800a86 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800acc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ad3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad6:	89 d0                	mov    %edx,%eax
  800ad8:	c1 e0 02             	shl    $0x2,%eax
  800adb:	01 d0                	add    %edx,%eax
  800add:	01 c0                	add    %eax,%eax
  800adf:	01 d8                	add    %ebx,%eax
  800ae1:	83 e8 30             	sub    $0x30,%eax
  800ae4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aeb:	0f b6 00             	movzbl (%rax),%eax
  800aee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800af1:	83 fb 2f             	cmp    $0x2f,%ebx
  800af4:	7e 0c                	jle    800b02 <vprintfmt+0x105>
  800af6:	83 fb 39             	cmp    $0x39,%ebx
  800af9:	7f 07                	jg     800b02 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800afb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b00:	eb d1                	jmp    800ad3 <vprintfmt+0xd6>
			goto process_precision;
  800b02:	eb 58                	jmp    800b5c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b07:	83 f8 30             	cmp    $0x30,%eax
  800b0a:	73 17                	jae    800b23 <vprintfmt+0x126>
  800b0c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b13:	89 c0                	mov    %eax,%eax
  800b15:	48 01 d0             	add    %rdx,%rax
  800b18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1b:	83 c2 08             	add    $0x8,%edx
  800b1e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b21:	eb 0f                	jmp    800b32 <vprintfmt+0x135>
  800b23:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b27:	48 89 d0             	mov    %rdx,%rax
  800b2a:	48 83 c2 08          	add    $0x8,%rdx
  800b2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b32:	8b 00                	mov    (%rax),%eax
  800b34:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b37:	eb 23                	jmp    800b5c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3d:	79 0c                	jns    800b4b <vprintfmt+0x14e>
				width = 0;
  800b3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b46:	e9 3b ff ff ff       	jmpq   800a86 <vprintfmt+0x89>
  800b4b:	e9 36 ff ff ff       	jmpq   800a86 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b50:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b57:	e9 2a ff ff ff       	jmpq   800a86 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b60:	79 12                	jns    800b74 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b62:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b65:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b6f:	e9 12 ff ff ff       	jmpq   800a86 <vprintfmt+0x89>
  800b74:	e9 0d ff ff ff       	jmpq   800a86 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b79:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b7d:	e9 04 ff ff ff       	jmpq   800a86 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b85:	83 f8 30             	cmp    $0x30,%eax
  800b88:	73 17                	jae    800ba1 <vprintfmt+0x1a4>
  800b8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b91:	89 c0                	mov    %eax,%eax
  800b93:	48 01 d0             	add    %rdx,%rax
  800b96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b99:	83 c2 08             	add    $0x8,%edx
  800b9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b9f:	eb 0f                	jmp    800bb0 <vprintfmt+0x1b3>
  800ba1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba5:	48 89 d0             	mov    %rdx,%rax
  800ba8:	48 83 c2 08          	add    $0x8,%rdx
  800bac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb0:	8b 10                	mov    (%rax),%edx
  800bb2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	48 89 ce             	mov    %rcx,%rsi
  800bbd:	89 d7                	mov    %edx,%edi
  800bbf:	ff d0                	callq  *%rax
			break;
  800bc1:	e9 53 03 00 00       	jmpq   800f19 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc9:	83 f8 30             	cmp    $0x30,%eax
  800bcc:	73 17                	jae    800be5 <vprintfmt+0x1e8>
  800bce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd5:	89 c0                	mov    %eax,%eax
  800bd7:	48 01 d0             	add    %rdx,%rax
  800bda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdd:	83 c2 08             	add    $0x8,%edx
  800be0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be3:	eb 0f                	jmp    800bf4 <vprintfmt+0x1f7>
  800be5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be9:	48 89 d0             	mov    %rdx,%rax
  800bec:	48 83 c2 08          	add    $0x8,%rdx
  800bf0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf6:	85 db                	test   %ebx,%ebx
  800bf8:	79 02                	jns    800bfc <vprintfmt+0x1ff>
				err = -err;
  800bfa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bfc:	83 fb 15             	cmp    $0x15,%ebx
  800bff:	7f 16                	jg     800c17 <vprintfmt+0x21a>
  800c01:	48 b8 e0 3a 80 00 00 	movabs $0x803ae0,%rax
  800c08:	00 00 00 
  800c0b:	48 63 d3             	movslq %ebx,%rdx
  800c0e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c12:	4d 85 e4             	test   %r12,%r12
  800c15:	75 2e                	jne    800c45 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c17:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1f:	89 d9                	mov    %ebx,%ecx
  800c21:	48 ba a1 3b 80 00 00 	movabs $0x803ba1,%rdx
  800c28:	00 00 00 
  800c2b:	48 89 c7             	mov    %rax,%rdi
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c33:	49 b8 28 0f 80 00 00 	movabs $0x800f28,%r8
  800c3a:	00 00 00 
  800c3d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c40:	e9 d4 02 00 00       	jmpq   800f19 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c45:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4d:	4c 89 e1             	mov    %r12,%rcx
  800c50:	48 ba aa 3b 80 00 00 	movabs $0x803baa,%rdx
  800c57:	00 00 00 
  800c5a:	48 89 c7             	mov    %rax,%rdi
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	49 b8 28 0f 80 00 00 	movabs $0x800f28,%r8
  800c69:	00 00 00 
  800c6c:	41 ff d0             	callq  *%r8
			break;
  800c6f:	e9 a5 02 00 00       	jmpq   800f19 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	83 f8 30             	cmp    $0x30,%eax
  800c7a:	73 17                	jae    800c93 <vprintfmt+0x296>
  800c7c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c83:	89 c0                	mov    %eax,%eax
  800c85:	48 01 d0             	add    %rdx,%rax
  800c88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8b:	83 c2 08             	add    $0x8,%edx
  800c8e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c91:	eb 0f                	jmp    800ca2 <vprintfmt+0x2a5>
  800c93:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c97:	48 89 d0             	mov    %rdx,%rax
  800c9a:	48 83 c2 08          	add    $0x8,%rdx
  800c9e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca2:	4c 8b 20             	mov    (%rax),%r12
  800ca5:	4d 85 e4             	test   %r12,%r12
  800ca8:	75 0a                	jne    800cb4 <vprintfmt+0x2b7>
				p = "(null)";
  800caa:	49 bc ad 3b 80 00 00 	movabs $0x803bad,%r12
  800cb1:	00 00 00 
			if (width > 0 && padc != '-')
  800cb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb8:	7e 3f                	jle    800cf9 <vprintfmt+0x2fc>
  800cba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cbe:	74 39                	je     800cf9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cc3:	48 98                	cltq   
  800cc5:	48 89 c6             	mov    %rax,%rsi
  800cc8:	4c 89 e7             	mov    %r12,%rdi
  800ccb:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  800cd2:	00 00 00 
  800cd5:	ff d0                	callq  *%rax
  800cd7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cda:	eb 17                	jmp    800cf3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cdc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ce0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ce4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce8:	48 89 ce             	mov    %rcx,%rsi
  800ceb:	89 d7                	mov    %edx,%edi
  800ced:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf7:	7f e3                	jg     800cdc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf9:	eb 37                	jmp    800d32 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cff:	74 1e                	je     800d1f <vprintfmt+0x322>
  800d01:	83 fb 1f             	cmp    $0x1f,%ebx
  800d04:	7e 05                	jle    800d0b <vprintfmt+0x30e>
  800d06:	83 fb 7e             	cmp    $0x7e,%ebx
  800d09:	7e 14                	jle    800d1f <vprintfmt+0x322>
					putch('?', putdat);
  800d0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	48 89 d6             	mov    %rdx,%rsi
  800d16:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d1b:	ff d0                	callq  *%rax
  800d1d:	eb 0f                	jmp    800d2e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d27:	48 89 d6             	mov    %rdx,%rsi
  800d2a:	89 df                	mov    %ebx,%edi
  800d2c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d32:	4c 89 e0             	mov    %r12,%rax
  800d35:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d39:	0f b6 00             	movzbl (%rax),%eax
  800d3c:	0f be d8             	movsbl %al,%ebx
  800d3f:	85 db                	test   %ebx,%ebx
  800d41:	74 10                	je     800d53 <vprintfmt+0x356>
  800d43:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d47:	78 b2                	js     800cfb <vprintfmt+0x2fe>
  800d49:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d4d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d51:	79 a8                	jns    800cfb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d53:	eb 16                	jmp    800d6b <vprintfmt+0x36e>
				putch(' ', putdat);
  800d55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5d:	48 89 d6             	mov    %rdx,%rsi
  800d60:	bf 20 00 00 00       	mov    $0x20,%edi
  800d65:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d67:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6f:	7f e4                	jg     800d55 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d71:	e9 a3 01 00 00       	jmpq   800f19 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d76:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7a:	be 03 00 00 00       	mov    $0x3,%esi
  800d7f:	48 89 c7             	mov    %rax,%rdi
  800d82:	48 b8 ed 08 80 00 00 	movabs $0x8008ed,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	callq  *%rax
  800d8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d96:	48 85 c0             	test   %rax,%rax
  800d99:	79 1d                	jns    800db8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da3:	48 89 d6             	mov    %rdx,%rsi
  800da6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dab:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db1:	48 f7 d8             	neg    %rax
  800db4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbf:	e9 e8 00 00 00       	jmpq   800eac <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc8:	be 03 00 00 00       	mov    $0x3,%esi
  800dcd:	48 89 c7             	mov    %rax,%rdi
  800dd0:	48 b8 dd 07 80 00 00 	movabs $0x8007dd,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800de0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de7:	e9 c0 00 00 00       	jmpq   800eac <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df4:	48 89 d6             	mov    %rdx,%rsi
  800df7:	bf 58 00 00 00       	mov    $0x58,%edi
  800dfc:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e06:	48 89 d6             	mov    %rdx,%rsi
  800e09:	bf 58 00 00 00       	mov    $0x58,%edi
  800e0e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e18:	48 89 d6             	mov    %rdx,%rsi
  800e1b:	bf 58 00 00 00       	mov    $0x58,%edi
  800e20:	ff d0                	callq  *%rax
			break;
  800e22:	e9 f2 00 00 00       	jmpq   800f19 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2f:	48 89 d6             	mov    %rdx,%rsi
  800e32:	bf 30 00 00 00       	mov    $0x30,%edi
  800e37:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e41:	48 89 d6             	mov    %rdx,%rsi
  800e44:	bf 78 00 00 00       	mov    $0x78,%edi
  800e49:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4e:	83 f8 30             	cmp    $0x30,%eax
  800e51:	73 17                	jae    800e6a <vprintfmt+0x46d>
  800e53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5a:	89 c0                	mov    %eax,%eax
  800e5c:	48 01 d0             	add    %rdx,%rax
  800e5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e62:	83 c2 08             	add    $0x8,%edx
  800e65:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e68:	eb 0f                	jmp    800e79 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800e6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6e:	48 89 d0             	mov    %rdx,%rax
  800e71:	48 83 c2 08          	add    $0x8,%rdx
  800e75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e79:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e87:	eb 23                	jmp    800eac <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8d:	be 03 00 00 00       	mov    $0x3,%esi
  800e92:	48 89 c7             	mov    %rax,%rdi
  800e95:	48 b8 dd 07 80 00 00 	movabs $0x8007dd,%rax
  800e9c:	00 00 00 
  800e9f:	ff d0                	callq  *%rax
  800ea1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ea5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eac:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eb4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ebf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec3:	45 89 c1             	mov    %r8d,%r9d
  800ec6:	41 89 f8             	mov    %edi,%r8d
  800ec9:	48 89 c7             	mov    %rax,%rdi
  800ecc:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800ed3:	00 00 00 
  800ed6:	ff d0                	callq  *%rax
			break;
  800ed8:	eb 3f                	jmp    800f19 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ede:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee2:	48 89 d6             	mov    %rdx,%rsi
  800ee5:	89 df                	mov    %ebx,%edi
  800ee7:	ff d0                	callq  *%rax
			break;
  800ee9:	eb 2e                	jmp    800f19 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eeb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef3:	48 89 d6             	mov    %rdx,%rsi
  800ef6:	bf 25 00 00 00       	mov    $0x25,%edi
  800efb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800efd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f02:	eb 05                	jmp    800f09 <vprintfmt+0x50c>
  800f04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0d:	48 83 e8 01          	sub    $0x1,%rax
  800f11:	0f b6 00             	movzbl (%rax),%eax
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 ec                	jne    800f04 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1a:	e9 30 fb ff ff       	jmpq   800a4f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f1f:	48 83 c4 60          	add    $0x60,%rsp
  800f23:	5b                   	pop    %rbx
  800f24:	41 5c                	pop    %r12
  800f26:	5d                   	pop    %rbp
  800f27:	c3                   	retq   

0000000000800f28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f28:	55                   	push   %rbp
  800f29:	48 89 e5             	mov    %rsp,%rbp
  800f2c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f33:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f3a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f56:	84 c0                	test   %al,%al
  800f58:	74 20                	je     800f7a <printfmt+0x52>
  800f5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f81:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f88:	00 00 00 
  800f8b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f92:	00 00 00 
  800f95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f99:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fae:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fbc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fca:	48 89 c7             	mov    %rax,%rdi
  800fcd:	48 b8 fd 09 80 00 00 	movabs $0x8009fd,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fd9:	c9                   	leaveq 
  800fda:	c3                   	retq   

0000000000800fdb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fdb:	55                   	push   %rbp
  800fdc:	48 89 e5             	mov    %rsp,%rbp
  800fdf:	48 83 ec 10          	sub    $0x10,%rsp
  800fe3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fee:	8b 40 10             	mov    0x10(%rax),%eax
  800ff1:	8d 50 01             	lea    0x1(%rax),%edx
  800ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 8b 10             	mov    (%rax),%rdx
  801002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801006:	48 8b 40 08          	mov    0x8(%rax),%rax
  80100a:	48 39 c2             	cmp    %rax,%rdx
  80100d:	73 17                	jae    801026 <sprintputch+0x4b>
		*b->buf++ = ch;
  80100f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801013:	48 8b 00             	mov    (%rax),%rax
  801016:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80101a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80101e:	48 89 0a             	mov    %rcx,(%rdx)
  801021:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801024:	88 10                	mov    %dl,(%rax)
}
  801026:	c9                   	leaveq 
  801027:	c3                   	retq   

0000000000801028 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	48 83 ec 50          	sub    $0x50,%rsp
  801030:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801034:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801037:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80103b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80103f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801043:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801047:	48 8b 0a             	mov    (%rdx),%rcx
  80104a:	48 89 08             	mov    %rcx,(%rax)
  80104d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801051:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801055:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801059:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801061:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801065:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801068:	48 98                	cltq   
  80106a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80106e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801072:	48 01 d0             	add    %rdx,%rax
  801075:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801079:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801080:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801085:	74 06                	je     80108d <vsnprintf+0x65>
  801087:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80108b:	7f 07                	jg     801094 <vsnprintf+0x6c>
		return -E_INVAL;
  80108d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801092:	eb 2f                	jmp    8010c3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801094:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801098:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80109c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a0:	48 89 c6             	mov    %rax,%rsi
  8010a3:	48 bf db 0f 80 00 00 	movabs $0x800fdb,%rdi
  8010aa:	00 00 00 
  8010ad:	48 b8 fd 09 80 00 00 	movabs $0x8009fd,%rax
  8010b4:	00 00 00 
  8010b7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010bd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c3:	c9                   	leaveq 
  8010c4:	c3                   	retq   

00000000008010c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f2:	84 c0                	test   %al,%al
  8010f4:	74 20                	je     801116 <snprintf+0x51>
  8010f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801102:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801106:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80110a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801112:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801116:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80111d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801124:	00 00 00 
  801127:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80112e:	00 00 00 
  801131:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801135:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80113c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801143:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80114a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801151:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801158:	48 8b 0a             	mov    (%rdx),%rcx
  80115b:	48 89 08             	mov    %rcx,(%rax)
  80115e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801162:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801166:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80116a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80116e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801175:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80117c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801182:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801189:	48 89 c7             	mov    %rax,%rdi
  80118c:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  801193:	00 00 00 
  801196:	ff d0                	callq  *%rax
  801198:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80119e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a4:	c9                   	leaveq 
  8011a5:	c3                   	retq   

00000000008011a6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a6:	55                   	push   %rbp
  8011a7:	48 89 e5             	mov    %rsp,%rbp
  8011aa:	48 83 ec 18          	sub    $0x18,%rsp
  8011ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b9:	eb 09                	jmp    8011c4 <strlen+0x1e>
		n++;
  8011bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c8:	0f b6 00             	movzbl (%rax),%eax
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ec                	jne    8011bb <strlen+0x15>
		n++;
	return n;
  8011cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d2:	c9                   	leaveq 
  8011d3:	c3                   	retq   

00000000008011d4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	48 83 ec 20          	sub    $0x20,%rsp
  8011dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011eb:	eb 0e                	jmp    8011fb <strnlen+0x27>
		n++;
  8011ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011fb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801200:	74 0b                	je     80120d <strnlen+0x39>
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	0f b6 00             	movzbl (%rax),%eax
  801209:	84 c0                	test   %al,%al
  80120b:	75 e0                	jne    8011ed <strnlen+0x19>
		n++;
	return n;
  80120d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801210:	c9                   	leaveq 
  801211:	c3                   	retq   

0000000000801212 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801212:	55                   	push   %rbp
  801213:	48 89 e5             	mov    %rsp,%rbp
  801216:	48 83 ec 20          	sub    $0x20,%rsp
  80121a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801226:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80122a:	90                   	nop
  80122b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801233:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801237:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80123f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801243:	0f b6 12             	movzbl (%rdx),%edx
  801246:	88 10                	mov    %dl,(%rax)
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	84 c0                	test   %al,%al
  80124d:	75 dc                	jne    80122b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80124f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801253:	c9                   	leaveq 
  801254:	c3                   	retq   

0000000000801255 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801255:	55                   	push   %rbp
  801256:	48 89 e5             	mov    %rsp,%rbp
  801259:	48 83 ec 20          	sub    $0x20,%rsp
  80125d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801261:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801269:	48 89 c7             	mov    %rax,%rdi
  80126c:	48 b8 a6 11 80 00 00 	movabs $0x8011a6,%rax
  801273:	00 00 00 
  801276:	ff d0                	callq  *%rax
  801278:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80127b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80127e:	48 63 d0             	movslq %eax,%rdx
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	48 01 c2             	add    %rax,%rdx
  801288:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128c:	48 89 c6             	mov    %rax,%rsi
  80128f:	48 89 d7             	mov    %rdx,%rdi
  801292:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  801299:	00 00 00 
  80129c:	ff d0                	callq  *%rax
	return dst;
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a2:	c9                   	leaveq 
  8012a3:	c3                   	retq   

00000000008012a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a4:	55                   	push   %rbp
  8012a5:	48 89 e5             	mov    %rsp,%rbp
  8012a8:	48 83 ec 28          	sub    $0x28,%rsp
  8012ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c7:	00 
  8012c8:	eb 2a                	jmp    8012f4 <strncpy+0x50>
		*dst++ = *src;
  8012ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012da:	0f b6 12             	movzbl (%rdx),%edx
  8012dd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	84 c0                	test   %al,%al
  8012e8:	74 05                	je     8012ef <strncpy+0x4b>
			src++;
  8012ea:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012fc:	72 cc                	jb     8012ca <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801302:	c9                   	leaveq 
  801303:	c3                   	retq   

0000000000801304 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801304:	55                   	push   %rbp
  801305:	48 89 e5             	mov    %rsp,%rbp
  801308:	48 83 ec 28          	sub    $0x28,%rsp
  80130c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801310:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801314:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801320:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801325:	74 3d                	je     801364 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801327:	eb 1d                	jmp    801346 <strlcpy+0x42>
			*dst++ = *src++;
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801335:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801339:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801341:	0f b6 12             	movzbl (%rdx),%edx
  801344:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801346:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80134b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801350:	74 0b                	je     80135d <strlcpy+0x59>
  801352:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	84 c0                	test   %al,%al
  80135b:	75 cc                	jne    801329 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801361:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801364:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	48 29 c2             	sub    %rax,%rdx
  80136f:	48 89 d0             	mov    %rdx,%rax
}
  801372:	c9                   	leaveq 
  801373:	c3                   	retq   

0000000000801374 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801374:	55                   	push   %rbp
  801375:	48 89 e5             	mov    %rsp,%rbp
  801378:	48 83 ec 10          	sub    $0x10,%rsp
  80137c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801380:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801384:	eb 0a                	jmp    801390 <strcmp+0x1c>
		p++, q++;
  801386:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801394:	0f b6 00             	movzbl (%rax),%eax
  801397:	84 c0                	test   %al,%al
  801399:	74 12                	je     8013ad <strcmp+0x39>
  80139b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139f:	0f b6 10             	movzbl (%rax),%edx
  8013a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	38 c2                	cmp    %al,%dl
  8013ab:	74 d9                	je     801386 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	0f b6 d0             	movzbl %al,%edx
  8013b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bb:	0f b6 00             	movzbl (%rax),%eax
  8013be:	0f b6 c0             	movzbl %al,%eax
  8013c1:	29 c2                	sub    %eax,%edx
  8013c3:	89 d0                	mov    %edx,%eax
}
  8013c5:	c9                   	leaveq 
  8013c6:	c3                   	retq   

00000000008013c7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	48 83 ec 18          	sub    $0x18,%rsp
  8013cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013db:	eb 0f                	jmp    8013ec <strncmp+0x25>
		n--, p++, q++;
  8013dd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f1:	74 1d                	je     801410 <strncmp+0x49>
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	0f b6 00             	movzbl (%rax),%eax
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 12                	je     801410 <strncmp+0x49>
  8013fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801402:	0f b6 10             	movzbl (%rax),%edx
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	38 c2                	cmp    %al,%dl
  80140e:	74 cd                	je     8013dd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801410:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801415:	75 07                	jne    80141e <strncmp+0x57>
		return 0;
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
  80141c:	eb 18                	jmp    801436 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80141e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	0f b6 d0             	movzbl %al,%edx
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	0f b6 c0             	movzbl %al,%eax
  801432:	29 c2                	sub    %eax,%edx
  801434:	89 d0                	mov    %edx,%eax
}
  801436:	c9                   	leaveq 
  801437:	c3                   	retq   

0000000000801438 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801438:	55                   	push   %rbp
  801439:	48 89 e5             	mov    %rsp,%rbp
  80143c:	48 83 ec 0c          	sub    $0xc,%rsp
  801440:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801444:	89 f0                	mov    %esi,%eax
  801446:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801449:	eb 17                	jmp    801462 <strchr+0x2a>
		if (*s == c)
  80144b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801455:	75 06                	jne    80145d <strchr+0x25>
			return (char *) s;
  801457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145b:	eb 15                	jmp    801472 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80145d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	84 c0                	test   %al,%al
  80146b:	75 de                	jne    80144b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80146d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801472:	c9                   	leaveq 
  801473:	c3                   	retq   

0000000000801474 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801474:	55                   	push   %rbp
  801475:	48 89 e5             	mov    %rsp,%rbp
  801478:	48 83 ec 0c          	sub    $0xc,%rsp
  80147c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801480:	89 f0                	mov    %esi,%eax
  801482:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801485:	eb 13                	jmp    80149a <strfind+0x26>
		if (*s == c)
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	0f b6 00             	movzbl (%rax),%eax
  80148e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801491:	75 02                	jne    801495 <strfind+0x21>
			break;
  801493:	eb 10                	jmp    8014a5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801495:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	84 c0                	test   %al,%al
  8014a3:	75 e2                	jne    801487 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 18          	sub    $0x18,%rsp
  8014b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c3:	75 06                	jne    8014cb <memset+0x20>
		return v;
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	eb 69                	jmp    801534 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cf:	83 e0 03             	and    $0x3,%eax
  8014d2:	48 85 c0             	test   %rax,%rax
  8014d5:	75 48                	jne    80151f <memset+0x74>
  8014d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014db:	83 e0 03             	and    $0x3,%eax
  8014de:	48 85 c0             	test   %rax,%rax
  8014e1:	75 3c                	jne    80151f <memset+0x74>
		c &= 0xFF;
  8014e3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ed:	c1 e0 18             	shl    $0x18,%eax
  8014f0:	89 c2                	mov    %eax,%edx
  8014f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f5:	c1 e0 10             	shl    $0x10,%eax
  8014f8:	09 c2                	or     %eax,%edx
  8014fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fd:	c1 e0 08             	shl    $0x8,%eax
  801500:	09 d0                	or     %edx,%eax
  801502:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801509:	48 c1 e8 02          	shr    $0x2,%rax
  80150d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801510:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801514:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801517:	48 89 d7             	mov    %rdx,%rdi
  80151a:	fc                   	cld    
  80151b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80151d:	eb 11                	jmp    801530 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80151f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801523:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801526:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80152a:	48 89 d7             	mov    %rdx,%rdi
  80152d:	fc                   	cld    
  80152e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801534:	c9                   	leaveq 
  801535:	c3                   	retq   

0000000000801536 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801536:	55                   	push   %rbp
  801537:	48 89 e5             	mov    %rsp,%rbp
  80153a:	48 83 ec 28          	sub    $0x28,%rsp
  80153e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801546:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80154a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801556:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80155a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801562:	0f 83 88 00 00 00    	jae    8015f0 <memmove+0xba>
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801570:	48 01 d0             	add    %rdx,%rax
  801573:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801577:	76 77                	jbe    8015f0 <memmove+0xba>
		s += n;
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158d:	83 e0 03             	and    $0x3,%eax
  801590:	48 85 c0             	test   %rax,%rax
  801593:	75 3b                	jne    8015d0 <memmove+0x9a>
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	48 85 c0             	test   %rax,%rax
  80159f:	75 2f                	jne    8015d0 <memmove+0x9a>
  8015a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a5:	83 e0 03             	and    $0x3,%eax
  8015a8:	48 85 c0             	test   %rax,%rax
  8015ab:	75 23                	jne    8015d0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b1:	48 83 e8 04          	sub    $0x4,%rax
  8015b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b9:	48 83 ea 04          	sub    $0x4,%rdx
  8015bd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c5:	48 89 c7             	mov    %rax,%rdi
  8015c8:	48 89 d6             	mov    %rdx,%rsi
  8015cb:	fd                   	std    
  8015cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ce:	eb 1d                	jmp    8015ed <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	48 89 d7             	mov    %rdx,%rdi
  8015e7:	48 89 c1             	mov    %rax,%rcx
  8015ea:	fd                   	std    
  8015eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015ed:	fc                   	cld    
  8015ee:	eb 57                	jmp    801647 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	83 e0 03             	and    $0x3,%eax
  8015f7:	48 85 c0             	test   %rax,%rax
  8015fa:	75 36                	jne    801632 <memmove+0xfc>
  8015fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801600:	83 e0 03             	and    $0x3,%eax
  801603:	48 85 c0             	test   %rax,%rax
  801606:	75 2a                	jne    801632 <memmove+0xfc>
  801608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160c:	83 e0 03             	and    $0x3,%eax
  80160f:	48 85 c0             	test   %rax,%rax
  801612:	75 1e                	jne    801632 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	48 c1 e8 02          	shr    $0x2,%rax
  80161c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80161f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801623:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801627:	48 89 c7             	mov    %rax,%rdi
  80162a:	48 89 d6             	mov    %rdx,%rsi
  80162d:	fc                   	cld    
  80162e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801630:	eb 15                	jmp    801647 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801636:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163e:	48 89 c7             	mov    %rax,%rdi
  801641:	48 89 d6             	mov    %rdx,%rsi
  801644:	fc                   	cld    
  801645:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164b:	c9                   	leaveq 
  80164c:	c3                   	retq   

000000000080164d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164d:	55                   	push   %rbp
  80164e:	48 89 e5             	mov    %rsp,%rbp
  801651:	48 83 ec 18          	sub    $0x18,%rsp
  801655:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801659:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801665:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166d:	48 89 ce             	mov    %rcx,%rsi
  801670:	48 89 c7             	mov    %rax,%rdi
  801673:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
}
  80167f:	c9                   	leaveq 
  801680:	c3                   	retq   

0000000000801681 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801681:	55                   	push   %rbp
  801682:	48 89 e5             	mov    %rsp,%rbp
  801685:	48 83 ec 28          	sub    $0x28,%rsp
  801689:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801691:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801699:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80169d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a5:	eb 36                	jmp    8016dd <memcmp+0x5c>
		if (*s1 != *s2)
  8016a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ab:	0f b6 10             	movzbl (%rax),%edx
  8016ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	38 c2                	cmp    %al,%dl
  8016b7:	74 1a                	je     8016d3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	0f b6 d0             	movzbl %al,%edx
  8016c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c7:	0f b6 00             	movzbl (%rax),%eax
  8016ca:	0f b6 c0             	movzbl %al,%eax
  8016cd:	29 c2                	sub    %eax,%edx
  8016cf:	89 d0                	mov    %edx,%eax
  8016d1:	eb 20                	jmp    8016f3 <memcmp+0x72>
		s1++, s2++;
  8016d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016e9:	48 85 c0             	test   %rax,%rax
  8016ec:	75 b9                	jne    8016a7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f3:	c9                   	leaveq 
  8016f4:	c3                   	retq   

00000000008016f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f5:	55                   	push   %rbp
  8016f6:	48 89 e5             	mov    %rsp,%rbp
  8016f9:	48 83 ec 28          	sub    $0x28,%rsp
  8016fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801701:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801704:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801710:	48 01 d0             	add    %rdx,%rax
  801713:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801717:	eb 15                	jmp    80172e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171d:	0f b6 10             	movzbl (%rax),%edx
  801720:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801723:	38 c2                	cmp    %al,%dl
  801725:	75 02                	jne    801729 <memfind+0x34>
			break;
  801727:	eb 0f                	jmp    801738 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801729:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801732:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801736:	72 e1                	jb     801719 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173c:	c9                   	leaveq 
  80173d:	c3                   	retq   

000000000080173e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80173e:	55                   	push   %rbp
  80173f:	48 89 e5             	mov    %rsp,%rbp
  801742:	48 83 ec 34          	sub    $0x34,%rsp
  801746:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80174e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801758:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80175f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801760:	eb 05                	jmp    801767 <strtol+0x29>
		s++;
  801762:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3c 20                	cmp    $0x20,%al
  801770:	74 f0                	je     801762 <strtol+0x24>
  801772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801776:	0f b6 00             	movzbl (%rax),%eax
  801779:	3c 09                	cmp    $0x9,%al
  80177b:	74 e5                	je     801762 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801781:	0f b6 00             	movzbl (%rax),%eax
  801784:	3c 2b                	cmp    $0x2b,%al
  801786:	75 07                	jne    80178f <strtol+0x51>
		s++;
  801788:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178d:	eb 17                	jmp    8017a6 <strtol+0x68>
	else if (*s == '-')
  80178f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	3c 2d                	cmp    $0x2d,%al
  801798:	75 0c                	jne    8017a6 <strtol+0x68>
		s++, neg = 1;
  80179a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80179f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017aa:	74 06                	je     8017b2 <strtol+0x74>
  8017ac:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b0:	75 28                	jne    8017da <strtol+0x9c>
  8017b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b6:	0f b6 00             	movzbl (%rax),%eax
  8017b9:	3c 30                	cmp    $0x30,%al
  8017bb:	75 1d                	jne    8017da <strtol+0x9c>
  8017bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c1:	48 83 c0 01          	add    $0x1,%rax
  8017c5:	0f b6 00             	movzbl (%rax),%eax
  8017c8:	3c 78                	cmp    $0x78,%al
  8017ca:	75 0e                	jne    8017da <strtol+0x9c>
		s += 2, base = 16;
  8017cc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d8:	eb 2c                	jmp    801806 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017da:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017de:	75 19                	jne    8017f9 <strtol+0xbb>
  8017e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e4:	0f b6 00             	movzbl (%rax),%eax
  8017e7:	3c 30                	cmp    $0x30,%al
  8017e9:	75 0e                	jne    8017f9 <strtol+0xbb>
		s++, base = 8;
  8017eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f7:	eb 0d                	jmp    801806 <strtol+0xc8>
	else if (base == 0)
  8017f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fd:	75 07                	jne    801806 <strtol+0xc8>
		base = 10;
  8017ff:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180a:	0f b6 00             	movzbl (%rax),%eax
  80180d:	3c 2f                	cmp    $0x2f,%al
  80180f:	7e 1d                	jle    80182e <strtol+0xf0>
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	3c 39                	cmp    $0x39,%al
  80181a:	7f 12                	jg     80182e <strtol+0xf0>
			dig = *s - '0';
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	0f b6 00             	movzbl (%rax),%eax
  801823:	0f be c0             	movsbl %al,%eax
  801826:	83 e8 30             	sub    $0x30,%eax
  801829:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182c:	eb 4e                	jmp    80187c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80182e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801832:	0f b6 00             	movzbl (%rax),%eax
  801835:	3c 60                	cmp    $0x60,%al
  801837:	7e 1d                	jle    801856 <strtol+0x118>
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	0f b6 00             	movzbl (%rax),%eax
  801840:	3c 7a                	cmp    $0x7a,%al
  801842:	7f 12                	jg     801856 <strtol+0x118>
			dig = *s - 'a' + 10;
  801844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801848:	0f b6 00             	movzbl (%rax),%eax
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	83 e8 57             	sub    $0x57,%eax
  801851:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801854:	eb 26                	jmp    80187c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	3c 40                	cmp    $0x40,%al
  80185f:	7e 48                	jle    8018a9 <strtol+0x16b>
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	0f b6 00             	movzbl (%rax),%eax
  801868:	3c 5a                	cmp    $0x5a,%al
  80186a:	7f 3d                	jg     8018a9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	0f be c0             	movsbl %al,%eax
  801876:	83 e8 37             	sub    $0x37,%eax
  801879:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80187f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801882:	7c 02                	jl     801886 <strtol+0x148>
			break;
  801884:	eb 23                	jmp    8018a9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801886:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80188e:	48 98                	cltq   
  801890:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801895:	48 89 c2             	mov    %rax,%rdx
  801898:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189b:	48 98                	cltq   
  80189d:	48 01 d0             	add    %rdx,%rax
  8018a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a4:	e9 5d ff ff ff       	jmpq   801806 <strtol+0xc8>

	if (endptr)
  8018a9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018ae:	74 0b                	je     8018bb <strtol+0x17d>
		*endptr = (char *) s;
  8018b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018bf:	74 09                	je     8018ca <strtol+0x18c>
  8018c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c5:	48 f7 d8             	neg    %rax
  8018c8:	eb 04                	jmp    8018ce <strtol+0x190>
  8018ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018ce:	c9                   	leaveq 
  8018cf:	c3                   	retq   

00000000008018d0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	48 83 ec 30          	sub    $0x30,%rsp
  8018d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f6:	75 06                	jne    8018fe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fc:	eb 6b                	jmp    801969 <strstr+0x99>

	len = strlen(str);
  8018fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801902:	48 89 c7             	mov    %rax,%rdi
  801905:	48 b8 a6 11 80 00 00 	movabs $0x8011a6,%rax
  80190c:	00 00 00 
  80190f:	ff d0                	callq  *%rax
  801911:	48 98                	cltq   
  801913:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80191f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801929:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80192d:	75 07                	jne    801936 <strstr+0x66>
				return (char *) 0;
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
  801934:	eb 33                	jmp    801969 <strstr+0x99>
		} while (sc != c);
  801936:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80193a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80193d:	75 d8                	jne    801917 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80193f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801943:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194b:	48 89 ce             	mov    %rcx,%rsi
  80194e:	48 89 c7             	mov    %rax,%rdi
  801951:	48 b8 c7 13 80 00 00 	movabs $0x8013c7,%rax
  801958:	00 00 00 
  80195b:	ff d0                	callq  *%rax
  80195d:	85 c0                	test   %eax,%eax
  80195f:	75 b6                	jne    801917 <strstr+0x47>

	return (char *) (in - 1);
  801961:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801965:	48 83 e8 01          	sub    $0x1,%rax
}
  801969:	c9                   	leaveq 
  80196a:	c3                   	retq   

000000000080196b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	53                   	push   %rbx
  801970:	48 83 ec 48          	sub    $0x48,%rsp
  801974:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801977:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80197a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80197e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801982:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801986:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80198a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801991:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801995:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801999:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80199d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a1:	4c 89 c3             	mov    %r8,%rbx
  8019a4:	cd 30                	int    $0x30
  8019a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019ae:	74 3e                	je     8019ee <syscall+0x83>
  8019b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019b5:	7e 37                	jle    8019ee <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019be:	49 89 d0             	mov    %rdx,%r8
  8019c1:	89 c1                	mov    %eax,%ecx
  8019c3:	48 ba 68 3e 80 00 00 	movabs $0x803e68,%rdx
  8019ca:	00 00 00 
  8019cd:	be 23 00 00 00       	mov    $0x23,%esi
  8019d2:	48 bf 85 3e 80 00 00 	movabs $0x803e85,%rdi
  8019d9:	00 00 00 
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e1:	49 b9 11 04 80 00 00 	movabs $0x800411,%r9
  8019e8:	00 00 00 
  8019eb:	41 ff d1             	callq  *%r9

	return ret;
  8019ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f2:	48 83 c4 48          	add    $0x48,%rsp
  8019f6:	5b                   	pop    %rbx
  8019f7:	5d                   	pop    %rbp
  8019f8:	c3                   	retq   

00000000008019f9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019f9:	55                   	push   %rbp
  8019fa:	48 89 e5             	mov    %rsp,%rbp
  8019fd:	48 83 ec 20          	sub    $0x20,%rsp
  801a01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a18:	00 
  801a19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a25:	48 89 d1             	mov    %rdx,%rcx
  801a28:	48 89 c2             	mov    %rax,%rdx
  801a2b:	be 00 00 00 00       	mov    $0x0,%esi
  801a30:	bf 00 00 00 00       	mov    $0x0,%edi
  801a35:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
}
  801a41:	c9                   	leaveq 
  801a42:	c3                   	retq   

0000000000801a43 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a43:	55                   	push   %rbp
  801a44:	48 89 e5             	mov    %rsp,%rbp
  801a47:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a52:	00 
  801a53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	be 00 00 00 00       	mov    $0x0,%esi
  801a6e:	bf 01 00 00 00       	mov    $0x1,%edi
  801a73:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	callq  *%rax
}
  801a7f:	c9                   	leaveq 
  801a80:	c3                   	retq   

0000000000801a81 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a81:	55                   	push   %rbp
  801a82:	48 89 e5             	mov    %rsp,%rbp
  801a85:	48 83 ec 10          	sub    $0x10,%rsp
  801a89:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8f:	48 98                	cltq   
  801a91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a98:	00 
  801a99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aaa:	48 89 c2             	mov    %rax,%rdx
  801aad:	be 01 00 00 00       	mov    $0x1,%esi
  801ab2:	bf 03 00 00 00       	mov    $0x3,%edi
  801ab7:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801abe:	00 00 00 
  801ac1:	ff d0                	callq  *%rax
}
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801acd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad4:	00 
  801ad5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  801aeb:	be 00 00 00 00       	mov    $0x0,%esi
  801af0:	bf 02 00 00 00       	mov    $0x2,%edi
  801af5:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	callq  *%rax
}
  801b01:	c9                   	leaveq 
  801b02:	c3                   	retq   

0000000000801b03 <sys_yield>:

void
sys_yield(void)
{
  801b03:	55                   	push   %rbp
  801b04:	48 89 e5             	mov    %rsp,%rbp
  801b07:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b12:	00 
  801b13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b24:	ba 00 00 00 00       	mov    $0x0,%edx
  801b29:	be 00 00 00 00       	mov    $0x0,%esi
  801b2e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b33:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 20          	sub    $0x20,%rsp
  801b49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b50:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b56:	48 63 c8             	movslq %eax,%rcx
  801b59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b60:	48 98                	cltq   
  801b62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b69:	00 
  801b6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b70:	49 89 c8             	mov    %rcx,%r8
  801b73:	48 89 d1             	mov    %rdx,%rcx
  801b76:	48 89 c2             	mov    %rax,%rdx
  801b79:	be 01 00 00 00       	mov    $0x1,%esi
  801b7e:	bf 04 00 00 00       	mov    $0x4,%edi
  801b83:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801b8a:	00 00 00 
  801b8d:	ff d0                	callq  *%rax
}
  801b8f:	c9                   	leaveq 
  801b90:	c3                   	retq   

0000000000801b91 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b91:	55                   	push   %rbp
  801b92:	48 89 e5             	mov    %rsp,%rbp
  801b95:	48 83 ec 30          	sub    $0x30,%rsp
  801b99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ba3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bae:	48 63 c8             	movslq %eax,%rcx
  801bb1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb8:	48 63 f0             	movslq %eax,%rsi
  801bbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc2:	48 98                	cltq   
  801bc4:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bc8:	49 89 f9             	mov    %rdi,%r9
  801bcb:	49 89 f0             	mov    %rsi,%r8
  801bce:	48 89 d1             	mov    %rdx,%rcx
  801bd1:	48 89 c2             	mov    %rax,%rdx
  801bd4:	be 01 00 00 00       	mov    $0x1,%esi
  801bd9:	bf 05 00 00 00       	mov    $0x5,%edi
  801bde:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 20          	sub    $0x20,%rsp
  801bf4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	48 98                	cltq   
  801c04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0b:	00 
  801c0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c18:	48 89 d1             	mov    %rdx,%rcx
  801c1b:	48 89 c2             	mov    %rax,%rdx
  801c1e:	be 01 00 00 00       	mov    $0x1,%esi
  801c23:	bf 06 00 00 00       	mov    $0x6,%edi
  801c28:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	callq  *%rax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 10          	sub    $0x10,%rsp
  801c3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c41:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c47:	48 63 d0             	movslq %eax,%rdx
  801c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4d:	48 98                	cltq   
  801c4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c56:	00 
  801c57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c63:	48 89 d1             	mov    %rdx,%rcx
  801c66:	48 89 c2             	mov    %rax,%rdx
  801c69:	be 01 00 00 00       	mov    $0x1,%esi
  801c6e:	bf 08 00 00 00       	mov    $0x8,%edi
  801c73:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 20          	sub    $0x20,%rsp
  801c89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c97:	48 98                	cltq   
  801c99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca0:	00 
  801ca1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cad:	48 89 d1             	mov    %rdx,%rcx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 01 00 00 00       	mov    $0x1,%esi
  801cb8:	bf 09 00 00 00       	mov    $0x9,%edi
  801cbd:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 20          	sub    $0x20,%rsp
  801cd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce1:	48 98                	cltq   
  801ce3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cea:	00 
  801ceb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf7:	48 89 d1             	mov    %rdx,%rcx
  801cfa:	48 89 c2             	mov    %rax,%rdx
  801cfd:	be 01 00 00 00       	mov    $0x1,%esi
  801d02:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d07:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	callq  *%rax
}
  801d13:	c9                   	leaveq 
  801d14:	c3                   	retq   

0000000000801d15 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d15:	55                   	push   %rbp
  801d16:	48 89 e5             	mov    %rsp,%rbp
  801d19:	48 83 ec 20          	sub    $0x20,%rsp
  801d1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d24:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d28:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d2e:	48 63 f0             	movslq %eax,%rsi
  801d31:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d38:	48 98                	cltq   
  801d3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d45:	00 
  801d46:	49 89 f1             	mov    %rsi,%r9
  801d49:	49 89 c8             	mov    %rcx,%r8
  801d4c:	48 89 d1             	mov    %rdx,%rcx
  801d4f:	48 89 c2             	mov    %rax,%rdx
  801d52:	be 00 00 00 00       	mov    $0x0,%esi
  801d57:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d5c:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801d63:	00 00 00 
  801d66:	ff d0                	callq  *%rax
}
  801d68:	c9                   	leaveq 
  801d69:	c3                   	retq   

0000000000801d6a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d6a:	55                   	push   %rbp
  801d6b:	48 89 e5             	mov    %rsp,%rbp
  801d6e:	48 83 ec 10          	sub    $0x10,%rsp
  801d72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d81:	00 
  801d82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d93:	48 89 c2             	mov    %rax,%rdx
  801d96:	be 01 00 00 00       	mov    $0x1,%esi
  801d9b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da0:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	callq  *%rax
}
  801dac:	c9                   	leaveq 
  801dad:	c3                   	retq   

0000000000801dae <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dae:	55                   	push   %rbp
  801daf:	48 89 e5             	mov    %rsp,%rbp
  801db2:	48 83 ec 08          	sub    $0x8,%rsp
  801db6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dbe:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dc5:	ff ff ff 
  801dc8:	48 01 d0             	add    %rdx,%rax
  801dcb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dcf:	c9                   	leaveq 
  801dd0:	c3                   	retq   

0000000000801dd1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dd1:	55                   	push   %rbp
  801dd2:	48 89 e5             	mov    %rsp,%rbp
  801dd5:	48 83 ec 08          	sub    $0x8,%rsp
  801dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de1:	48 89 c7             	mov    %rax,%rdi
  801de4:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  801deb:	00 00 00 
  801dee:	ff d0                	callq  *%rax
  801df0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801df6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dfa:	c9                   	leaveq 
  801dfb:	c3                   	retq   

0000000000801dfc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dfc:	55                   	push   %rbp
  801dfd:	48 89 e5             	mov    %rsp,%rbp
  801e00:	48 83 ec 18          	sub    $0x18,%rsp
  801e04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e0f:	eb 6b                	jmp    801e7c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e14:	48 98                	cltq   
  801e16:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e1c:	48 c1 e0 0c          	shl    $0xc,%rax
  801e20:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e28:	48 c1 e8 15          	shr    $0x15,%rax
  801e2c:	48 89 c2             	mov    %rax,%rdx
  801e2f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e36:	01 00 00 
  801e39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3d:	83 e0 01             	and    $0x1,%eax
  801e40:	48 85 c0             	test   %rax,%rax
  801e43:	74 21                	je     801e66 <fd_alloc+0x6a>
  801e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e49:	48 c1 e8 0c          	shr    $0xc,%rax
  801e4d:	48 89 c2             	mov    %rax,%rdx
  801e50:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e57:	01 00 00 
  801e5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5e:	83 e0 01             	and    $0x1,%eax
  801e61:	48 85 c0             	test   %rax,%rax
  801e64:	75 12                	jne    801e78 <fd_alloc+0x7c>
			*fd_store = fd;
  801e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	eb 1a                	jmp    801e92 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e7c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e80:	7e 8f                	jle    801e11 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e86:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e8d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e92:	c9                   	leaveq 
  801e93:	c3                   	retq   

0000000000801e94 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	48 83 ec 20          	sub    $0x20,%rsp
  801e9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ea3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ea7:	78 06                	js     801eaf <fd_lookup+0x1b>
  801ea9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ead:	7e 07                	jle    801eb6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eb4:	eb 6c                	jmp    801f22 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801eb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eb9:	48 98                	cltq   
  801ebb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ec1:	48 c1 e0 0c          	shl    $0xc,%rax
  801ec5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecd:	48 c1 e8 15          	shr    $0x15,%rax
  801ed1:	48 89 c2             	mov    %rax,%rdx
  801ed4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801edb:	01 00 00 
  801ede:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee2:	83 e0 01             	and    $0x1,%eax
  801ee5:	48 85 c0             	test   %rax,%rax
  801ee8:	74 21                	je     801f0b <fd_lookup+0x77>
  801eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eee:	48 c1 e8 0c          	shr    $0xc,%rax
  801ef2:	48 89 c2             	mov    %rax,%rdx
  801ef5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801efc:	01 00 00 
  801eff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f03:	83 e0 01             	and    $0x1,%eax
  801f06:	48 85 c0             	test   %rax,%rax
  801f09:	75 07                	jne    801f12 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f10:	eb 10                	jmp    801f22 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f16:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f1a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f22:	c9                   	leaveq 
  801f23:	c3                   	retq   

0000000000801f24 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f24:	55                   	push   %rbp
  801f25:	48 89 e5             	mov    %rsp,%rbp
  801f28:	48 83 ec 30          	sub    $0x30,%rsp
  801f2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f30:	89 f0                	mov    %esi,%eax
  801f32:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f39:	48 89 c7             	mov    %rax,%rdi
  801f3c:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
  801f48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f4c:	48 89 d6             	mov    %rdx,%rsi
  801f4f:	89 c7                	mov    %eax,%edi
  801f51:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	callq  *%rax
  801f5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f64:	78 0a                	js     801f70 <fd_close+0x4c>
	    || fd != fd2)
  801f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f6e:	74 12                	je     801f82 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f70:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f74:	74 05                	je     801f7b <fd_close+0x57>
  801f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f79:	eb 05                	jmp    801f80 <fd_close+0x5c>
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	eb 69                	jmp    801feb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f86:	8b 00                	mov    (%rax),%eax
  801f88:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f8c:	48 89 d6             	mov    %rdx,%rsi
  801f8f:	89 c7                	mov    %eax,%edi
  801f91:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  801f98:	00 00 00 
  801f9b:	ff d0                	callq  *%rax
  801f9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa4:	78 2a                	js     801fd0 <fd_close+0xac>
		if (dev->dev_close)
  801fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801faa:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fae:	48 85 c0             	test   %rax,%rax
  801fb1:	74 16                	je     801fc9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fbb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fbf:	48 89 d7             	mov    %rdx,%rdi
  801fc2:	ff d0                	callq  *%rax
  801fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc7:	eb 07                	jmp    801fd0 <fd_close+0xac>
		else
			r = 0;
  801fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd4:	48 89 c6             	mov    %rax,%rsi
  801fd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fdc:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  801fe3:	00 00 00 
  801fe6:	ff d0                	callq  *%rax
	return r;
  801fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801feb:	c9                   	leaveq 
  801fec:	c3                   	retq   

0000000000801fed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fed:	55                   	push   %rbp
  801fee:	48 89 e5             	mov    %rsp,%rbp
  801ff1:	48 83 ec 20          	sub    $0x20,%rsp
  801ff5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ff8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802003:	eb 41                	jmp    802046 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802005:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80200c:	00 00 00 
  80200f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802012:	48 63 d2             	movslq %edx,%rdx
  802015:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802019:	8b 00                	mov    (%rax),%eax
  80201b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80201e:	75 22                	jne    802042 <dev_lookup+0x55>
			*dev = devtab[i];
  802020:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802027:	00 00 00 
  80202a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202d:	48 63 d2             	movslq %edx,%rdx
  802030:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802034:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802038:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	eb 60                	jmp    8020a2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802042:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802046:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80204d:	00 00 00 
  802050:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802053:	48 63 d2             	movslq %edx,%rdx
  802056:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205a:	48 85 c0             	test   %rax,%rax
  80205d:	75 a6                	jne    802005 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80205f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802066:	00 00 00 
  802069:	48 8b 00             	mov    (%rax),%rax
  80206c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802072:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802075:	89 c6                	mov    %eax,%esi
  802077:	48 bf 98 3e 80 00 00 	movabs $0x803e98,%rdi
  80207e:	00 00 00 
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	48 b9 4a 06 80 00 00 	movabs $0x80064a,%rcx
  80208d:	00 00 00 
  802090:	ff d1                	callq  *%rcx
	*dev = 0;
  802092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802096:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80209d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020a2:	c9                   	leaveq 
  8020a3:	c3                   	retq   

00000000008020a4 <close>:

int
close(int fdnum)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	48 83 ec 20          	sub    $0x20,%rsp
  8020ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020b6:	48 89 d6             	mov    %rdx,%rsi
  8020b9:	89 c7                	mov    %eax,%edi
  8020bb:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax
  8020c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ce:	79 05                	jns    8020d5 <close+0x31>
		return r;
  8020d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d3:	eb 18                	jmp    8020ed <close+0x49>
	else
		return fd_close(fd, 1);
  8020d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d9:	be 01 00 00 00       	mov    $0x1,%esi
  8020de:	48 89 c7             	mov    %rax,%rdi
  8020e1:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax
}
  8020ed:	c9                   	leaveq 
  8020ee:	c3                   	retq   

00000000008020ef <close_all>:

void
close_all(void)
{
  8020ef:	55                   	push   %rbp
  8020f0:	48 89 e5             	mov    %rsp,%rbp
  8020f3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020fe:	eb 15                	jmp    802115 <close_all+0x26>
		close(i);
  802100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802103:	89 c7                	mov    %eax,%edi
  802105:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802111:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802115:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802119:	7e e5                	jle    802100 <close_all+0x11>
		close(i);
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	48 83 ec 40          	sub    $0x40,%rsp
  802125:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802128:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80212b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80212f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802132:	48 89 d6             	mov    %rdx,%rsi
  802135:	89 c7                	mov    %eax,%edi
  802137:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
  802143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214a:	79 08                	jns    802154 <dup+0x37>
		return r;
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	e9 70 01 00 00       	jmpq   8022c4 <dup+0x1a7>
	close(newfdnum);
  802154:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802157:	89 c7                	mov    %eax,%edi
  802159:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802165:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802168:	48 98                	cltq   
  80216a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802170:	48 c1 e0 0c          	shl    $0xc,%rax
  802174:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802178:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217c:	48 89 c7             	mov    %rax,%rdi
  80217f:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  802186:	00 00 00 
  802189:	ff d0                	callq  *%rax
  80218b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80218f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802193:	48 89 c7             	mov    %rax,%rdi
  802196:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	callq  *%rax
  8021a2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021aa:	48 c1 e8 15          	shr    $0x15,%rax
  8021ae:	48 89 c2             	mov    %rax,%rdx
  8021b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021b8:	01 00 00 
  8021bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021bf:	83 e0 01             	and    $0x1,%eax
  8021c2:	48 85 c0             	test   %rax,%rax
  8021c5:	74 73                	je     80223a <dup+0x11d>
  8021c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8021cf:	48 89 c2             	mov    %rax,%rdx
  8021d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021d9:	01 00 00 
  8021dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e0:	83 e0 01             	and    $0x1,%eax
  8021e3:	48 85 c0             	test   %rax,%rax
  8021e6:	74 52                	je     80223a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f0:	48 89 c2             	mov    %rax,%rdx
  8021f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fa:	01 00 00 
  8021fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802201:	25 07 0e 00 00       	and    $0xe07,%eax
  802206:	89 c1                	mov    %eax,%ecx
  802208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80220c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802210:	41 89 c8             	mov    %ecx,%r8d
  802213:	48 89 d1             	mov    %rdx,%rcx
  802216:	ba 00 00 00 00       	mov    $0x0,%edx
  80221b:	48 89 c6             	mov    %rax,%rsi
  80221e:	bf 00 00 00 00       	mov    $0x0,%edi
  802223:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  80222a:	00 00 00 
  80222d:	ff d0                	callq  *%rax
  80222f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802232:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802236:	79 02                	jns    80223a <dup+0x11d>
			goto err;
  802238:	eb 57                	jmp    802291 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80223a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80223e:	48 c1 e8 0c          	shr    $0xc,%rax
  802242:	48 89 c2             	mov    %rax,%rdx
  802245:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224c:	01 00 00 
  80224f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802253:	25 07 0e 00 00       	and    $0xe07,%eax
  802258:	89 c1                	mov    %eax,%ecx
  80225a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802262:	41 89 c8             	mov    %ecx,%r8d
  802265:	48 89 d1             	mov    %rdx,%rcx
  802268:	ba 00 00 00 00       	mov    $0x0,%edx
  80226d:	48 89 c6             	mov    %rax,%rsi
  802270:	bf 00 00 00 00       	mov    $0x0,%edi
  802275:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax
  802281:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802284:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802288:	79 02                	jns    80228c <dup+0x16f>
		goto err;
  80228a:	eb 05                	jmp    802291 <dup+0x174>

	return newfdnum;
  80228c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80228f:	eb 33                	jmp    8022c4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802295:	48 89 c6             	mov    %rax,%rsi
  802298:	bf 00 00 00 00       	mov    $0x0,%edi
  80229d:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  8022a4:	00 00 00 
  8022a7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ad:	48 89 c6             	mov    %rax,%rsi
  8022b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b5:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
	return r;
  8022c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022c4:	c9                   	leaveq 
  8022c5:	c3                   	retq   

00000000008022c6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022c6:	55                   	push   %rbp
  8022c7:	48 89 e5             	mov    %rsp,%rbp
  8022ca:	48 83 ec 40          	sub    $0x40,%rsp
  8022ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022e0:	48 89 d6             	mov    %rdx,%rsi
  8022e3:	89 c7                	mov    %eax,%edi
  8022e5:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	callq  *%rax
  8022f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f8:	78 24                	js     80231e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fe:	8b 00                	mov    (%rax),%eax
  802300:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802304:	48 89 d6             	mov    %rdx,%rsi
  802307:	89 c7                	mov    %eax,%edi
  802309:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
  802315:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802318:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231c:	79 05                	jns    802323 <read+0x5d>
		return r;
  80231e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802321:	eb 76                	jmp    802399 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802327:	8b 40 08             	mov    0x8(%rax),%eax
  80232a:	83 e0 03             	and    $0x3,%eax
  80232d:	83 f8 01             	cmp    $0x1,%eax
  802330:	75 3a                	jne    80236c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802332:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802339:	00 00 00 
  80233c:	48 8b 00             	mov    (%rax),%rax
  80233f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802345:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802348:	89 c6                	mov    %eax,%esi
  80234a:	48 bf b7 3e 80 00 00 	movabs $0x803eb7,%rdi
  802351:	00 00 00 
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
  802359:	48 b9 4a 06 80 00 00 	movabs $0x80064a,%rcx
  802360:	00 00 00 
  802363:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802365:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236a:	eb 2d                	jmp    802399 <read+0xd3>
	}
	if (!dev->dev_read)
  80236c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802370:	48 8b 40 10          	mov    0x10(%rax),%rax
  802374:	48 85 c0             	test   %rax,%rax
  802377:	75 07                	jne    802380 <read+0xba>
		return -E_NOT_SUPP;
  802379:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80237e:	eb 19                	jmp    802399 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802384:	48 8b 40 10          	mov    0x10(%rax),%rax
  802388:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80238c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802390:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802394:	48 89 cf             	mov    %rcx,%rdi
  802397:	ff d0                	callq  *%rax
}
  802399:	c9                   	leaveq 
  80239a:	c3                   	retq   

000000000080239b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80239b:	55                   	push   %rbp
  80239c:	48 89 e5             	mov    %rsp,%rbp
  80239f:	48 83 ec 30          	sub    $0x30,%rsp
  8023a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023b5:	eb 49                	jmp    802400 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ba:	48 98                	cltq   
  8023bc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023c0:	48 29 c2             	sub    %rax,%rdx
  8023c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c6:	48 63 c8             	movslq %eax,%rcx
  8023c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023cd:	48 01 c1             	add    %rax,%rcx
  8023d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d3:	48 89 ce             	mov    %rcx,%rsi
  8023d6:	89 c7                	mov    %eax,%edi
  8023d8:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax
  8023e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023eb:	79 05                	jns    8023f2 <readn+0x57>
			return m;
  8023ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023f0:	eb 1c                	jmp    80240e <readn+0x73>
		if (m == 0)
  8023f2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023f6:	75 02                	jne    8023fa <readn+0x5f>
			break;
  8023f8:	eb 11                	jmp    80240b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fd:	01 45 fc             	add    %eax,-0x4(%rbp)
  802400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802403:	48 98                	cltq   
  802405:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802409:	72 ac                	jb     8023b7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80240b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80240e:	c9                   	leaveq 
  80240f:	c3                   	retq   

0000000000802410 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802410:	55                   	push   %rbp
  802411:	48 89 e5             	mov    %rsp,%rbp
  802414:	48 83 ec 40          	sub    $0x40,%rsp
  802418:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80241b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80241f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802423:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802427:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80242a:	48 89 d6             	mov    %rdx,%rsi
  80242d:	89 c7                	mov    %eax,%edi
  80242f:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax
  80243b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80243e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802442:	78 24                	js     802468 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802448:	8b 00                	mov    (%rax),%eax
  80244a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80244e:	48 89 d6             	mov    %rdx,%rsi
  802451:	89 c7                	mov    %eax,%edi
  802453:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
  80245f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802462:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802466:	79 05                	jns    80246d <write+0x5d>
		return r;
  802468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246b:	eb 75                	jmp    8024e2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80246d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802471:	8b 40 08             	mov    0x8(%rax),%eax
  802474:	83 e0 03             	and    $0x3,%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 3a                	jne    8024b5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80247b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802482:	00 00 00 
  802485:	48 8b 00             	mov    (%rax),%rax
  802488:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80248e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802491:	89 c6                	mov    %eax,%esi
  802493:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  80249a:	00 00 00 
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	48 b9 4a 06 80 00 00 	movabs $0x80064a,%rcx
  8024a9:	00 00 00 
  8024ac:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b3:	eb 2d                	jmp    8024e2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024bd:	48 85 c0             	test   %rax,%rax
  8024c0:	75 07                	jne    8024c9 <write+0xb9>
		return -E_NOT_SUPP;
  8024c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024c7:	eb 19                	jmp    8024e2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024d9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024dd:	48 89 cf             	mov    %rcx,%rdi
  8024e0:	ff d0                	callq  *%rax
}
  8024e2:	c9                   	leaveq 
  8024e3:	c3                   	retq   

00000000008024e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024e4:	55                   	push   %rbp
  8024e5:	48 89 e5             	mov    %rsp,%rbp
  8024e8:	48 83 ec 18          	sub    $0x18,%rsp
  8024ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024ef:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024f9:	48 89 d6             	mov    %rdx,%rsi
  8024fc:	89 c7                	mov    %eax,%edi
  8024fe:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  802505:	00 00 00 
  802508:	ff d0                	callq  *%rax
  80250a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802511:	79 05                	jns    802518 <seek+0x34>
		return r;
  802513:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802516:	eb 0f                	jmp    802527 <seek+0x43>
	fd->fd_offset = offset;
  802518:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80251f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802527:	c9                   	leaveq 
  802528:	c3                   	retq   

0000000000802529 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802529:	55                   	push   %rbp
  80252a:	48 89 e5             	mov    %rsp,%rbp
  80252d:	48 83 ec 30          	sub    $0x30,%rsp
  802531:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802534:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802537:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80253b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80253e:	48 89 d6             	mov    %rdx,%rsi
  802541:	89 c7                	mov    %eax,%edi
  802543:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  80254a:	00 00 00 
  80254d:	ff d0                	callq  *%rax
  80254f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802552:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802556:	78 24                	js     80257c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255c:	8b 00                	mov    (%rax),%eax
  80255e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802562:	48 89 d6             	mov    %rdx,%rsi
  802565:	89 c7                	mov    %eax,%edi
  802567:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  80256e:	00 00 00 
  802571:	ff d0                	callq  *%rax
  802573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257a:	79 05                	jns    802581 <ftruncate+0x58>
		return r;
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	eb 72                	jmp    8025f3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802585:	8b 40 08             	mov    0x8(%rax),%eax
  802588:	83 e0 03             	and    $0x3,%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	75 3a                	jne    8025c9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80258f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802596:	00 00 00 
  802599:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80259c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025a2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025a5:	89 c6                	mov    %eax,%esi
  8025a7:	48 bf f0 3e 80 00 00 	movabs $0x803ef0,%rdi
  8025ae:	00 00 00 
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b6:	48 b9 4a 06 80 00 00 	movabs $0x80064a,%rcx
  8025bd:	00 00 00 
  8025c0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c7:	eb 2a                	jmp    8025f3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025d1:	48 85 c0             	test   %rax,%rax
  8025d4:	75 07                	jne    8025dd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025d6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025db:	eb 16                	jmp    8025f3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025ec:	89 ce                	mov    %ecx,%esi
  8025ee:	48 89 d7             	mov    %rdx,%rdi
  8025f1:	ff d0                	callq  *%rax
}
  8025f3:	c9                   	leaveq 
  8025f4:	c3                   	retq   

00000000008025f5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025f5:	55                   	push   %rbp
  8025f6:	48 89 e5             	mov    %rsp,%rbp
  8025f9:	48 83 ec 30          	sub    $0x30,%rsp
  8025fd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802600:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802604:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802608:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	78 24                	js     802649 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802629:	8b 00                	mov    (%rax),%eax
  80262b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262f:	48 89 d6             	mov    %rdx,%rsi
  802632:	89 c7                	mov    %eax,%edi
  802634:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	79 05                	jns    80264e <fstat+0x59>
		return r;
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	eb 5e                	jmp    8026ac <fstat+0xb7>
	if (!dev->dev_stat)
  80264e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802652:	48 8b 40 28          	mov    0x28(%rax),%rax
  802656:	48 85 c0             	test   %rax,%rax
  802659:	75 07                	jne    802662 <fstat+0x6d>
		return -E_NOT_SUPP;
  80265b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802660:	eb 4a                	jmp    8026ac <fstat+0xb7>
	stat->st_name[0] = 0;
  802662:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802666:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802669:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80266d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802674:	00 00 00 
	stat->st_isdir = 0;
  802677:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802682:	00 00 00 
	stat->st_dev = dev;
  802685:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802689:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802698:	48 8b 40 28          	mov    0x28(%rax),%rax
  80269c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026a0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026a4:	48 89 ce             	mov    %rcx,%rsi
  8026a7:	48 89 d7             	mov    %rdx,%rdi
  8026aa:	ff d0                	callq  *%rax
}
  8026ac:	c9                   	leaveq 
  8026ad:	c3                   	retq   

00000000008026ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026ae:	55                   	push   %rbp
  8026af:	48 89 e5             	mov    %rsp,%rbp
  8026b2:	48 83 ec 20          	sub    $0x20,%rsp
  8026b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c2:	be 00 00 00 00       	mov    $0x0,%esi
  8026c7:	48 89 c7             	mov    %rax,%rdi
  8026ca:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  8026d1:	00 00 00 
  8026d4:	ff d0                	callq  *%rax
  8026d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026dd:	79 05                	jns    8026e4 <stat+0x36>
		return fd;
  8026df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e2:	eb 2f                	jmp    802713 <stat+0x65>
	r = fstat(fd, stat);
  8026e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026eb:	48 89 d6             	mov    %rdx,%rsi
  8026ee:	89 c7                	mov    %eax,%edi
  8026f0:	48 b8 f5 25 80 00 00 	movabs $0x8025f5,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
  8026fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802702:	89 c7                	mov    %eax,%edi
  802704:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
	return r;
  802710:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802713:	c9                   	leaveq 
  802714:	c3                   	retq   

0000000000802715 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802715:	55                   	push   %rbp
  802716:	48 89 e5             	mov    %rsp,%rbp
  802719:	48 83 ec 10          	sub    $0x10,%rsp
  80271d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802720:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802724:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80272b:	00 00 00 
  80272e:	8b 00                	mov    (%rax),%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	75 1d                	jne    802751 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802734:	bf 01 00 00 00       	mov    $0x1,%edi
  802739:	48 b8 cc 37 80 00 00 	movabs $0x8037cc,%rax
  802740:	00 00 00 
  802743:	ff d0                	callq  *%rax
  802745:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80274c:	00 00 00 
  80274f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802751:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802758:	00 00 00 
  80275b:	8b 00                	mov    (%rax),%eax
  80275d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802760:	b9 07 00 00 00       	mov    $0x7,%ecx
  802765:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80276c:	00 00 00 
  80276f:	89 c7                	mov    %eax,%edi
  802771:	48 b8 34 37 80 00 00 	movabs $0x803734,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80277d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802781:	ba 00 00 00 00       	mov    $0x0,%edx
  802786:	48 89 c6             	mov    %rax,%rsi
  802789:	bf 00 00 00 00       	mov    $0x0,%edi
  80278e:	48 b8 73 36 80 00 00 	movabs $0x803673,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
}
  80279a:	c9                   	leaveq 
  80279b:	c3                   	retq   

000000000080279c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80279c:	55                   	push   %rbp
  80279d:	48 89 e5             	mov    %rsp,%rbp
  8027a0:	48 83 ec 20          	sub    $0x20,%rsp
  8027a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027a8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027af:	48 89 c7             	mov    %rax,%rdi
  8027b2:	48 b8 a6 11 80 00 00 	movabs $0x8011a6,%rax
  8027b9:	00 00 00 
  8027bc:	ff d0                	callq  *%rax
  8027be:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027c3:	7e 0a                	jle    8027cf <open+0x33>
		return -E_BAD_PATH;
  8027c5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027ca:	e9 a5 00 00 00       	jmpq   802874 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8027cf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027d3:	48 89 c7             	mov    %rax,%rdi
  8027d6:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
  8027e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e9:	79 08                	jns    8027f3 <open+0x57>
		return r;
  8027eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ee:	e9 81 00 00 00       	jmpq   802874 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8027f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f7:	48 89 c6             	mov    %rax,%rsi
  8027fa:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802801:	00 00 00 
  802804:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  80280b:	00 00 00 
  80280e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802810:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802817:	00 00 00 
  80281a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80281d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802827:	48 89 c6             	mov    %rax,%rsi
  80282a:	bf 01 00 00 00       	mov    $0x1,%edi
  80282f:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802836:	00 00 00 
  802839:	ff d0                	callq  *%rax
  80283b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802842:	79 1d                	jns    802861 <open+0xc5>
		fd_close(fd, 0);
  802844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802848:	be 00 00 00 00       	mov    $0x0,%esi
  80284d:	48 89 c7             	mov    %rax,%rdi
  802850:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
		return r;
  80285c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285f:	eb 13                	jmp    802874 <open+0xd8>
	}

	return fd2num(fd);
  802861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802865:	48 89 c7             	mov    %rax,%rdi
  802868:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802874:	c9                   	leaveq 
  802875:	c3                   	retq   

0000000000802876 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802876:	55                   	push   %rbp
  802877:	48 89 e5             	mov    %rsp,%rbp
  80287a:	48 83 ec 10          	sub    $0x10,%rsp
  80287e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802886:	8b 50 0c             	mov    0xc(%rax),%edx
  802889:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802890:	00 00 00 
  802893:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802895:	be 00 00 00 00       	mov    $0x0,%esi
  80289a:	bf 06 00 00 00       	mov    $0x6,%edi
  80289f:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
}
  8028ab:	c9                   	leaveq 
  8028ac:	c3                   	retq   

00000000008028ad <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028ad:	55                   	push   %rbp
  8028ae:	48 89 e5             	mov    %rsp,%rbp
  8028b1:	48 83 ec 30          	sub    $0x30,%rsp
  8028b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028cf:	00 00 00 
  8028d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028d4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028db:	00 00 00 
  8028de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028e6:	be 00 00 00 00       	mov    $0x0,%esi
  8028eb:	bf 03 00 00 00       	mov    $0x3,%edi
  8028f0:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  8028f7:	00 00 00 
  8028fa:	ff d0                	callq  *%rax
  8028fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802903:	79 08                	jns    80290d <devfile_read+0x60>
		return r;
  802905:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802908:	e9 a4 00 00 00       	jmpq   8029b1 <devfile_read+0x104>
	assert(r <= n);
  80290d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802910:	48 98                	cltq   
  802912:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802916:	76 35                	jbe    80294d <devfile_read+0xa0>
  802918:	48 b9 1d 3f 80 00 00 	movabs $0x803f1d,%rcx
  80291f:	00 00 00 
  802922:	48 ba 24 3f 80 00 00 	movabs $0x803f24,%rdx
  802929:	00 00 00 
  80292c:	be 84 00 00 00       	mov    $0x84,%esi
  802931:	48 bf 39 3f 80 00 00 	movabs $0x803f39,%rdi
  802938:	00 00 00 
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
  802940:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  802947:	00 00 00 
  80294a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80294d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802954:	7e 35                	jle    80298b <devfile_read+0xde>
  802956:	48 b9 44 3f 80 00 00 	movabs $0x803f44,%rcx
  80295d:	00 00 00 
  802960:	48 ba 24 3f 80 00 00 	movabs $0x803f24,%rdx
  802967:	00 00 00 
  80296a:	be 85 00 00 00       	mov    $0x85,%esi
  80296f:	48 bf 39 3f 80 00 00 	movabs $0x803f39,%rdi
  802976:	00 00 00 
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
  80297e:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  802985:	00 00 00 
  802988:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80298b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298e:	48 63 d0             	movslq %eax,%rdx
  802991:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802995:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80299c:	00 00 00 
  80299f:	48 89 c7             	mov    %rax,%rdi
  8029a2:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
	return r;
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 30          	sub    $0x30,%rsp
  8029bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ce:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029d5:	00 00 00 
  8029d8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8029da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029e1:	00 00 00 
  8029e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029e8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8029ec:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029f3:	00 
  8029f4:	76 35                	jbe    802a2b <devfile_write+0x78>
  8029f6:	48 b9 50 3f 80 00 00 	movabs $0x803f50,%rcx
  8029fd:	00 00 00 
  802a00:	48 ba 24 3f 80 00 00 	movabs $0x803f24,%rdx
  802a07:	00 00 00 
  802a0a:	be 9e 00 00 00       	mov    $0x9e,%esi
  802a0f:	48 bf 39 3f 80 00 00 	movabs $0x803f39,%rdi
  802a16:	00 00 00 
  802a19:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1e:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  802a25:	00 00 00 
  802a28:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802a2b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a33:	48 89 c6             	mov    %rax,%rsi
  802a36:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802a3d:	00 00 00 
  802a40:	48 b8 4d 16 80 00 00 	movabs $0x80164d,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a4c:	be 00 00 00 00       	mov    $0x0,%esi
  802a51:	bf 04 00 00 00       	mov    $0x4,%edi
  802a56:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802a5d:	00 00 00 
  802a60:	ff d0                	callq  *%rax
  802a62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a69:	79 05                	jns    802a70 <devfile_write+0xbd>
		return r;
  802a6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6e:	eb 43                	jmp    802ab3 <devfile_write+0x100>
	assert(r <= n);
  802a70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a73:	48 98                	cltq   
  802a75:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a79:	76 35                	jbe    802ab0 <devfile_write+0xfd>
  802a7b:	48 b9 1d 3f 80 00 00 	movabs $0x803f1d,%rcx
  802a82:	00 00 00 
  802a85:	48 ba 24 3f 80 00 00 	movabs $0x803f24,%rdx
  802a8c:	00 00 00 
  802a8f:	be a2 00 00 00       	mov    $0xa2,%esi
  802a94:	48 bf 39 3f 80 00 00 	movabs $0x803f39,%rdi
  802a9b:	00 00 00 
  802a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa3:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  802aaa:	00 00 00 
  802aad:	41 ff d0             	callq  *%r8
	return r;
  802ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 20          	sub    $0x20,%rsp
  802abd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ac1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac9:	8b 50 0c             	mov    0xc(%rax),%edx
  802acc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ad3:	00 00 00 
  802ad6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ad8:	be 00 00 00 00       	mov    $0x0,%esi
  802add:	bf 05 00 00 00       	mov    $0x5,%edi
  802ae2:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
  802aee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af5:	79 05                	jns    802afc <devfile_stat+0x47>
		return r;
  802af7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afa:	eb 56                	jmp    802b52 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b00:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b07:	00 00 00 
  802b0a:	48 89 c7             	mov    %rax,%rdi
  802b0d:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b19:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b20:	00 00 00 
  802b23:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b33:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b3a:	00 00 00 
  802b3d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b47:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b52:	c9                   	leaveq 
  802b53:	c3                   	retq   

0000000000802b54 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b54:	55                   	push   %rbp
  802b55:	48 89 e5             	mov    %rsp,%rbp
  802b58:	48 83 ec 10          	sub    $0x10,%rsp
  802b5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b60:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b67:	8b 50 0c             	mov    0xc(%rax),%edx
  802b6a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b71:	00 00 00 
  802b74:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b76:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b7d:	00 00 00 
  802b80:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b86:	be 00 00 00 00       	mov    $0x0,%esi
  802b8b:	bf 02 00 00 00       	mov    $0x2,%edi
  802b90:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802b97:	00 00 00 
  802b9a:	ff d0                	callq  *%rax
}
  802b9c:	c9                   	leaveq 
  802b9d:	c3                   	retq   

0000000000802b9e <remove>:

// Delete a file
int
remove(const char *path)
{
  802b9e:	55                   	push   %rbp
  802b9f:	48 89 e5             	mov    %rsp,%rbp
  802ba2:	48 83 ec 10          	sub    $0x10,%rsp
  802ba6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802baa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bae:	48 89 c7             	mov    %rax,%rdi
  802bb1:	48 b8 a6 11 80 00 00 	movabs $0x8011a6,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bc2:	7e 07                	jle    802bcb <remove+0x2d>
		return -E_BAD_PATH;
  802bc4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bc9:	eb 33                	jmp    802bfe <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bcf:	48 89 c6             	mov    %rax,%rsi
  802bd2:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802bd9:	00 00 00 
  802bdc:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802be8:	be 00 00 00 00       	mov    $0x0,%esi
  802bed:	bf 07 00 00 00       	mov    $0x7,%edi
  802bf2:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	callq  *%rax
}
  802bfe:	c9                   	leaveq 
  802bff:	c3                   	retq   

0000000000802c00 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c00:	55                   	push   %rbp
  802c01:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c04:	be 00 00 00 00       	mov    $0x0,%esi
  802c09:	bf 08 00 00 00       	mov    $0x8,%edi
  802c0e:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802c15:	00 00 00 
  802c18:	ff d0                	callq  *%rax
}
  802c1a:	5d                   	pop    %rbp
  802c1b:	c3                   	retq   

0000000000802c1c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c1c:	55                   	push   %rbp
  802c1d:	48 89 e5             	mov    %rsp,%rbp
  802c20:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c27:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c2e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c35:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c3c:	be 00 00 00 00       	mov    $0x0,%esi
  802c41:	48 89 c7             	mov    %rax,%rdi
  802c44:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
  802c50:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c57:	79 28                	jns    802c81 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5c:	89 c6                	mov    %eax,%esi
  802c5e:	48 bf 7d 3f 80 00 00 	movabs $0x803f7d,%rdi
  802c65:	00 00 00 
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	48 ba 4a 06 80 00 00 	movabs $0x80064a,%rdx
  802c74:	00 00 00 
  802c77:	ff d2                	callq  *%rdx
		return fd_src;
  802c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7c:	e9 74 01 00 00       	jmpq   802df5 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c81:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c88:	be 01 01 00 00       	mov    $0x101,%esi
  802c8d:	48 89 c7             	mov    %rax,%rdi
  802c90:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ca3:	79 39                	jns    802cde <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ca5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca8:	89 c6                	mov    %eax,%esi
  802caa:	48 bf 93 3f 80 00 00 	movabs $0x803f93,%rdi
  802cb1:	00 00 00 
  802cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb9:	48 ba 4a 06 80 00 00 	movabs $0x80064a,%rdx
  802cc0:	00 00 00 
  802cc3:	ff d2                	callq  *%rdx
		close(fd_src);
  802cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc8:	89 c7                	mov    %eax,%edi
  802cca:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
		return fd_dest;
  802cd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd9:	e9 17 01 00 00       	jmpq   802df5 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cde:	eb 74                	jmp    802d54 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ce0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce3:	48 63 d0             	movslq %eax,%rdx
  802ce6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ced:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf0:	48 89 ce             	mov    %rcx,%rsi
  802cf3:	89 c7                	mov    %eax,%edi
  802cf5:	48 b8 10 24 80 00 00 	movabs $0x802410,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
  802d01:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d04:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d08:	79 4a                	jns    802d54 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d0a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d0d:	89 c6                	mov    %eax,%esi
  802d0f:	48 bf ad 3f 80 00 00 	movabs $0x803fad,%rdi
  802d16:	00 00 00 
  802d19:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1e:	48 ba 4a 06 80 00 00 	movabs $0x80064a,%rdx
  802d25:	00 00 00 
  802d28:	ff d2                	callq  *%rdx
			close(fd_src);
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2d:	89 c7                	mov    %eax,%edi
  802d2f:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802d36:	00 00 00 
  802d39:	ff d0                	callq  *%rax
			close(fd_dest);
  802d3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3e:	89 c7                	mov    %eax,%edi
  802d40:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802d47:	00 00 00 
  802d4a:	ff d0                	callq  *%rax
			return write_size;
  802d4c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d4f:	e9 a1 00 00 00       	jmpq   802df5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d54:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5e:	ba 00 02 00 00       	mov    $0x200,%edx
  802d63:	48 89 ce             	mov    %rcx,%rsi
  802d66:	89 c7                	mov    %eax,%edi
  802d68:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax
  802d74:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d7b:	0f 8f 5f ff ff ff    	jg     802ce0 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d85:	79 47                	jns    802dce <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d8a:	89 c6                	mov    %eax,%esi
  802d8c:	48 bf c0 3f 80 00 00 	movabs $0x803fc0,%rdi
  802d93:	00 00 00 
  802d96:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9b:	48 ba 4a 06 80 00 00 	movabs $0x80064a,%rdx
  802da2:	00 00 00 
  802da5:	ff d2                	callq  *%rdx
		close(fd_src);
  802da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802daa:	89 c7                	mov    %eax,%edi
  802dac:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
		close(fd_dest);
  802db8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dbb:	89 c7                	mov    %eax,%edi
  802dbd:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802dc4:	00 00 00 
  802dc7:	ff d0                	callq  *%rax
		return read_size;
  802dc9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dcc:	eb 27                	jmp    802df5 <copy+0x1d9>
	}
	close(fd_src);
  802dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
	close(fd_dest);
  802ddf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de2:	89 c7                	mov    %eax,%edi
  802de4:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
	return 0;
  802df0:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802df5:	c9                   	leaveq 
  802df6:	c3                   	retq   

0000000000802df7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802df7:	55                   	push   %rbp
  802df8:	48 89 e5             	mov    %rsp,%rbp
  802dfb:	53                   	push   %rbx
  802dfc:	48 83 ec 38          	sub    $0x38,%rsp
  802e00:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802e04:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802e08:	48 89 c7             	mov    %rax,%rdi
  802e0b:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e1e:	0f 88 bf 01 00 00    	js     802fe3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e28:	ba 07 04 00 00       	mov    $0x407,%edx
  802e2d:	48 89 c6             	mov    %rax,%rsi
  802e30:	bf 00 00 00 00       	mov    $0x0,%edi
  802e35:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  802e3c:	00 00 00 
  802e3f:	ff d0                	callq  *%rax
  802e41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e48:	0f 88 95 01 00 00    	js     802fe3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802e4e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802e52:	48 89 c7             	mov    %rax,%rdi
  802e55:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  802e5c:	00 00 00 
  802e5f:	ff d0                	callq  *%rax
  802e61:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e64:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e68:	0f 88 5d 01 00 00    	js     802fcb <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e72:	ba 07 04 00 00       	mov    $0x407,%edx
  802e77:	48 89 c6             	mov    %rax,%rsi
  802e7a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e7f:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  802e86:	00 00 00 
  802e89:	ff d0                	callq  *%rax
  802e8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e92:	0f 88 33 01 00 00    	js     802fcb <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9c:	48 89 c7             	mov    %rax,%rdi
  802e9f:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
  802eab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eaf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eb3:	ba 07 04 00 00       	mov    $0x407,%edx
  802eb8:	48 89 c6             	mov    %rax,%rsi
  802ebb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec0:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ecf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ed3:	79 05                	jns    802eda <pipe+0xe3>
		goto err2;
  802ed5:	e9 d9 00 00 00       	jmpq   802fb3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ede:	48 89 c7             	mov    %rax,%rdi
  802ee1:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	48 89 c2             	mov    %rax,%rdx
  802ef0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802efa:	48 89 d1             	mov    %rdx,%rcx
  802efd:	ba 00 00 00 00       	mov    $0x0,%edx
  802f02:	48 89 c6             	mov    %rax,%rsi
  802f05:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0a:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
  802f16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f1d:	79 1b                	jns    802f3a <pipe+0x143>
		goto err3;
  802f1f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802f20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f24:	48 89 c6             	mov    %rax,%rsi
  802f27:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2c:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
  802f38:	eb 79                	jmp    802fb3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802f3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802f45:	00 00 00 
  802f48:	8b 12                	mov    (%rdx),%edx
  802f4a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802f4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802f57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f5b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802f62:	00 00 00 
  802f65:	8b 12                	mov    (%rdx),%edx
  802f67:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802f69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f6d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802f74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f78:	48 89 c7             	mov    %rax,%rdi
  802f7b:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	89 c2                	mov    %eax,%edx
  802f89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f8d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802f8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f93:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802f97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f9b:	48 89 c7             	mov    %rax,%rdi
  802f9e:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
  802faa:	89 03                	mov    %eax,(%rbx)
	return 0;
  802fac:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb1:	eb 33                	jmp    802fe6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802fb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb7:	48 89 c6             	mov    %rax,%rsi
  802fba:	bf 00 00 00 00       	mov    $0x0,%edi
  802fbf:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  802fc6:	00 00 00 
  802fc9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcf:	48 89 c6             	mov    %rax,%rsi
  802fd2:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd7:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
err:
	return r;
  802fe3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802fe6:	48 83 c4 38          	add    $0x38,%rsp
  802fea:	5b                   	pop    %rbx
  802feb:	5d                   	pop    %rbp
  802fec:	c3                   	retq   

0000000000802fed <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802fed:	55                   	push   %rbp
  802fee:	48 89 e5             	mov    %rsp,%rbp
  802ff1:	53                   	push   %rbx
  802ff2:	48 83 ec 28          	sub    $0x28,%rsp
  802ff6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ffa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802ffe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803005:	00 00 00 
  803008:	48 8b 00             	mov    (%rax),%rax
  80300b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803011:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803018:	48 89 c7             	mov    %rax,%rdi
  80301b:	48 b8 4e 38 80 00 00 	movabs $0x80384e,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
  803027:	89 c3                	mov    %eax,%ebx
  803029:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80302d:	48 89 c7             	mov    %rax,%rdi
  803030:	48 b8 4e 38 80 00 00 	movabs $0x80384e,%rax
  803037:	00 00 00 
  80303a:	ff d0                	callq  *%rax
  80303c:	39 c3                	cmp    %eax,%ebx
  80303e:	0f 94 c0             	sete   %al
  803041:	0f b6 c0             	movzbl %al,%eax
  803044:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803047:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80304e:	00 00 00 
  803051:	48 8b 00             	mov    (%rax),%rax
  803054:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80305a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80305d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803060:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803063:	75 05                	jne    80306a <_pipeisclosed+0x7d>
			return ret;
  803065:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803068:	eb 4f                	jmp    8030b9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80306a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80306d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803070:	74 42                	je     8030b4 <_pipeisclosed+0xc7>
  803072:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803076:	75 3c                	jne    8030b4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803078:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80307f:	00 00 00 
  803082:	48 8b 00             	mov    (%rax),%rax
  803085:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80308b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80308e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803091:	89 c6                	mov    %eax,%esi
  803093:	48 bf db 3f 80 00 00 	movabs $0x803fdb,%rdi
  80309a:	00 00 00 
  80309d:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a2:	49 b8 4a 06 80 00 00 	movabs $0x80064a,%r8
  8030a9:	00 00 00 
  8030ac:	41 ff d0             	callq  *%r8
	}
  8030af:	e9 4a ff ff ff       	jmpq   802ffe <_pipeisclosed+0x11>
  8030b4:	e9 45 ff ff ff       	jmpq   802ffe <_pipeisclosed+0x11>
}
  8030b9:	48 83 c4 28          	add    $0x28,%rsp
  8030bd:	5b                   	pop    %rbx
  8030be:	5d                   	pop    %rbp
  8030bf:	c3                   	retq   

00000000008030c0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8030c0:	55                   	push   %rbp
  8030c1:	48 89 e5             	mov    %rsp,%rbp
  8030c4:	48 83 ec 30          	sub    $0x30,%rsp
  8030c8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030d2:	48 89 d6             	mov    %rdx,%rsi
  8030d5:	89 c7                	mov    %eax,%edi
  8030d7:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  8030de:	00 00 00 
  8030e1:	ff d0                	callq  *%rax
  8030e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ea:	79 05                	jns    8030f1 <pipeisclosed+0x31>
		return r;
  8030ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ef:	eb 31                	jmp    803122 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8030f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f5:	48 89 c7             	mov    %rax,%rdi
  8030f8:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  8030ff:	00 00 00 
  803102:	ff d0                	callq  *%rax
  803104:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803110:	48 89 d6             	mov    %rdx,%rsi
  803113:	48 89 c7             	mov    %rax,%rdi
  803116:	48 b8 ed 2f 80 00 00 	movabs $0x802fed,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
}
  803122:	c9                   	leaveq 
  803123:	c3                   	retq   

0000000000803124 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803124:	55                   	push   %rbp
  803125:	48 89 e5             	mov    %rsp,%rbp
  803128:	48 83 ec 40          	sub    $0x40,%rsp
  80312c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803130:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803134:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803138:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80313c:	48 89 c7             	mov    %rax,%rdi
  80313f:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
  80314b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80314f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803153:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803157:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80315e:	00 
  80315f:	e9 92 00 00 00       	jmpq   8031f6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803164:	eb 41                	jmp    8031a7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803166:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80316b:	74 09                	je     803176 <devpipe_read+0x52>
				return i;
  80316d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803171:	e9 92 00 00 00       	jmpq   803208 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803176:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80317a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317e:	48 89 d6             	mov    %rdx,%rsi
  803181:	48 89 c7             	mov    %rax,%rdi
  803184:	48 b8 ed 2f 80 00 00 	movabs $0x802fed,%rax
  80318b:	00 00 00 
  80318e:	ff d0                	callq  *%rax
  803190:	85 c0                	test   %eax,%eax
  803192:	74 07                	je     80319b <devpipe_read+0x77>
				return 0;
  803194:	b8 00 00 00 00       	mov    $0x0,%eax
  803199:	eb 6d                	jmp    803208 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80319b:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  8031a2:	00 00 00 
  8031a5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8031a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ab:	8b 10                	mov    (%rax),%edx
  8031ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b1:	8b 40 04             	mov    0x4(%rax),%eax
  8031b4:	39 c2                	cmp    %eax,%edx
  8031b6:	74 ae                	je     803166 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8031b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031c0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8031c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c8:	8b 00                	mov    (%rax),%eax
  8031ca:	99                   	cltd   
  8031cb:	c1 ea 1b             	shr    $0x1b,%edx
  8031ce:	01 d0                	add    %edx,%eax
  8031d0:	83 e0 1f             	and    $0x1f,%eax
  8031d3:	29 d0                	sub    %edx,%eax
  8031d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031d9:	48 98                	cltq   
  8031db:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8031e0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8031e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e6:	8b 00                	mov    (%rax),%eax
  8031e8:	8d 50 01             	lea    0x1(%rax),%edx
  8031eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ef:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8031f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8031f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031fa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8031fe:	0f 82 60 ff ff ff    	jb     803164 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803208:	c9                   	leaveq 
  803209:	c3                   	retq   

000000000080320a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80320a:	55                   	push   %rbp
  80320b:	48 89 e5             	mov    %rsp,%rbp
  80320e:	48 83 ec 40          	sub    $0x40,%rsp
  803212:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803216:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80321a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80321e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803222:	48 89 c7             	mov    %rax,%rdi
  803225:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803235:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803239:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80323d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803244:	00 
  803245:	e9 8e 00 00 00       	jmpq   8032d8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80324a:	eb 31                	jmp    80327d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80324c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803254:	48 89 d6             	mov    %rdx,%rsi
  803257:	48 89 c7             	mov    %rax,%rdi
  80325a:	48 b8 ed 2f 80 00 00 	movabs $0x802fed,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	85 c0                	test   %eax,%eax
  803268:	74 07                	je     803271 <devpipe_write+0x67>
				return 0;
  80326a:	b8 00 00 00 00       	mov    $0x0,%eax
  80326f:	eb 79                	jmp    8032ea <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803271:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  803278:	00 00 00 
  80327b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80327d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803281:	8b 40 04             	mov    0x4(%rax),%eax
  803284:	48 63 d0             	movslq %eax,%rdx
  803287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328b:	8b 00                	mov    (%rax),%eax
  80328d:	48 98                	cltq   
  80328f:	48 83 c0 20          	add    $0x20,%rax
  803293:	48 39 c2             	cmp    %rax,%rdx
  803296:	73 b4                	jae    80324c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329c:	8b 40 04             	mov    0x4(%rax),%eax
  80329f:	99                   	cltd   
  8032a0:	c1 ea 1b             	shr    $0x1b,%edx
  8032a3:	01 d0                	add    %edx,%eax
  8032a5:	83 e0 1f             	and    $0x1f,%eax
  8032a8:	29 d0                	sub    %edx,%eax
  8032aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8032ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8032b2:	48 01 ca             	add    %rcx,%rdx
  8032b5:	0f b6 0a             	movzbl (%rdx),%ecx
  8032b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032bc:	48 98                	cltq   
  8032be:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8032c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c6:	8b 40 04             	mov    0x4(%rax),%eax
  8032c9:	8d 50 01             	lea    0x1(%rax),%edx
  8032cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032dc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032e0:	0f 82 64 ff ff ff    	jb     80324a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8032e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8032ea:	c9                   	leaveq 
  8032eb:	c3                   	retq   

00000000008032ec <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8032ec:	55                   	push   %rbp
  8032ed:	48 89 e5             	mov    %rsp,%rbp
  8032f0:	48 83 ec 20          	sub    $0x20,%rsp
  8032f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8032fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803300:	48 89 c7             	mov    %rax,%rdi
  803303:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  80330a:	00 00 00 
  80330d:	ff d0                	callq  *%rax
  80330f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803317:	48 be ee 3f 80 00 00 	movabs $0x803fee,%rsi
  80331e:	00 00 00 
  803321:	48 89 c7             	mov    %rax,%rdi
  803324:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803334:	8b 50 04             	mov    0x4(%rax),%edx
  803337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80333b:	8b 00                	mov    (%rax),%eax
  80333d:	29 c2                	sub    %eax,%edx
  80333f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803343:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803349:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803354:	00 00 00 
	stat->st_dev = &devpipe;
  803357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335b:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803362:	00 00 00 
  803365:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80336c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803371:	c9                   	leaveq 
  803372:	c3                   	retq   

0000000000803373 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803373:	55                   	push   %rbp
  803374:	48 89 e5             	mov    %rsp,%rbp
  803377:	48 83 ec 10          	sub    $0x10,%rsp
  80337b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80337f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803383:	48 89 c6             	mov    %rax,%rsi
  803386:	bf 00 00 00 00       	mov    $0x0,%edi
  80338b:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339b:	48 89 c7             	mov    %rax,%rdi
  80339e:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
  8033aa:	48 89 c6             	mov    %rax,%rsi
  8033ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b2:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
}
  8033be:	c9                   	leaveq 
  8033bf:	c3                   	retq   

00000000008033c0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	48 83 ec 20          	sub    $0x20,%rsp
  8033c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8033cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ce:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8033d1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8033d5:	be 01 00 00 00       	mov    $0x1,%esi
  8033da:	48 89 c7             	mov    %rax,%rdi
  8033dd:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <getchar>:

int
getchar(void)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8033f3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8033f7:	ba 01 00 00 00       	mov    $0x1,%edx
  8033fc:	48 89 c6             	mov    %rax,%rsi
  8033ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803404:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  80340b:	00 00 00 
  80340e:	ff d0                	callq  *%rax
  803410:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803417:	79 05                	jns    80341e <getchar+0x33>
		return r;
  803419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341c:	eb 14                	jmp    803432 <getchar+0x47>
	if (r < 1)
  80341e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803422:	7f 07                	jg     80342b <getchar+0x40>
		return -E_EOF;
  803424:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803429:	eb 07                	jmp    803432 <getchar+0x47>
	return c;
  80342b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80342f:	0f b6 c0             	movzbl %al,%eax
}
  803432:	c9                   	leaveq 
  803433:	c3                   	retq   

0000000000803434 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803434:	55                   	push   %rbp
  803435:	48 89 e5             	mov    %rsp,%rbp
  803438:	48 83 ec 20          	sub    $0x20,%rsp
  80343c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80343f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803443:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803446:	48 89 d6             	mov    %rdx,%rsi
  803449:	89 c7                	mov    %eax,%edi
  80344b:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
  803457:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345e:	79 05                	jns    803465 <iscons+0x31>
		return r;
  803460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803463:	eb 1a                	jmp    80347f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803469:	8b 10                	mov    (%rax),%edx
  80346b:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803472:	00 00 00 
  803475:	8b 00                	mov    (%rax),%eax
  803477:	39 c2                	cmp    %eax,%edx
  803479:	0f 94 c0             	sete   %al
  80347c:	0f b6 c0             	movzbl %al,%eax
}
  80347f:	c9                   	leaveq 
  803480:	c3                   	retq   

0000000000803481 <opencons>:

int
opencons(void)
{
  803481:	55                   	push   %rbp
  803482:	48 89 e5             	mov    %rsp,%rbp
  803485:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803489:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80348d:	48 89 c7             	mov    %rax,%rdi
  803490:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
  80349c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a3:	79 05                	jns    8034aa <opencons+0x29>
		return r;
  8034a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a8:	eb 5b                	jmp    803505 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8034aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8034b3:	48 89 c6             	mov    %rax,%rsi
  8034b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8034bb:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
  8034c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ce:	79 05                	jns    8034d5 <opencons+0x54>
		return r;
  8034d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d3:	eb 30                	jmp    803505 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8034d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d9:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8034e0:	00 00 00 
  8034e3:	8b 12                	mov    (%rdx),%edx
  8034e5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8034e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8034f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f6:	48 89 c7             	mov    %rax,%rdi
  8034f9:	48 b8 ae 1d 80 00 00 	movabs $0x801dae,%rax
  803500:	00 00 00 
  803503:	ff d0                	callq  *%rax
}
  803505:	c9                   	leaveq 
  803506:	c3                   	retq   

0000000000803507 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803507:	55                   	push   %rbp
  803508:	48 89 e5             	mov    %rsp,%rbp
  80350b:	48 83 ec 30          	sub    $0x30,%rsp
  80350f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803513:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803517:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80351b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803520:	75 07                	jne    803529 <devcons_read+0x22>
		return 0;
  803522:	b8 00 00 00 00       	mov    $0x0,%eax
  803527:	eb 4b                	jmp    803574 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803529:	eb 0c                	jmp    803537 <devcons_read+0x30>
		sys_yield();
  80352b:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803537:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  80353e:	00 00 00 
  803541:	ff d0                	callq  *%rax
  803543:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354a:	74 df                	je     80352b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80354c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803550:	79 05                	jns    803557 <devcons_read+0x50>
		return c;
  803552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803555:	eb 1d                	jmp    803574 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803557:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80355b:	75 07                	jne    803564 <devcons_read+0x5d>
		return 0;
  80355d:	b8 00 00 00 00       	mov    $0x0,%eax
  803562:	eb 10                	jmp    803574 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803567:	89 c2                	mov    %eax,%edx
  803569:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356d:	88 10                	mov    %dl,(%rax)
	return 1;
  80356f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803574:	c9                   	leaveq 
  803575:	c3                   	retq   

0000000000803576 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803576:	55                   	push   %rbp
  803577:	48 89 e5             	mov    %rsp,%rbp
  80357a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803581:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803588:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80358f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803596:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80359d:	eb 76                	jmp    803615 <devcons_write+0x9f>
		m = n - tot;
  80359f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8035a6:	89 c2                	mov    %eax,%edx
  8035a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ab:	29 c2                	sub    %eax,%edx
  8035ad:	89 d0                	mov    %edx,%eax
  8035af:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8035b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035b5:	83 f8 7f             	cmp    $0x7f,%eax
  8035b8:	76 07                	jbe    8035c1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8035ba:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8035c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c4:	48 63 d0             	movslq %eax,%rdx
  8035c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ca:	48 63 c8             	movslq %eax,%rcx
  8035cd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8035d4:	48 01 c1             	add    %rax,%rcx
  8035d7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8035de:	48 89 ce             	mov    %rcx,%rsi
  8035e1:	48 89 c7             	mov    %rax,%rdi
  8035e4:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8035f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f3:	48 63 d0             	movslq %eax,%rdx
  8035f6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8035fd:	48 89 d6             	mov    %rdx,%rsi
  803600:	48 89 c7             	mov    %rax,%rdi
  803603:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80360f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803612:	01 45 fc             	add    %eax,-0x4(%rbp)
  803615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803618:	48 98                	cltq   
  80361a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803621:	0f 82 78 ff ff ff    	jb     80359f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803627:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80362a:	c9                   	leaveq 
  80362b:	c3                   	retq   

000000000080362c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80362c:	55                   	push   %rbp
  80362d:	48 89 e5             	mov    %rsp,%rbp
  803630:	48 83 ec 08          	sub    $0x8,%rsp
  803634:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803638:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80363d:	c9                   	leaveq 
  80363e:	c3                   	retq   

000000000080363f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80363f:	55                   	push   %rbp
  803640:	48 89 e5             	mov    %rsp,%rbp
  803643:	48 83 ec 10          	sub    $0x10,%rsp
  803647:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80364b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80364f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803653:	48 be fa 3f 80 00 00 	movabs $0x803ffa,%rsi
  80365a:	00 00 00 
  80365d:	48 89 c7             	mov    %rax,%rdi
  803660:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  803667:	00 00 00 
  80366a:	ff d0                	callq  *%rax
	return 0;
  80366c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803671:	c9                   	leaveq 
  803672:	c3                   	retq   

0000000000803673 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803673:	55                   	push   %rbp
  803674:	48 89 e5             	mov    %rsp,%rbp
  803677:	48 83 ec 30          	sub    $0x30,%rsp
  80367b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80367f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803683:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803687:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80368c:	75 0e                	jne    80369c <ipc_recv+0x29>
        pg = (void *)UTOP;
  80368e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803695:	00 00 00 
  803698:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  80369c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a0:	48 89 c7             	mov    %rax,%rdi
  8036a3:	48 b8 6a 1d 80 00 00 	movabs $0x801d6a,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
  8036af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b6:	79 27                	jns    8036df <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8036b8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036bd:	74 0a                	je     8036c9 <ipc_recv+0x56>
            *from_env_store = 0;
  8036bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8036c9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8036ce:	74 0a                	je     8036da <ipc_recv+0x67>
            *perm_store = 0;
  8036d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8036da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036dd:	eb 53                	jmp    803732 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8036df:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036e4:	74 19                	je     8036ff <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8036e6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8036ed:	00 00 00 
  8036f0:	48 8b 00             	mov    (%rax),%rax
  8036f3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8036f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036fd:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8036ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803704:	74 19                	je     80371f <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803706:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80370d:	00 00 00 
  803710:	48 8b 00             	mov    (%rax),%rax
  803713:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371d:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80371f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803726:	00 00 00 
  803729:	48 8b 00             	mov    (%rax),%rax
  80372c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803732:	c9                   	leaveq 
  803733:	c3                   	retq   

0000000000803734 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803734:	55                   	push   %rbp
  803735:	48 89 e5             	mov    %rsp,%rbp
  803738:	48 83 ec 30          	sub    $0x30,%rsp
  80373c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80373f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803742:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803746:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803749:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80374e:	75 0e                	jne    80375e <ipc_send+0x2a>
        pg = (void *)UTOP;
  803750:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803757:	00 00 00 
  80375a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  80375e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803761:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803764:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376b:	89 c7                	mov    %eax,%edi
  80376d:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
  803779:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  80377c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803780:	79 36                	jns    8037b8 <ipc_send+0x84>
  803782:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803786:	74 30                	je     8037b8 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378b:	89 c1                	mov    %eax,%ecx
  80378d:	48 ba 01 40 80 00 00 	movabs $0x804001,%rdx
  803794:	00 00 00 
  803797:	be 49 00 00 00       	mov    $0x49,%esi
  80379c:	48 bf 0e 40 80 00 00 	movabs $0x80400e,%rdi
  8037a3:	00 00 00 
  8037a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ab:	49 b8 11 04 80 00 00 	movabs $0x800411,%r8
  8037b2:	00 00 00 
  8037b5:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8037b8:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
    } while(r != 0);
  8037c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c8:	75 94                	jne    80375e <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8037ca:	c9                   	leaveq 
  8037cb:	c3                   	retq   

00000000008037cc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8037cc:	55                   	push   %rbp
  8037cd:	48 89 e5             	mov    %rsp,%rbp
  8037d0:	48 83 ec 14          	sub    $0x14,%rsp
  8037d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8037d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037de:	eb 5e                	jmp    80383e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8037e0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8037e7:	00 00 00 
  8037ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ed:	48 63 d0             	movslq %eax,%rdx
  8037f0:	48 89 d0             	mov    %rdx,%rax
  8037f3:	48 c1 e0 03          	shl    $0x3,%rax
  8037f7:	48 01 d0             	add    %rdx,%rax
  8037fa:	48 c1 e0 05          	shl    $0x5,%rax
  8037fe:	48 01 c8             	add    %rcx,%rax
  803801:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803807:	8b 00                	mov    (%rax),%eax
  803809:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80380c:	75 2c                	jne    80383a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80380e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803815:	00 00 00 
  803818:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381b:	48 63 d0             	movslq %eax,%rdx
  80381e:	48 89 d0             	mov    %rdx,%rax
  803821:	48 c1 e0 03          	shl    $0x3,%rax
  803825:	48 01 d0             	add    %rdx,%rax
  803828:	48 c1 e0 05          	shl    $0x5,%rax
  80382c:	48 01 c8             	add    %rcx,%rax
  80382f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803835:	8b 40 08             	mov    0x8(%rax),%eax
  803838:	eb 12                	jmp    80384c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80383a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80383e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803845:	7e 99                	jle    8037e0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80384c:	c9                   	leaveq 
  80384d:	c3                   	retq   

000000000080384e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80384e:	55                   	push   %rbp
  80384f:	48 89 e5             	mov    %rsp,%rbp
  803852:	48 83 ec 18          	sub    $0x18,%rsp
  803856:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80385a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80385e:	48 c1 e8 15          	shr    $0x15,%rax
  803862:	48 89 c2             	mov    %rax,%rdx
  803865:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80386c:	01 00 00 
  80386f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803873:	83 e0 01             	and    $0x1,%eax
  803876:	48 85 c0             	test   %rax,%rax
  803879:	75 07                	jne    803882 <pageref+0x34>
		return 0;
  80387b:	b8 00 00 00 00       	mov    $0x0,%eax
  803880:	eb 53                	jmp    8038d5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803886:	48 c1 e8 0c          	shr    $0xc,%rax
  80388a:	48 89 c2             	mov    %rax,%rdx
  80388d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803894:	01 00 00 
  803897:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80389b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80389f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a3:	83 e0 01             	and    $0x1,%eax
  8038a6:	48 85 c0             	test   %rax,%rax
  8038a9:	75 07                	jne    8038b2 <pageref+0x64>
		return 0;
  8038ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b0:	eb 23                	jmp    8038d5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8038b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8038ba:	48 89 c2             	mov    %rax,%rdx
  8038bd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8038c4:	00 00 00 
  8038c7:	48 c1 e2 04          	shl    $0x4,%rdx
  8038cb:	48 01 d0             	add    %rdx,%rax
  8038ce:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8038d2:	0f b7 c0             	movzwl %ax,%eax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   
