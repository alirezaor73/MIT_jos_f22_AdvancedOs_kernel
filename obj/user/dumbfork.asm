
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
  800070:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf 6d 1d 80 00 00 	movabs $0x801d6d,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 3e 06 80 00 00 	movabs $0x80063e,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 f7 1a 80 00 00 	movabs $0x801af7,%rax
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
  8000f2:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800105:	79 30                	jns    800137 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba 7f 1d 80 00 00 	movabs $0x801d7f,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf 92 1d 80 00 00 	movabs $0x801d92,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 05 04 80 00 00 	movabs $0x800405,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800137:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800144:	b9 00 00 40 00       	mov    $0x400000,%ecx
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 30                	jns    800195 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba a2 1d 80 00 00 	movabs $0x801da2,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf 92 1d 80 00 00 	movabs $0x801d92,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b8 05 04 80 00 00 	movabs $0x800405,%r8
  80018f:	00 00 00 
  800192:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019e:	48 89 c6             	mov    %rax,%rsi
  8001a1:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a6:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bc:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	79 30                	jns    800201 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d4:	89 c1                	mov    %eax,%ecx
  8001d6:	48 ba b3 1d 80 00 00 	movabs $0x801db3,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf 92 1d 80 00 00 	movabs $0x801d92,%rdi
  8001ec:	00 00 00 
  8001ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f4:	49 b8 05 04 80 00 00 	movabs $0x800405,%r8
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
  800226:	48 ba c6 1d 80 00 00 	movabs $0x801dc6,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf 92 1d 80 00 00 	movabs $0x801d92,%rdi
  80023c:	00 00 00 
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	49 b8 05 04 80 00 00 	movabs $0x800405,%r8
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
  800257:	48 b8 b9 1a 80 00 00 	movabs $0x801ab9,%rax
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
  800286:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
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
  8002d1:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
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
  800313:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800326:	79 30                	jns    800358 <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  800328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba d6 1d 80 00 00 	movabs $0x801dd6,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf 92 1d 80 00 00 	movabs $0x801d92,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 05 04 80 00 00 	movabs $0x800405,%r8
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
	envid_t id = sys_getenvid();
  80036c:	48 b8 b9 1a 80 00 00 	movabs $0x801ab9,%rax
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
  8003a1:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8003a8:	00 00 00 
  8003ab:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003b2:	7e 14                	jle    8003c8 <libmain+0x6b>
		binaryname = argv[0];
  8003b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b8:	48 8b 10             	mov    (%rax),%rdx
  8003bb:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  8003f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f7:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
}
  800403:	5d                   	pop    %rbp
  800404:	c3                   	retq   

0000000000800405 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800405:	55                   	push   %rbp
  800406:	48 89 e5             	mov    %rsp,%rbp
  800409:	53                   	push   %rbx
  80040a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800411:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800418:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80041e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800425:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80042c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800433:	84 c0                	test   %al,%al
  800435:	74 23                	je     80045a <_panic+0x55>
  800437:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80043e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800442:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800446:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80044a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80044e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800452:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800456:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80045a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800461:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800468:	00 00 00 
  80046b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800472:	00 00 00 
  800475:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800479:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800480:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800487:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80048e:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800495:	00 00 00 
  800498:	48 8b 18             	mov    (%rax),%rbx
  80049b:	48 b8 b9 1a 80 00 00 	movabs $0x801ab9,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax
  8004a7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004ad:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004b4:	41 89 c8             	mov    %ecx,%r8d
  8004b7:	48 89 d1             	mov    %rdx,%rcx
  8004ba:	48 89 da             	mov    %rbx,%rdx
  8004bd:	89 c6                	mov    %eax,%esi
  8004bf:	48 bf f8 1d 80 00 00 	movabs $0x801df8,%rdi
  8004c6:	00 00 00 
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ce:	49 b9 3e 06 80 00 00 	movabs $0x80063e,%r9
  8004d5:	00 00 00 
  8004d8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004db:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004e9:	48 89 d6             	mov    %rdx,%rsi
  8004ec:	48 89 c7             	mov    %rax,%rdi
  8004ef:	48 b8 92 05 80 00 00 	movabs $0x800592,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
	cprintf("\n");
  8004fb:	48 bf 1b 1e 80 00 00 	movabs $0x801e1b,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 3e 06 80 00 00 	movabs $0x80063e,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800516:	cc                   	int3   
  800517:	eb fd                	jmp    800516 <_panic+0x111>

0000000000800519 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	48 83 ec 10          	sub    $0x10,%rsp
  800521:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800524:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052c:	8b 00                	mov    (%rax),%eax
  80052e:	8d 48 01             	lea    0x1(%rax),%ecx
  800531:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800535:	89 0a                	mov    %ecx,(%rdx)
  800537:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80053a:	89 d1                	mov    %edx,%ecx
  80053c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800540:	48 98                	cltq   
  800542:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800551:	75 2c                	jne    80057f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800557:	8b 00                	mov    (%rax),%eax
  800559:	48 98                	cltq   
  80055b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055f:	48 83 c2 08          	add    $0x8,%rdx
  800563:	48 89 c6             	mov    %rax,%rsi
  800566:	48 89 d7             	mov    %rdx,%rdi
  800569:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  800570:	00 00 00 
  800573:	ff d0                	callq  *%rax
        b->idx = 0;
  800575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800579:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80057f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800583:	8b 40 04             	mov    0x4(%rax),%eax
  800586:	8d 50 01             	lea    0x1(%rax),%edx
  800589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800590:	c9                   	leaveq 
  800591:	c3                   	retq   

0000000000800592 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800592:	55                   	push   %rbp
  800593:	48 89 e5             	mov    %rsp,%rbp
  800596:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80059d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005a4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005ab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005b9:	48 8b 0a             	mov    (%rdx),%rcx
  8005bc:	48 89 08             	mov    %rcx,(%rax)
  8005bf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005cb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005d6:	00 00 00 
    b.cnt = 0;
  8005d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005e3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005f8:	48 89 c6             	mov    %rax,%rsi
  8005fb:	48 bf 19 05 80 00 00 	movabs $0x800519,%rdi
  800602:	00 00 00 
  800605:	48 b8 f1 09 80 00 00 	movabs $0x8009f1,%rax
  80060c:	00 00 00 
  80060f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800611:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800617:	48 98                	cltq   
  800619:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800620:	48 83 c2 08          	add    $0x8,%rdx
  800624:	48 89 c6             	mov    %rax,%rsi
  800627:	48 89 d7             	mov    %rdx,%rdi
  80062a:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  800631:	00 00 00 
  800634:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800636:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80063c:	c9                   	leaveq 
  80063d:	c3                   	retq   

000000000080063e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80063e:	55                   	push   %rbp
  80063f:	48 89 e5             	mov    %rsp,%rbp
  800642:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800649:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800650:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800657:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80065e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800665:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80066c:	84 c0                	test   %al,%al
  80066e:	74 20                	je     800690 <cprintf+0x52>
  800670:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800674:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800678:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80067c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800680:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800684:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800688:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80068c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800690:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800697:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80069e:	00 00 00 
  8006a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006a8:	00 00 00 
  8006ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006c4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d2:	48 8b 0a             	mov    (%rdx),%rcx
  8006d5:	48 89 08             	mov    %rcx,(%rax)
  8006d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006e8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006f6:	48 89 d6             	mov    %rdx,%rsi
  8006f9:	48 89 c7             	mov    %rax,%rdi
  8006fc:	48 b8 92 05 80 00 00 	movabs $0x800592,%rax
  800703:	00 00 00 
  800706:	ff d0                	callq  *%rax
  800708:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80070e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800714:	c9                   	leaveq 
  800715:	c3                   	retq   

0000000000800716 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800716:	55                   	push   %rbp
  800717:	48 89 e5             	mov    %rsp,%rbp
  80071a:	53                   	push   %rbx
  80071b:	48 83 ec 38          	sub    $0x38,%rsp
  80071f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800723:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800727:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80072b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80072e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800732:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800736:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800739:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80073d:	77 3b                	ja     80077a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800742:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800746:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80074d:	ba 00 00 00 00       	mov    $0x0,%edx
  800752:	48 f7 f3             	div    %rbx
  800755:	48 89 c2             	mov    %rax,%rdx
  800758:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80075b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80075e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800766:	41 89 f9             	mov    %edi,%r9d
  800769:	48 89 c7             	mov    %rax,%rdi
  80076c:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800773:	00 00 00 
  800776:	ff d0                	callq  *%rax
  800778:	eb 1e                	jmp    800798 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	eb 12                	jmp    80078e <printnum+0x78>
			putch(padc, putdat);
  80077c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800780:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 89 ce             	mov    %rcx,%rsi
  80078a:	89 d7                	mov    %edx,%edi
  80078c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800792:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800796:	7f e4                	jg     80077c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800798:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80079b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80079f:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a4:	48 f7 f1             	div    %rcx
  8007a7:	48 89 d0             	mov    %rdx,%rax
  8007aa:	48 ba 70 1f 80 00 00 	movabs $0x801f70,%rdx
  8007b1:	00 00 00 
  8007b4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007b8:	0f be d0             	movsbl %al,%edx
  8007bb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 89 ce             	mov    %rcx,%rsi
  8007c6:	89 d7                	mov    %edx,%edi
  8007c8:	ff d0                	callq  *%rax
}
  8007ca:	48 83 c4 38          	add    $0x38,%rsp
  8007ce:	5b                   	pop    %rbx
  8007cf:	5d                   	pop    %rbp
  8007d0:	c3                   	retq   

00000000008007d1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d1:	55                   	push   %rbp
  8007d2:	48 89 e5             	mov    %rsp,%rbp
  8007d5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007dd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007e0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e4:	7e 52                	jle    800838 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	8b 00                	mov    (%rax),%eax
  8007ec:	83 f8 30             	cmp    $0x30,%eax
  8007ef:	73 24                	jae    800815 <getuint+0x44>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	89 c0                	mov    %eax,%eax
  800801:	48 01 d0             	add    %rdx,%rax
  800804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800808:	8b 12                	mov    (%rdx),%edx
  80080a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	89 0a                	mov    %ecx,(%rdx)
  800813:	eb 17                	jmp    80082c <getuint+0x5b>
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081d:	48 89 d0             	mov    %rdx,%rax
  800820:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082c:	48 8b 00             	mov    (%rax),%rax
  80082f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800833:	e9 a3 00 00 00       	jmpq   8008db <getuint+0x10a>
	else if (lflag)
  800838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083c:	74 4f                	je     80088d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80083e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800842:	8b 00                	mov    (%rax),%eax
  800844:	83 f8 30             	cmp    $0x30,%eax
  800847:	73 24                	jae    80086d <getuint+0x9c>
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	89 c0                	mov    %eax,%eax
  800859:	48 01 d0             	add    %rdx,%rax
  80085c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800860:	8b 12                	mov    (%rdx),%edx
  800862:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	89 0a                	mov    %ecx,(%rdx)
  80086b:	eb 17                	jmp    800884 <getuint+0xb3>
  80086d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800871:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800875:	48 89 d0             	mov    %rdx,%rax
  800878:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800880:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800884:	48 8b 00             	mov    (%rax),%rax
  800887:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088b:	eb 4e                	jmp    8008db <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	8b 00                	mov    (%rax),%eax
  800893:	83 f8 30             	cmp    $0x30,%eax
  800896:	73 24                	jae    8008bc <getuint+0xeb>
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	89 c0                	mov    %eax,%eax
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008af:	8b 12                	mov    (%rdx),%edx
  8008b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b8:	89 0a                	mov    %ecx,(%rdx)
  8008ba:	eb 17                	jmp    8008d3 <getuint+0x102>
  8008bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c4:	48 89 d0             	mov    %rdx,%rax
  8008c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d3:	8b 00                	mov    (%rax),%eax
  8008d5:	89 c0                	mov    %eax,%eax
  8008d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008df:	c9                   	leaveq 
  8008e0:	c3                   	retq   

00000000008008e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e1:	55                   	push   %rbp
  8008e2:	48 89 e5             	mov    %rsp,%rbp
  8008e5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008f0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f4:	7e 52                	jle    800948 <getint+0x67>
		x=va_arg(*ap, long long);
  8008f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fa:	8b 00                	mov    (%rax),%eax
  8008fc:	83 f8 30             	cmp    $0x30,%eax
  8008ff:	73 24                	jae    800925 <getint+0x44>
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800909:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090d:	8b 00                	mov    (%rax),%eax
  80090f:	89 c0                	mov    %eax,%eax
  800911:	48 01 d0             	add    %rdx,%rax
  800914:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800918:	8b 12                	mov    (%rdx),%edx
  80091a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800921:	89 0a                	mov    %ecx,(%rdx)
  800923:	eb 17                	jmp    80093c <getint+0x5b>
  800925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800929:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092d:	48 89 d0             	mov    %rdx,%rax
  800930:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093c:	48 8b 00             	mov    (%rax),%rax
  80093f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800943:	e9 a3 00 00 00       	jmpq   8009eb <getint+0x10a>
	else if (lflag)
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094c:	74 4f                	je     80099d <getint+0xbc>
		x=va_arg(*ap, long);
  80094e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800952:	8b 00                	mov    (%rax),%eax
  800954:	83 f8 30             	cmp    $0x30,%eax
  800957:	73 24                	jae    80097d <getint+0x9c>
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	8b 00                	mov    (%rax),%eax
  800967:	89 c0                	mov    %eax,%eax
  800969:	48 01 d0             	add    %rdx,%rax
  80096c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800970:	8b 12                	mov    (%rdx),%edx
  800972:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800975:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800979:	89 0a                	mov    %ecx,(%rdx)
  80097b:	eb 17                	jmp    800994 <getint+0xb3>
  80097d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800981:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800985:	48 89 d0             	mov    %rdx,%rax
  800988:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800990:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800994:	48 8b 00             	mov    (%rax),%rax
  800997:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099b:	eb 4e                	jmp    8009eb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	8b 00                	mov    (%rax),%eax
  8009a3:	83 f8 30             	cmp    $0x30,%eax
  8009a6:	73 24                	jae    8009cc <getint+0xeb>
  8009a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	8b 00                	mov    (%rax),%eax
  8009b6:	89 c0                	mov    %eax,%eax
  8009b8:	48 01 d0             	add    %rdx,%rax
  8009bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bf:	8b 12                	mov    (%rdx),%edx
  8009c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	89 0a                	mov    %ecx,(%rdx)
  8009ca:	eb 17                	jmp    8009e3 <getint+0x102>
  8009cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d4:	48 89 d0             	mov    %rdx,%rax
  8009d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e3:	8b 00                	mov    (%rax),%eax
  8009e5:	48 98                	cltq   
  8009e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ef:	c9                   	leaveq 
  8009f0:	c3                   	retq   

00000000008009f1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f1:	55                   	push   %rbp
  8009f2:	48 89 e5             	mov    %rsp,%rbp
  8009f5:	41 54                	push   %r12
  8009f7:	53                   	push   %rbx
  8009f8:	48 83 ec 60          	sub    $0x60,%rsp
  8009fc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a00:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a04:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a08:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a0c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a10:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a14:	48 8b 0a             	mov    (%rdx),%rcx
  800a17:	48 89 08             	mov    %rcx,(%rax)
  800a1a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a1e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a22:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a26:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2a:	eb 17                	jmp    800a43 <vprintfmt+0x52>
			if (ch == '\0')
  800a2c:	85 db                	test   %ebx,%ebx
  800a2e:	0f 84 df 04 00 00    	je     800f13 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800a34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	48 89 d6             	mov    %rdx,%rsi
  800a3f:	89 df                	mov    %ebx,%edi
  800a41:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a4b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a4f:	0f b6 00             	movzbl (%rax),%eax
  800a52:	0f b6 d8             	movzbl %al,%ebx
  800a55:	83 fb 25             	cmp    $0x25,%ebx
  800a58:	75 d2                	jne    800a2c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a5a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a5e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a65:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a6c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a73:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a82:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a86:	0f b6 00             	movzbl (%rax),%eax
  800a89:	0f b6 d8             	movzbl %al,%ebx
  800a8c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a8f:	83 f8 55             	cmp    $0x55,%eax
  800a92:	0f 87 47 04 00 00    	ja     800edf <vprintfmt+0x4ee>
  800a98:	89 c0                	mov    %eax,%eax
  800a9a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aa1:	00 
  800aa2:	48 b8 98 1f 80 00 00 	movabs $0x801f98,%rax
  800aa9:	00 00 00 
  800aac:	48 01 d0             	add    %rdx,%rax
  800aaf:	48 8b 00             	mov    (%rax),%rax
  800ab2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ab8:	eb c0                	jmp    800a7a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800abe:	eb ba                	jmp    800a7a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800adb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800adf:	0f b6 00             	movzbl (%rax),%eax
  800ae2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae5:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae8:	7e 0c                	jle    800af6 <vprintfmt+0x105>
  800aea:	83 fb 39             	cmp    $0x39,%ebx
  800aed:	7f 07                	jg     800af6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aef:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af4:	eb d1                	jmp    800ac7 <vprintfmt+0xd6>
			goto process_precision;
  800af6:	eb 58                	jmp    800b50 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800af8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afb:	83 f8 30             	cmp    $0x30,%eax
  800afe:	73 17                	jae    800b17 <vprintfmt+0x126>
  800b00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b07:	89 c0                	mov    %eax,%eax
  800b09:	48 01 d0             	add    %rdx,%rax
  800b0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0f:	83 c2 08             	add    $0x8,%edx
  800b12:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b15:	eb 0f                	jmp    800b26 <vprintfmt+0x135>
  800b17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1b:	48 89 d0             	mov    %rdx,%rax
  800b1e:	48 83 c2 08          	add    $0x8,%rdx
  800b22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b26:	8b 00                	mov    (%rax),%eax
  800b28:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b2b:	eb 23                	jmp    800b50 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b31:	79 0c                	jns    800b3f <vprintfmt+0x14e>
				width = 0;
  800b33:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b3a:	e9 3b ff ff ff       	jmpq   800a7a <vprintfmt+0x89>
  800b3f:	e9 36 ff ff ff       	jmpq   800a7a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b44:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b4b:	e9 2a ff ff ff       	jmpq   800a7a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b54:	79 12                	jns    800b68 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b56:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b59:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b5c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b63:	e9 12 ff ff ff       	jmpq   800a7a <vprintfmt+0x89>
  800b68:	e9 0d ff ff ff       	jmpq   800a7a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b6d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b71:	e9 04 ff ff ff       	jmpq   800a7a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b79:	83 f8 30             	cmp    $0x30,%eax
  800b7c:	73 17                	jae    800b95 <vprintfmt+0x1a4>
  800b7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b85:	89 c0                	mov    %eax,%eax
  800b87:	48 01 d0             	add    %rdx,%rax
  800b8a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8d:	83 c2 08             	add    $0x8,%edx
  800b90:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b93:	eb 0f                	jmp    800ba4 <vprintfmt+0x1b3>
  800b95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b99:	48 89 d0             	mov    %rdx,%rax
  800b9c:	48 83 c2 08          	add    $0x8,%rdx
  800ba0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba4:	8b 10                	mov    (%rax),%edx
  800ba6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800baa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bae:	48 89 ce             	mov    %rcx,%rsi
  800bb1:	89 d7                	mov    %edx,%edi
  800bb3:	ff d0                	callq  *%rax
			break;
  800bb5:	e9 53 03 00 00       	jmpq   800f0d <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbd:	83 f8 30             	cmp    $0x30,%eax
  800bc0:	73 17                	jae    800bd9 <vprintfmt+0x1e8>
  800bc2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc9:	89 c0                	mov    %eax,%eax
  800bcb:	48 01 d0             	add    %rdx,%rax
  800bce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd1:	83 c2 08             	add    $0x8,%edx
  800bd4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd7:	eb 0f                	jmp    800be8 <vprintfmt+0x1f7>
  800bd9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdd:	48 89 d0             	mov    %rdx,%rax
  800be0:	48 83 c2 08          	add    $0x8,%rdx
  800be4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bea:	85 db                	test   %ebx,%ebx
  800bec:	79 02                	jns    800bf0 <vprintfmt+0x1ff>
				err = -err;
  800bee:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf0:	83 fb 15             	cmp    $0x15,%ebx
  800bf3:	7f 16                	jg     800c0b <vprintfmt+0x21a>
  800bf5:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  800bfc:	00 00 00 
  800bff:	48 63 d3             	movslq %ebx,%rdx
  800c02:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c06:	4d 85 e4             	test   %r12,%r12
  800c09:	75 2e                	jne    800c39 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c13:	89 d9                	mov    %ebx,%ecx
  800c15:	48 ba 81 1f 80 00 00 	movabs $0x801f81,%rdx
  800c1c:	00 00 00 
  800c1f:	48 89 c7             	mov    %rax,%rdi
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
  800c27:	49 b8 1c 0f 80 00 00 	movabs $0x800f1c,%r8
  800c2e:	00 00 00 
  800c31:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c34:	e9 d4 02 00 00       	jmpq   800f0d <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c41:	4c 89 e1             	mov    %r12,%rcx
  800c44:	48 ba 8a 1f 80 00 00 	movabs $0x801f8a,%rdx
  800c4b:	00 00 00 
  800c4e:	48 89 c7             	mov    %rax,%rdi
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	49 b8 1c 0f 80 00 00 	movabs $0x800f1c,%r8
  800c5d:	00 00 00 
  800c60:	41 ff d0             	callq  *%r8
			break;
  800c63:	e9 a5 02 00 00       	jmpq   800f0d <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6b:	83 f8 30             	cmp    $0x30,%eax
  800c6e:	73 17                	jae    800c87 <vprintfmt+0x296>
  800c70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	89 c0                	mov    %eax,%eax
  800c79:	48 01 d0             	add    %rdx,%rax
  800c7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7f:	83 c2 08             	add    $0x8,%edx
  800c82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c85:	eb 0f                	jmp    800c96 <vprintfmt+0x2a5>
  800c87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8b:	48 89 d0             	mov    %rdx,%rax
  800c8e:	48 83 c2 08          	add    $0x8,%rdx
  800c92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c96:	4c 8b 20             	mov    (%rax),%r12
  800c99:	4d 85 e4             	test   %r12,%r12
  800c9c:	75 0a                	jne    800ca8 <vprintfmt+0x2b7>
				p = "(null)";
  800c9e:	49 bc 8d 1f 80 00 00 	movabs $0x801f8d,%r12
  800ca5:	00 00 00 
			if (width > 0 && padc != '-')
  800ca8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cac:	7e 3f                	jle    800ced <vprintfmt+0x2fc>
  800cae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb2:	74 39                	je     800ced <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cb7:	48 98                	cltq   
  800cb9:	48 89 c6             	mov    %rax,%rsi
  800cbc:	4c 89 e7             	mov    %r12,%rdi
  800cbf:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cce:	eb 17                	jmp    800ce7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cd0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cd4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdc:	48 89 ce             	mov    %rcx,%rsi
  800cdf:	89 d7                	mov    %edx,%edi
  800ce1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ceb:	7f e3                	jg     800cd0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ced:	eb 37                	jmp    800d26 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cf3:	74 1e                	je     800d13 <vprintfmt+0x322>
  800cf5:	83 fb 1f             	cmp    $0x1f,%ebx
  800cf8:	7e 05                	jle    800cff <vprintfmt+0x30e>
  800cfa:	83 fb 7e             	cmp    $0x7e,%ebx
  800cfd:	7e 14                	jle    800d13 <vprintfmt+0x322>
					putch('?', putdat);
  800cff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d07:	48 89 d6             	mov    %rdx,%rsi
  800d0a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d0f:	ff d0                	callq  *%rax
  800d11:	eb 0f                	jmp    800d22 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1b:	48 89 d6             	mov    %rdx,%rsi
  800d1e:	89 df                	mov    %ebx,%edi
  800d20:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d22:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d26:	4c 89 e0             	mov    %r12,%rax
  800d29:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d2d:	0f b6 00             	movzbl (%rax),%eax
  800d30:	0f be d8             	movsbl %al,%ebx
  800d33:	85 db                	test   %ebx,%ebx
  800d35:	74 10                	je     800d47 <vprintfmt+0x356>
  800d37:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d3b:	78 b2                	js     800cef <vprintfmt+0x2fe>
  800d3d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d41:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d45:	79 a8                	jns    800cef <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d47:	eb 16                	jmp    800d5f <vprintfmt+0x36e>
				putch(' ', putdat);
  800d49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d51:	48 89 d6             	mov    %rdx,%rsi
  800d54:	bf 20 00 00 00       	mov    $0x20,%edi
  800d59:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d63:	7f e4                	jg     800d49 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d65:	e9 a3 01 00 00       	jmpq   800f0d <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d6a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6e:	be 03 00 00 00       	mov    $0x3,%esi
  800d73:	48 89 c7             	mov    %rax,%rdi
  800d76:	48 b8 e1 08 80 00 00 	movabs $0x8008e1,%rax
  800d7d:	00 00 00 
  800d80:	ff d0                	callq  *%rax
  800d82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8a:	48 85 c0             	test   %rax,%rax
  800d8d:	79 1d                	jns    800dac <vprintfmt+0x3bb>
				putch('-', putdat);
  800d8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d97:	48 89 d6             	mov    %rdx,%rsi
  800d9a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d9f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da5:	48 f7 d8             	neg    %rax
  800da8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dac:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db3:	e9 e8 00 00 00       	jmpq   800ea0 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800db8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbc:	be 03 00 00 00       	mov    $0x3,%esi
  800dc1:	48 89 c7             	mov    %rax,%rdi
  800dc4:	48 b8 d1 07 80 00 00 	movabs $0x8007d1,%rax
  800dcb:	00 00 00 
  800dce:	ff d0                	callq  *%rax
  800dd0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dd4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ddb:	e9 c0 00 00 00       	jmpq   800ea0 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800de0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de8:	48 89 d6             	mov    %rdx,%rsi
  800deb:	bf 58 00 00 00       	mov    $0x58,%edi
  800df0:	ff d0                	callq  *%rax
			putch('X', putdat);
  800df2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfa:	48 89 d6             	mov    %rdx,%rsi
  800dfd:	bf 58 00 00 00       	mov    $0x58,%edi
  800e02:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	bf 58 00 00 00       	mov    $0x58,%edi
  800e14:	ff d0                	callq  *%rax
			break;
  800e16:	e9 f2 00 00 00       	jmpq   800f0d <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e23:	48 89 d6             	mov    %rdx,%rsi
  800e26:	bf 30 00 00 00       	mov    $0x30,%edi
  800e2b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e35:	48 89 d6             	mov    %rdx,%rsi
  800e38:	bf 78 00 00 00       	mov    $0x78,%edi
  800e3d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e42:	83 f8 30             	cmp    $0x30,%eax
  800e45:	73 17                	jae    800e5e <vprintfmt+0x46d>
  800e47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4e:	89 c0                	mov    %eax,%eax
  800e50:	48 01 d0             	add    %rdx,%rax
  800e53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e56:	83 c2 08             	add    $0x8,%edx
  800e59:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e5c:	eb 0f                	jmp    800e6d <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800e5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e62:	48 89 d0             	mov    %rdx,%rax
  800e65:	48 83 c2 08          	add    $0x8,%rdx
  800e69:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e6d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e7b:	eb 23                	jmp    800ea0 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e81:	be 03 00 00 00       	mov    $0x3,%esi
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	48 b8 d1 07 80 00 00 	movabs $0x8007d1,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
  800e95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ea5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ea8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eaf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb7:	45 89 c1             	mov    %r8d,%r9d
  800eba:	41 89 f8             	mov    %edi,%r8d
  800ebd:	48 89 c7             	mov    %rax,%rdi
  800ec0:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800ec7:	00 00 00 
  800eca:	ff d0                	callq  *%rax
			break;
  800ecc:	eb 3f                	jmp    800f0d <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ece:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed6:	48 89 d6             	mov    %rdx,%rsi
  800ed9:	89 df                	mov    %ebx,%edi
  800edb:	ff d0                	callq  *%rax
			break;
  800edd:	eb 2e                	jmp    800f0d <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800edf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee7:	48 89 d6             	mov    %rdx,%rsi
  800eea:	bf 25 00 00 00       	mov    $0x25,%edi
  800eef:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ef6:	eb 05                	jmp    800efd <vprintfmt+0x50c>
  800ef8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800efd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f01:	48 83 e8 01          	sub    $0x1,%rax
  800f05:	0f b6 00             	movzbl (%rax),%eax
  800f08:	3c 25                	cmp    $0x25,%al
  800f0a:	75 ec                	jne    800ef8 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800f0c:	90                   	nop
		}
	}
  800f0d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f0e:	e9 30 fb ff ff       	jmpq   800a43 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f13:	48 83 c4 60          	add    $0x60,%rsp
  800f17:	5b                   	pop    %rbx
  800f18:	41 5c                	pop    %r12
  800f1a:	5d                   	pop    %rbp
  800f1b:	c3                   	retq   

0000000000800f1c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
  800f20:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f27:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f2e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4a:	84 c0                	test   %al,%al
  800f4c:	74 20                	je     800f6e <printfmt+0x52>
  800f4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f6e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f75:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f7c:	00 00 00 
  800f7f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f86:	00 00 00 
  800f89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f8d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f9b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fa2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fa9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fb0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fb7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fbe:	48 89 c7             	mov    %rax,%rdi
  800fc1:	48 b8 f1 09 80 00 00 	movabs $0x8009f1,%rax
  800fc8:	00 00 00 
  800fcb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 10          	sub    $0x10,%rsp
  800fd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe2:	8b 40 10             	mov    0x10(%rax),%eax
  800fe5:	8d 50 01             	lea    0x1(%rax),%edx
  800fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fec:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff3:	48 8b 10             	mov    (%rax),%rdx
  800ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffa:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ffe:	48 39 c2             	cmp    %rax,%rdx
  801001:	73 17                	jae    80101a <sprintputch+0x4b>
		*b->buf++ = ch;
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	48 8b 00             	mov    (%rax),%rax
  80100a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80100e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801012:	48 89 0a             	mov    %rcx,(%rdx)
  801015:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801018:	88 10                	mov    %dl,(%rax)
}
  80101a:	c9                   	leaveq 
  80101b:	c3                   	retq   

000000000080101c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80101c:	55                   	push   %rbp
  80101d:	48 89 e5             	mov    %rsp,%rbp
  801020:	48 83 ec 50          	sub    $0x50,%rsp
  801024:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801028:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80102b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80102f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801033:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801037:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80103b:	48 8b 0a             	mov    (%rdx),%rcx
  80103e:	48 89 08             	mov    %rcx,(%rax)
  801041:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801045:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801049:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80104d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801051:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801055:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801059:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80105c:	48 98                	cltq   
  80105e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801062:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801066:	48 01 d0             	add    %rdx,%rax
  801069:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80106d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801074:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801079:	74 06                	je     801081 <vsnprintf+0x65>
  80107b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80107f:	7f 07                	jg     801088 <vsnprintf+0x6c>
		return -E_INVAL;
  801081:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801086:	eb 2f                	jmp    8010b7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801088:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80108c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801090:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801094:	48 89 c6             	mov    %rax,%rsi
  801097:	48 bf cf 0f 80 00 00 	movabs $0x800fcf,%rdi
  80109e:	00 00 00 
  8010a1:	48 b8 f1 09 80 00 00 	movabs $0x8009f1,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010b1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010b7:	c9                   	leaveq 
  8010b8:	c3                   	retq   

00000000008010b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010b9:	55                   	push   %rbp
  8010ba:	48 89 e5             	mov    %rsp,%rbp
  8010bd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010c4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010cb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010d1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010d8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010df:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010e6:	84 c0                	test   %al,%al
  8010e8:	74 20                	je     80110a <snprintf+0x51>
  8010ea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010ee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010f2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010f6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010fa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010fe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801102:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801106:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80110a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801111:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801118:	00 00 00 
  80111b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801122:	00 00 00 
  801125:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801129:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801130:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801137:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80113e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801145:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80114c:	48 8b 0a             	mov    (%rdx),%rcx
  80114f:	48 89 08             	mov    %rcx,(%rax)
  801152:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801156:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80115a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80115e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801162:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801169:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801170:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801176:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80117d:	48 89 c7             	mov    %rax,%rdi
  801180:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  801187:	00 00 00 
  80118a:	ff d0                	callq  *%rax
  80118c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801192:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801198:	c9                   	leaveq 
  801199:	c3                   	retq   

000000000080119a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80119a:	55                   	push   %rbp
  80119b:	48 89 e5             	mov    %rsp,%rbp
  80119e:	48 83 ec 18          	sub    $0x18,%rsp
  8011a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ad:	eb 09                	jmp    8011b8 <strlen+0x1e>
		n++;
  8011af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bc:	0f b6 00             	movzbl (%rax),%eax
  8011bf:	84 c0                	test   %al,%al
  8011c1:	75 ec                	jne    8011af <strlen+0x15>
		n++;
	return n;
  8011c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011c6:	c9                   	leaveq 
  8011c7:	c3                   	retq   

00000000008011c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011c8:	55                   	push   %rbp
  8011c9:	48 89 e5             	mov    %rsp,%rbp
  8011cc:	48 83 ec 20          	sub    $0x20,%rsp
  8011d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011df:	eb 0e                	jmp    8011ef <strnlen+0x27>
		n++;
  8011e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ea:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011f4:	74 0b                	je     801201 <strnlen+0x39>
  8011f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	84 c0                	test   %al,%al
  8011ff:	75 e0                	jne    8011e1 <strnlen+0x19>
		n++;
	return n;
  801201:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 20          	sub    $0x20,%rsp
  80120e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801212:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80121e:	90                   	nop
  80121f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801223:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801227:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80122b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80122f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801233:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801237:	0f b6 12             	movzbl (%rdx),%edx
  80123a:	88 10                	mov    %dl,(%rax)
  80123c:	0f b6 00             	movzbl (%rax),%eax
  80123f:	84 c0                	test   %al,%al
  801241:	75 dc                	jne    80121f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801247:	c9                   	leaveq 
  801248:	c3                   	retq   

0000000000801249 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801249:	55                   	push   %rbp
  80124a:	48 89 e5             	mov    %rsp,%rbp
  80124d:	48 83 ec 20          	sub    $0x20,%rsp
  801251:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801255:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125d:	48 89 c7             	mov    %rax,%rdi
  801260:	48 b8 9a 11 80 00 00 	movabs $0x80119a,%rax
  801267:	00 00 00 
  80126a:	ff d0                	callq  *%rax
  80126c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80126f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801272:	48 63 d0             	movslq %eax,%rdx
  801275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801279:	48 01 c2             	add    %rax,%rdx
  80127c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801280:	48 89 c6             	mov    %rax,%rsi
  801283:	48 89 d7             	mov    %rdx,%rdi
  801286:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  80128d:	00 00 00 
  801290:	ff d0                	callq  *%rax
	return dst;
  801292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801296:	c9                   	leaveq 
  801297:	c3                   	retq   

0000000000801298 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801298:	55                   	push   %rbp
  801299:	48 89 e5             	mov    %rsp,%rbp
  80129c:	48 83 ec 28          	sub    $0x28,%rsp
  8012a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012b4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012bb:	00 
  8012bc:	eb 2a                	jmp    8012e8 <strncpy+0x50>
		*dst++ = *src;
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012ce:	0f b6 12             	movzbl (%rdx),%edx
  8012d1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	84 c0                	test   %al,%al
  8012dc:	74 05                	je     8012e3 <strncpy+0x4b>
			src++;
  8012de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012f0:	72 cc                	jb     8012be <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012f6:	c9                   	leaveq 
  8012f7:	c3                   	retq   

00000000008012f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012f8:	55                   	push   %rbp
  8012f9:	48 89 e5             	mov    %rsp,%rbp
  8012fc:	48 83 ec 28          	sub    $0x28,%rsp
  801300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801304:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801308:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80130c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801310:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801314:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801319:	74 3d                	je     801358 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80131b:	eb 1d                	jmp    80133a <strlcpy+0x42>
			*dst++ = *src++;
  80131d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801321:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801325:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801329:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80132d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801331:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801335:	0f b6 12             	movzbl (%rdx),%edx
  801338:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80133a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80133f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801344:	74 0b                	je     801351 <strlcpy+0x59>
  801346:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134a:	0f b6 00             	movzbl (%rax),%eax
  80134d:	84 c0                	test   %al,%al
  80134f:	75 cc                	jne    80131d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801355:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801358:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	48 29 c2             	sub    %rax,%rdx
  801363:	48 89 d0             	mov    %rdx,%rax
}
  801366:	c9                   	leaveq 
  801367:	c3                   	retq   

0000000000801368 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801368:	55                   	push   %rbp
  801369:	48 89 e5             	mov    %rsp,%rbp
  80136c:	48 83 ec 10          	sub    $0x10,%rsp
  801370:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801374:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801378:	eb 0a                	jmp    801384 <strcmp+0x1c>
		p++, q++;
  80137a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80137f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	0f b6 00             	movzbl (%rax),%eax
  80138b:	84 c0                	test   %al,%al
  80138d:	74 12                	je     8013a1 <strcmp+0x39>
  80138f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801393:	0f b6 10             	movzbl (%rax),%edx
  801396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	38 c2                	cmp    %al,%dl
  80139f:	74 d9                	je     80137a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	0f b6 d0             	movzbl %al,%edx
  8013ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	c9                   	leaveq 
  8013ba:	c3                   	retq   

00000000008013bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013bb:	55                   	push   %rbp
  8013bc:	48 89 e5             	mov    %rsp,%rbp
  8013bf:	48 83 ec 18          	sub    $0x18,%rsp
  8013c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013cf:	eb 0f                	jmp    8013e0 <strncmp+0x25>
		n--, p++, q++;
  8013d1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013e5:	74 1d                	je     801404 <strncmp+0x49>
  8013e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	84 c0                	test   %al,%al
  8013f0:	74 12                	je     801404 <strncmp+0x49>
  8013f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f6:	0f b6 10             	movzbl (%rax),%edx
  8013f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fd:	0f b6 00             	movzbl (%rax),%eax
  801400:	38 c2                	cmp    %al,%dl
  801402:	74 cd                	je     8013d1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801404:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801409:	75 07                	jne    801412 <strncmp+0x57>
		return 0;
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	eb 18                	jmp    80142a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	0f b6 d0             	movzbl %al,%edx
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	0f b6 c0             	movzbl %al,%eax
  801426:	29 c2                	sub    %eax,%edx
  801428:	89 d0                	mov    %edx,%eax
}
  80142a:	c9                   	leaveq 
  80142b:	c3                   	retq   

000000000080142c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80142c:	55                   	push   %rbp
  80142d:	48 89 e5             	mov    %rsp,%rbp
  801430:	48 83 ec 0c          	sub    $0xc,%rsp
  801434:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801438:	89 f0                	mov    %esi,%eax
  80143a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80143d:	eb 17                	jmp    801456 <strchr+0x2a>
		if (*s == c)
  80143f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801449:	75 06                	jne    801451 <strchr+0x25>
			return (char *) s;
  80144b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144f:	eb 15                	jmp    801466 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801451:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	84 c0                	test   %al,%al
  80145f:	75 de                	jne    80143f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 0c          	sub    $0xc,%rsp
  801470:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801474:	89 f0                	mov    %esi,%eax
  801476:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801479:	eb 13                	jmp    80148e <strfind+0x26>
		if (*s == c)
  80147b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147f:	0f b6 00             	movzbl (%rax),%eax
  801482:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801485:	75 02                	jne    801489 <strfind+0x21>
			break;
  801487:	eb 10                	jmp    801499 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801489:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	84 c0                	test   %al,%al
  801497:	75 e2                	jne    80147b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80149d:	c9                   	leaveq 
  80149e:	c3                   	retq   

000000000080149f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	48 83 ec 18          	sub    $0x18,%rsp
  8014a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014b7:	75 06                	jne    8014bf <memset+0x20>
		return v;
  8014b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bd:	eb 69                	jmp    801528 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c3:	83 e0 03             	and    $0x3,%eax
  8014c6:	48 85 c0             	test   %rax,%rax
  8014c9:	75 48                	jne    801513 <memset+0x74>
  8014cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cf:	83 e0 03             	and    $0x3,%eax
  8014d2:	48 85 c0             	test   %rax,%rax
  8014d5:	75 3c                	jne    801513 <memset+0x74>
		c &= 0xFF;
  8014d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e1:	c1 e0 18             	shl    $0x18,%eax
  8014e4:	89 c2                	mov    %eax,%edx
  8014e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e9:	c1 e0 10             	shl    $0x10,%eax
  8014ec:	09 c2                	or     %eax,%edx
  8014ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f1:	c1 e0 08             	shl    $0x8,%eax
  8014f4:	09 d0                	or     %edx,%eax
  8014f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fd:	48 c1 e8 02          	shr    $0x2,%rax
  801501:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801504:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801508:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150b:	48 89 d7             	mov    %rdx,%rdi
  80150e:	fc                   	cld    
  80150f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801511:	eb 11                	jmp    801524 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801513:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801517:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80151e:	48 89 d7             	mov    %rdx,%rdi
  801521:	fc                   	cld    
  801522:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801528:	c9                   	leaveq 
  801529:	c3                   	retq   

000000000080152a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80152a:	55                   	push   %rbp
  80152b:	48 89 e5             	mov    %rsp,%rbp
  80152e:	48 83 ec 28          	sub    $0x28,%rsp
  801532:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801536:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80153a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80153e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801552:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801556:	0f 83 88 00 00 00    	jae    8015e4 <memmove+0xba>
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801564:	48 01 d0             	add    %rdx,%rax
  801567:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80156b:	76 77                	jbe    8015e4 <memmove+0xba>
		s += n;
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80157d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801581:	83 e0 03             	and    $0x3,%eax
  801584:	48 85 c0             	test   %rax,%rax
  801587:	75 3b                	jne    8015c4 <memmove+0x9a>
  801589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158d:	83 e0 03             	and    $0x3,%eax
  801590:	48 85 c0             	test   %rax,%rax
  801593:	75 2f                	jne    8015c4 <memmove+0x9a>
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	48 85 c0             	test   %rax,%rax
  80159f:	75 23                	jne    8015c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a5:	48 83 e8 04          	sub    $0x4,%rax
  8015a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ad:	48 83 ea 04          	sub    $0x4,%rdx
  8015b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015b9:	48 89 c7             	mov    %rax,%rdi
  8015bc:	48 89 d6             	mov    %rdx,%rsi
  8015bf:	fd                   	std    
  8015c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015c2:	eb 1d                	jmp    8015e1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	48 89 d7             	mov    %rdx,%rdi
  8015db:	48 89 c1             	mov    %rax,%rcx
  8015de:	fd                   	std    
  8015df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015e1:	fc                   	cld    
  8015e2:	eb 57                	jmp    80163b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e8:	83 e0 03             	and    $0x3,%eax
  8015eb:	48 85 c0             	test   %rax,%rax
  8015ee:	75 36                	jne    801626 <memmove+0xfc>
  8015f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f4:	83 e0 03             	and    $0x3,%eax
  8015f7:	48 85 c0             	test   %rax,%rax
  8015fa:	75 2a                	jne    801626 <memmove+0xfc>
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	83 e0 03             	and    $0x3,%eax
  801603:	48 85 c0             	test   %rax,%rax
  801606:	75 1e                	jne    801626 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160c:	48 c1 e8 02          	shr    $0x2,%rax
  801610:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801617:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161b:	48 89 c7             	mov    %rax,%rdi
  80161e:	48 89 d6             	mov    %rdx,%rsi
  801621:	fc                   	cld    
  801622:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801624:	eb 15                	jmp    80163b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801632:	48 89 c7             	mov    %rax,%rdi
  801635:	48 89 d6             	mov    %rdx,%rsi
  801638:	fc                   	cld    
  801639:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80163b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	48 83 ec 18          	sub    $0x18,%rsp
  801649:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801651:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801655:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801659:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80165d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801661:	48 89 ce             	mov    %rcx,%rsi
  801664:	48 89 c7             	mov    %rax,%rdi
  801667:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  80166e:	00 00 00 
  801671:	ff d0                	callq  *%rax
}
  801673:	c9                   	leaveq 
  801674:	c3                   	retq   

0000000000801675 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	48 83 ec 28          	sub    $0x28,%rsp
  80167d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801681:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801685:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801691:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801695:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801699:	eb 36                	jmp    8016d1 <memcmp+0x5c>
		if (*s1 != *s2)
  80169b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169f:	0f b6 10             	movzbl (%rax),%edx
  8016a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	38 c2                	cmp    %al,%dl
  8016ab:	74 1a                	je     8016c7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	0f b6 d0             	movzbl %al,%edx
  8016b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f b6 c0             	movzbl %al,%eax
  8016c1:	29 c2                	sub    %eax,%edx
  8016c3:	89 d0                	mov    %edx,%eax
  8016c5:	eb 20                	jmp    8016e7 <memcmp+0x72>
		s1++, s2++;
  8016c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016dd:	48 85 c0             	test   %rax,%rax
  8016e0:	75 b9                	jne    80169b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	c9                   	leaveq 
  8016e8:	c3                   	retq   

00000000008016e9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016e9:	55                   	push   %rbp
  8016ea:	48 89 e5             	mov    %rsp,%rbp
  8016ed:	48 83 ec 28          	sub    $0x28,%rsp
  8016f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801704:	48 01 d0             	add    %rdx,%rax
  801707:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80170b:	eb 15                	jmp    801722 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80170d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801711:	0f b6 10             	movzbl (%rax),%edx
  801714:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801717:	38 c2                	cmp    %al,%dl
  801719:	75 02                	jne    80171d <memfind+0x34>
			break;
  80171b:	eb 0f                	jmp    80172c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80171d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801726:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80172a:	72 e1                	jb     80170d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80172c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801730:	c9                   	leaveq 
  801731:	c3                   	retq   

0000000000801732 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801732:	55                   	push   %rbp
  801733:	48 89 e5             	mov    %rsp,%rbp
  801736:	48 83 ec 34          	sub    $0x34,%rsp
  80173a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80173e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801742:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801745:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80174c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801753:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801754:	eb 05                	jmp    80175b <strtol+0x29>
		s++;
  801756:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	3c 20                	cmp    $0x20,%al
  801764:	74 f0                	je     801756 <strtol+0x24>
  801766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	3c 09                	cmp    $0x9,%al
  80176f:	74 e5                	je     801756 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	0f b6 00             	movzbl (%rax),%eax
  801778:	3c 2b                	cmp    $0x2b,%al
  80177a:	75 07                	jne    801783 <strtol+0x51>
		s++;
  80177c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801781:	eb 17                	jmp    80179a <strtol+0x68>
	else if (*s == '-')
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	0f b6 00             	movzbl (%rax),%eax
  80178a:	3c 2d                	cmp    $0x2d,%al
  80178c:	75 0c                	jne    80179a <strtol+0x68>
		s++, neg = 1;
  80178e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801793:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80179a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80179e:	74 06                	je     8017a6 <strtol+0x74>
  8017a0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017a4:	75 28                	jne    8017ce <strtol+0x9c>
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	3c 30                	cmp    $0x30,%al
  8017af:	75 1d                	jne    8017ce <strtol+0x9c>
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	48 83 c0 01          	add    $0x1,%rax
  8017b9:	0f b6 00             	movzbl (%rax),%eax
  8017bc:	3c 78                	cmp    $0x78,%al
  8017be:	75 0e                	jne    8017ce <strtol+0x9c>
		s += 2, base = 16;
  8017c0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017c5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017cc:	eb 2c                	jmp    8017fa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017d2:	75 19                	jne    8017ed <strtol+0xbb>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	3c 30                	cmp    $0x30,%al
  8017dd:	75 0e                	jne    8017ed <strtol+0xbb>
		s++, base = 8;
  8017df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017eb:	eb 0d                	jmp    8017fa <strtol+0xc8>
	else if (base == 0)
  8017ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f1:	75 07                	jne    8017fa <strtol+0xc8>
		base = 10;
  8017f3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fe:	0f b6 00             	movzbl (%rax),%eax
  801801:	3c 2f                	cmp    $0x2f,%al
  801803:	7e 1d                	jle    801822 <strtol+0xf0>
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	0f b6 00             	movzbl (%rax),%eax
  80180c:	3c 39                	cmp    $0x39,%al
  80180e:	7f 12                	jg     801822 <strtol+0xf0>
			dig = *s - '0';
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	0f be c0             	movsbl %al,%eax
  80181a:	83 e8 30             	sub    $0x30,%eax
  80181d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801820:	eb 4e                	jmp    801870 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	0f b6 00             	movzbl (%rax),%eax
  801829:	3c 60                	cmp    $0x60,%al
  80182b:	7e 1d                	jle    80184a <strtol+0x118>
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	0f b6 00             	movzbl (%rax),%eax
  801834:	3c 7a                	cmp    $0x7a,%al
  801836:	7f 12                	jg     80184a <strtol+0x118>
			dig = *s - 'a' + 10;
  801838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183c:	0f b6 00             	movzbl (%rax),%eax
  80183f:	0f be c0             	movsbl %al,%eax
  801842:	83 e8 57             	sub    $0x57,%eax
  801845:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801848:	eb 26                	jmp    801870 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80184a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	3c 40                	cmp    $0x40,%al
  801853:	7e 48                	jle    80189d <strtol+0x16b>
  801855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801859:	0f b6 00             	movzbl (%rax),%eax
  80185c:	3c 5a                	cmp    $0x5a,%al
  80185e:	7f 3d                	jg     80189d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801864:	0f b6 00             	movzbl (%rax),%eax
  801867:	0f be c0             	movsbl %al,%eax
  80186a:	83 e8 37             	sub    $0x37,%eax
  80186d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801870:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801873:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801876:	7c 02                	jl     80187a <strtol+0x148>
			break;
  801878:	eb 23                	jmp    80189d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80187a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80187f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801882:	48 98                	cltq   
  801884:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801889:	48 89 c2             	mov    %rax,%rdx
  80188c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80188f:	48 98                	cltq   
  801891:	48 01 d0             	add    %rdx,%rax
  801894:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801898:	e9 5d ff ff ff       	jmpq   8017fa <strtol+0xc8>

	if (endptr)
  80189d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018a2:	74 0b                	je     8018af <strtol+0x17d>
		*endptr = (char *) s;
  8018a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018ac:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018b3:	74 09                	je     8018be <strtol+0x18c>
  8018b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b9:	48 f7 d8             	neg    %rax
  8018bc:	eb 04                	jmp    8018c2 <strtol+0x190>
  8018be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018c2:	c9                   	leaveq 
  8018c3:	c3                   	retq   

00000000008018c4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	48 83 ec 30          	sub    $0x30,%rsp
  8018cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018e6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018ea:	75 06                	jne    8018f2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	eb 6b                	jmp    80195d <strstr+0x99>

	len = strlen(str);
  8018f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f6:	48 89 c7             	mov    %rax,%rdi
  8018f9:	48 b8 9a 11 80 00 00 	movabs $0x80119a,%rax
  801900:	00 00 00 
  801903:	ff d0                	callq  *%rax
  801905:	48 98                	cltq   
  801907:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80190b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801913:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801917:	0f b6 00             	movzbl (%rax),%eax
  80191a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80191d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801921:	75 07                	jne    80192a <strstr+0x66>
				return (char *) 0;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
  801928:	eb 33                	jmp    80195d <strstr+0x99>
		} while (sc != c);
  80192a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80192e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801931:	75 d8                	jne    80190b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801933:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801937:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	48 89 ce             	mov    %rcx,%rsi
  801942:	48 89 c7             	mov    %rax,%rdi
  801945:	48 b8 bb 13 80 00 00 	movabs $0x8013bb,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	callq  *%rax
  801951:	85 c0                	test   %eax,%eax
  801953:	75 b6                	jne    80190b <strstr+0x47>

	return (char *) (in - 1);
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	48 83 e8 01          	sub    $0x1,%rax
}
  80195d:	c9                   	leaveq 
  80195e:	c3                   	retq   

000000000080195f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	53                   	push   %rbx
  801964:	48 83 ec 48          	sub    $0x48,%rsp
  801968:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80196b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80196e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801972:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801976:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80197a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80197e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801981:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801985:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801989:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80198d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801991:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801995:	4c 89 c3             	mov    %r8,%rbx
  801998:	cd 30                	int    $0x30
  80199a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80199e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019a2:	74 3e                	je     8019e2 <syscall+0x83>
  8019a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019a9:	7e 37                	jle    8019e2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019b2:	49 89 d0             	mov    %rdx,%r8
  8019b5:	89 c1                	mov    %eax,%ecx
  8019b7:	48 ba 48 22 80 00 00 	movabs $0x802248,%rdx
  8019be:	00 00 00 
  8019c1:	be 23 00 00 00       	mov    $0x23,%esi
  8019c6:	48 bf 65 22 80 00 00 	movabs $0x802265,%rdi
  8019cd:	00 00 00 
  8019d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d5:	49 b9 05 04 80 00 00 	movabs $0x800405,%r9
  8019dc:	00 00 00 
  8019df:	41 ff d1             	callq  *%r9

	return ret;
  8019e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019e6:	48 83 c4 48          	add    $0x48,%rsp
  8019ea:	5b                   	pop    %rbx
  8019eb:	5d                   	pop    %rbp
  8019ec:	c3                   	retq   

00000000008019ed <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	48 83 ec 20          	sub    $0x20,%rsp
  8019f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0c:	00 
  801a0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 00 00 00 00       	mov    $0x0,%esi
  801a24:	bf 00 00 00 00       	mov    $0x0,%edi
  801a29:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a46:	00 
  801a47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a58:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5d:	be 00 00 00 00       	mov    $0x0,%esi
  801a62:	bf 01 00 00 00       	mov    $0x1,%edi
  801a67:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	callq  *%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 10          	sub    $0x10,%rsp
  801a7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a83:	48 98                	cltq   
  801a85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8c:	00 
  801a8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9e:	48 89 c2             	mov    %rax,%rdx
  801aa1:	be 01 00 00 00       	mov    $0x1,%esi
  801aa6:	bf 03 00 00 00       	mov    $0x3,%edi
  801aab:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	callq  *%rax
}
  801ab7:	c9                   	leaveq 
  801ab8:	c3                   	retq   

0000000000801ab9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ab9:	55                   	push   %rbp
  801aba:	48 89 e5             	mov    %rsp,%rbp
  801abd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ac1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac8:	00 
  801ac9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801acf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ada:	ba 00 00 00 00       	mov    $0x0,%edx
  801adf:	be 00 00 00 00       	mov    $0x0,%esi
  801ae4:	bf 02 00 00 00       	mov    $0x2,%edi
  801ae9:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801af0:	00 00 00 
  801af3:	ff d0                	callq  *%rax
}
  801af5:	c9                   	leaveq 
  801af6:	c3                   	retq   

0000000000801af7 <sys_yield>:

void
sys_yield(void)
{
  801af7:	55                   	push   %rbp
  801af8:	48 89 e5             	mov    %rsp,%rbp
  801afb:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801aff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b06:	00 
  801b07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b18:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1d:	be 00 00 00 00       	mov    $0x0,%esi
  801b22:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b27:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801b2e:	00 00 00 
  801b31:	ff d0                	callq  *%rax
}
  801b33:	c9                   	leaveq 
  801b34:	c3                   	retq   

0000000000801b35 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b35:	55                   	push   %rbp
  801b36:	48 89 e5             	mov    %rsp,%rbp
  801b39:	48 83 ec 20          	sub    $0x20,%rsp
  801b3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b44:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4a:	48 63 c8             	movslq %eax,%rcx
  801b4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b54:	48 98                	cltq   
  801b56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5d:	00 
  801b5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b64:	49 89 c8             	mov    %rcx,%r8
  801b67:	48 89 d1             	mov    %rdx,%rcx
  801b6a:	48 89 c2             	mov    %rax,%rdx
  801b6d:	be 01 00 00 00       	mov    $0x1,%esi
  801b72:	bf 04 00 00 00       	mov    $0x4,%edi
  801b77:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	callq  *%rax
}
  801b83:	c9                   	leaveq 
  801b84:	c3                   	retq   

0000000000801b85 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b85:	55                   	push   %rbp
  801b86:	48 89 e5             	mov    %rsp,%rbp
  801b89:	48 83 ec 30          	sub    $0x30,%rsp
  801b8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b94:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b97:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b9b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b9f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ba2:	48 63 c8             	movslq %eax,%rcx
  801ba5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ba9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bac:	48 63 f0             	movslq %eax,%rsi
  801baf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb6:	48 98                	cltq   
  801bb8:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bbc:	49 89 f9             	mov    %rdi,%r9
  801bbf:	49 89 f0             	mov    %rsi,%r8
  801bc2:	48 89 d1             	mov    %rdx,%rcx
  801bc5:	48 89 c2             	mov    %rax,%rdx
  801bc8:	be 01 00 00 00       	mov    $0x1,%esi
  801bcd:	bf 05 00 00 00       	mov    $0x5,%edi
  801bd2:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 20          	sub    $0x20,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf6:	48 98                	cltq   
  801bf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bff:	00 
  801c00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0c:	48 89 d1             	mov    %rdx,%rcx
  801c0f:	48 89 c2             	mov    %rax,%rdx
  801c12:	be 01 00 00 00       	mov    $0x1,%esi
  801c17:	bf 06 00 00 00       	mov    $0x6,%edi
  801c1c:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801c23:	00 00 00 
  801c26:	ff d0                	callq  *%rax
}
  801c28:	c9                   	leaveq 
  801c29:	c3                   	retq   

0000000000801c2a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c2a:	55                   	push   %rbp
  801c2b:	48 89 e5             	mov    %rsp,%rbp
  801c2e:	48 83 ec 10          	sub    $0x10,%rsp
  801c32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c35:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c3b:	48 63 d0             	movslq %eax,%rdx
  801c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c41:	48 98                	cltq   
  801c43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4a:	00 
  801c4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c57:	48 89 d1             	mov    %rdx,%rcx
  801c5a:	48 89 c2             	mov    %rax,%rdx
  801c5d:	be 01 00 00 00       	mov    $0x1,%esi
  801c62:	bf 08 00 00 00       	mov    $0x8,%edi
  801c67:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	callq  *%rax
}
  801c73:	c9                   	leaveq 
  801c74:	c3                   	retq   

0000000000801c75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c75:	55                   	push   %rbp
  801c76:	48 89 e5             	mov    %rsp,%rbp
  801c79:	48 83 ec 20          	sub    $0x20,%rsp
  801c7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8b:	48 98                	cltq   
  801c8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c94:	00 
  801c95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca1:	48 89 d1             	mov    %rdx,%rcx
  801ca4:	48 89 c2             	mov    %rax,%rdx
  801ca7:	be 01 00 00 00       	mov    $0x1,%esi
  801cac:	bf 09 00 00 00       	mov    $0x9,%edi
  801cb1:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801cb8:	00 00 00 
  801cbb:	ff d0                	callq  *%rax
}
  801cbd:	c9                   	leaveq 
  801cbe:	c3                   	retq   

0000000000801cbf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cbf:	55                   	push   %rbp
  801cc0:	48 89 e5             	mov    %rsp,%rbp
  801cc3:	48 83 ec 20          	sub    $0x20,%rsp
  801cc7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cd2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd8:	48 63 f0             	movslq %eax,%rsi
  801cdb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce2:	48 98                	cltq   
  801ce4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cef:	00 
  801cf0:	49 89 f1             	mov    %rsi,%r9
  801cf3:	49 89 c8             	mov    %rcx,%r8
  801cf6:	48 89 d1             	mov    %rdx,%rcx
  801cf9:	48 89 c2             	mov    %rax,%rdx
  801cfc:	be 00 00 00 00       	mov    $0x0,%esi
  801d01:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d06:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	callq  *%rax
}
  801d12:	c9                   	leaveq 
  801d13:	c3                   	retq   

0000000000801d14 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d14:	55                   	push   %rbp
  801d15:	48 89 e5             	mov    %rsp,%rbp
  801d18:	48 83 ec 10          	sub    $0x10,%rsp
  801d1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2b:	00 
  801d2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d32:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d3d:	48 89 c2             	mov    %rax,%rdx
  801d40:	be 01 00 00 00       	mov    $0x1,%esi
  801d45:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d4a:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801d51:	00 00 00 
  801d54:	ff d0                	callq  *%rax
}
  801d56:	c9                   	leaveq 
  801d57:	c3                   	retq   
