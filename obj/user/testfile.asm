
obj/user/testfile:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800060:	00 00 00 
  800063:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 8c 27 80 00 00 	movabs $0x80278c,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 26 42 80 00 00 	movabs $0x804226,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 31 42 80 00 00 	movabs $0x804231,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 60 42 80 00 00 	movabs $0x804260,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 2e 0d 80 00 00 	movabs $0x800d2e,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 81 42 80 00 00 	movabs $0x804281,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 8a 42 80 00 00 	movabs $0x80428a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba a8 42 80 00 00 	movabs $0x8042a8,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 2e 0d 80 00 00 	movabs $0x800d2e,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf d5 42 80 00 00 	movabs $0x8042d5,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba e9 42 80 00 00 	movabs $0x8042e9,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba f8 42 80 00 00 	movabs $0x8042f8,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 2e 0d 80 00 00 	movabs $0x800d2e,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf 1e 43 80 00 00 	movabs $0x80431e,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba 31 43 80 00 00 	movabs $0x804331,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 91 1c 80 00 00 	movabs $0x801c91,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba 3f 43 80 00 00 	movabs $0x80433f,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 2e 0d 80 00 00 	movabs $0x800d2e,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf 5d 43 80 00 00 	movabs $0x80435d,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba 70 43 80 00 00 	movabs $0x804370,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 7f 43 80 00 00 	movabs $0x80437f,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba 98 43 80 00 00 	movabs $0x804398,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf cf 43 80 00 00 	movabs $0x8043cf,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf e5 43 80 00 00 	movabs $0x8043e5,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba ef 43 80 00 00 	movabs $0x8043ef,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf 08 44 80 00 00 	movabs $0x804408,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 67 0f 80 00 00 	movabs $0x800f67,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba 48 44 80 00 00 	movabs $0x804448,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf 57 44 80 00 00 	movabs $0x804457,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba 90 44 80 00 00 	movabs $0x804490,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 91 1c 80 00 00 	movabs $0x801c91,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba c8 44 80 00 00 	movabs $0x8044c8,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 2e 0d 80 00 00 	movabs $0x800d2e,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf f8 44 80 00 00 	movabs $0x8044f8,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf 26 42 80 00 00 	movabs $0x804226,%rdi
  800833:	00 00 00 
  800836:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba 1c 45 80 00 00 	movabs $0x80451c,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 2e 0d 80 00 00 	movabs $0x800d2e,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf 81 42 80 00 00 	movabs $0x804281,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba 4b 45 80 00 00 	movabs $0x80454b,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba 60 45 80 00 00 	movabs $0x804560,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 2e 0d 80 00 00 	movabs $0x800d2e,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf 87 45 80 00 00 	movabs $0x804587,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf 95 45 80 00 00 	movabs $0x804595,%rdi
  800997:	00 00 00 
  80099a:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba 9a 45 80 00 00 	movabs $0x80459a,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba a9 45 80 00 00 	movabs $0x8045a9,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 2e 0d 80 00 00 	movabs $0x800d2e,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf 95 45 80 00 00 	movabs $0x804595,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba bb 45 80 00 00 	movabs $0x8045bb,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 93 2e 80 00 00 	movabs $0x802e93,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba c9 45 80 00 00 	movabs $0x8045c9,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 2e 0d 80 00 00 	movabs $0x800d2e,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba e0 45 80 00 00 	movabs $0x8045e0,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 2e 0d 80 00 00 	movabs $0x800d2e,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba 10 46 80 00 00 	movabs $0x804610,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 2e 0d 80 00 00 	movabs $0x800d2e,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf 37 46 80 00 00 	movabs $0x804637,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 20          	sub    $0x20,%rsp
  800c82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800c89:	48 b8 e2 23 80 00 00 	movabs $0x8023e2,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c9b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ca0:	48 63 d0             	movslq %eax,%rdx
  800ca3:	48 89 d0             	mov    %rdx,%rax
  800ca6:	48 c1 e0 03          	shl    $0x3,%rax
  800caa:	48 01 d0             	add    %rdx,%rax
  800cad:	48 c1 e0 05          	shl    $0x5,%rax
  800cb1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800cb8:	00 00 00 
  800cbb:	48 01 c2             	add    %rax,%rdx
  800cbe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cc5:	00 00 00 
  800cc8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ccb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800ccf:	7e 14                	jle    800ce5 <libmain+0x6b>
		binaryname = argv[0];
  800cd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800cd5:	48 8b 10             	mov    (%rax),%rdx
  800cd8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cdf:	00 00 00 
  800ce2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ce5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ce9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cec:	48 89 d6             	mov    %rdx,%rsi
  800cef:	89 c7                	mov    %eax,%edi
  800cf1:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cf8:	00 00 00 
  800cfb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cfd:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
}
  800d09:	c9                   	leaveq 
  800d0a:	c3                   	retq   

0000000000800d0b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800d0b:	55                   	push   %rbp
  800d0c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800d0f:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800d1b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d20:	48 b8 9e 23 80 00 00 	movabs $0x80239e,%rax
  800d27:	00 00 00 
  800d2a:	ff d0                	callq  *%rax
}
  800d2c:	5d                   	pop    %rbp
  800d2d:	c3                   	retq   

0000000000800d2e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d2e:	55                   	push   %rbp
  800d2f:	48 89 e5             	mov    %rsp,%rbp
  800d32:	53                   	push   %rbx
  800d33:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d3a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d41:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d47:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d4e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d55:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d5c:	84 c0                	test   %al,%al
  800d5e:	74 23                	je     800d83 <_panic+0x55>
  800d60:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d67:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d6b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d6f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d73:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d77:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d7b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d7f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d83:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d8a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d91:	00 00 00 
  800d94:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d9b:	00 00 00 
  800d9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800da9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800db0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800db7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800dbe:	00 00 00 
  800dc1:	48 8b 18             	mov    (%rax),%rbx
  800dc4:	48 b8 e2 23 80 00 00 	movabs $0x8023e2,%rax
  800dcb:	00 00 00 
  800dce:	ff d0                	callq  *%rax
  800dd0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dd6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ddd:	41 89 c8             	mov    %ecx,%r8d
  800de0:	48 89 d1             	mov    %rdx,%rcx
  800de3:	48 89 da             	mov    %rbx,%rdx
  800de6:	89 c6                	mov    %eax,%esi
  800de8:	48 bf 58 46 80 00 00 	movabs $0x804658,%rdi
  800def:	00 00 00 
  800df2:	b8 00 00 00 00       	mov    $0x0,%eax
  800df7:	49 b9 67 0f 80 00 00 	movabs $0x800f67,%r9
  800dfe:	00 00 00 
  800e01:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e04:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800e0b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e12:	48 89 d6             	mov    %rdx,%rsi
  800e15:	48 89 c7             	mov    %rax,%rdi
  800e18:	48 b8 bb 0e 80 00 00 	movabs $0x800ebb,%rax
  800e1f:	00 00 00 
  800e22:	ff d0                	callq  *%rax
	cprintf("\n");
  800e24:	48 bf 7b 46 80 00 00 	movabs $0x80467b,%rdi
  800e2b:	00 00 00 
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e33:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  800e3a:	00 00 00 
  800e3d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e3f:	cc                   	int3   
  800e40:	eb fd                	jmp    800e3f <_panic+0x111>

0000000000800e42 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800e42:	55                   	push   %rbp
  800e43:	48 89 e5             	mov    %rsp,%rbp
  800e46:	48 83 ec 10          	sub    $0x10,%rsp
  800e4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e55:	8b 00                	mov    (%rax),%eax
  800e57:	8d 48 01             	lea    0x1(%rax),%ecx
  800e5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5e:	89 0a                	mov    %ecx,(%rdx)
  800e60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e63:	89 d1                	mov    %edx,%ecx
  800e65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e69:	48 98                	cltq   
  800e6b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e73:	8b 00                	mov    (%rax),%eax
  800e75:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e7a:	75 2c                	jne    800ea8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e80:	8b 00                	mov    (%rax),%eax
  800e82:	48 98                	cltq   
  800e84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e88:	48 83 c2 08          	add    $0x8,%rdx
  800e8c:	48 89 c6             	mov    %rax,%rsi
  800e8f:	48 89 d7             	mov    %rdx,%rdi
  800e92:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	callq  *%rax
        b->idx = 0;
  800e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eac:	8b 40 04             	mov    0x4(%rax),%eax
  800eaf:	8d 50 01             	lea    0x1(%rax),%edx
  800eb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb6:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eb9:	c9                   	leaveq 
  800eba:	c3                   	retq   

0000000000800ebb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ebb:	55                   	push   %rbp
  800ebc:	48 89 e5             	mov    %rsp,%rbp
  800ebf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ec6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ecd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ed4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800edb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ee2:	48 8b 0a             	mov    (%rdx),%rcx
  800ee5:	48 89 08             	mov    %rcx,(%rax)
  800ee8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ef8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800eff:	00 00 00 
    b.cnt = 0;
  800f02:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800f09:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800f0c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f13:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f1a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f21:	48 89 c6             	mov    %rax,%rsi
  800f24:	48 bf 42 0e 80 00 00 	movabs $0x800e42,%rdi
  800f2b:	00 00 00 
  800f2e:	48 b8 1a 13 80 00 00 	movabs $0x80131a,%rax
  800f35:	00 00 00 
  800f38:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800f3a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f40:	48 98                	cltq   
  800f42:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f49:	48 83 c2 08          	add    $0x8,%rdx
  800f4d:	48 89 c6             	mov    %rax,%rsi
  800f50:	48 89 d7             	mov    %rdx,%rdi
  800f53:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  800f5a:	00 00 00 
  800f5d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f5f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f65:	c9                   	leaveq 
  800f66:	c3                   	retq   

0000000000800f67 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f67:	55                   	push   %rbp
  800f68:	48 89 e5             	mov    %rsp,%rbp
  800f6b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f72:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f79:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f95:	84 c0                	test   %al,%al
  800f97:	74 20                	je     800fb9 <cprintf+0x52>
  800f99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fa1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fa5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fb1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fb5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800fc0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fc7:	00 00 00 
  800fca:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fd1:	00 00 00 
  800fd4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fdf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800fed:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ff4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ffb:	48 8b 0a             	mov    (%rdx),%rcx
  800ffe:	48 89 08             	mov    %rcx,(%rax)
  801001:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801005:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801009:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80100d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801011:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801018:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80101f:	48 89 d6             	mov    %rdx,%rsi
  801022:	48 89 c7             	mov    %rax,%rdi
  801025:	48 b8 bb 0e 80 00 00 	movabs $0x800ebb,%rax
  80102c:	00 00 00 
  80102f:	ff d0                	callq  *%rax
  801031:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801037:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80103d:	c9                   	leaveq 
  80103e:	c3                   	retq   

000000000080103f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	53                   	push   %rbx
  801044:	48 83 ec 38          	sub    $0x38,%rsp
  801048:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801050:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801054:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801057:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80105b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80105f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801062:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801066:	77 3b                	ja     8010a3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801068:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80106b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80106f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801072:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801076:	ba 00 00 00 00       	mov    $0x0,%edx
  80107b:	48 f7 f3             	div    %rbx
  80107e:	48 89 c2             	mov    %rax,%rdx
  801081:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801084:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801087:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80108b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108f:	41 89 f9             	mov    %edi,%r9d
  801092:	48 89 c7             	mov    %rax,%rdi
  801095:	48 b8 3f 10 80 00 00 	movabs $0x80103f,%rax
  80109c:	00 00 00 
  80109f:	ff d0                	callq  *%rax
  8010a1:	eb 1e                	jmp    8010c1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010a3:	eb 12                	jmp    8010b7 <printnum+0x78>
			putch(padc, putdat);
  8010a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010a9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8010ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b0:	48 89 ce             	mov    %rcx,%rsi
  8010b3:	89 d7                	mov    %edx,%edi
  8010b5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010bf:	7f e4                	jg     8010a5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010c1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cd:	48 f7 f1             	div    %rcx
  8010d0:	48 89 d0             	mov    %rdx,%rax
  8010d3:	48 ba 70 48 80 00 00 	movabs $0x804870,%rdx
  8010da:	00 00 00 
  8010dd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010e1:	0f be d0             	movsbl %al,%edx
  8010e4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ec:	48 89 ce             	mov    %rcx,%rsi
  8010ef:	89 d7                	mov    %edx,%edi
  8010f1:	ff d0                	callq  *%rax
}
  8010f3:	48 83 c4 38          	add    $0x38,%rsp
  8010f7:	5b                   	pop    %rbx
  8010f8:	5d                   	pop    %rbp
  8010f9:	c3                   	retq   

00000000008010fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 1c          	sub    $0x1c,%rsp
  801102:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801106:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  801109:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80110d:	7e 52                	jle    801161 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80110f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801113:	8b 00                	mov    (%rax),%eax
  801115:	83 f8 30             	cmp    $0x30,%eax
  801118:	73 24                	jae    80113e <getuint+0x44>
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801126:	8b 00                	mov    (%rax),%eax
  801128:	89 c0                	mov    %eax,%eax
  80112a:	48 01 d0             	add    %rdx,%rax
  80112d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801131:	8b 12                	mov    (%rdx),%edx
  801133:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801136:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80113a:	89 0a                	mov    %ecx,(%rdx)
  80113c:	eb 17                	jmp    801155 <getuint+0x5b>
  80113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801142:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801146:	48 89 d0             	mov    %rdx,%rax
  801149:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80114d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801151:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801155:	48 8b 00             	mov    (%rax),%rax
  801158:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80115c:	e9 a3 00 00 00       	jmpq   801204 <getuint+0x10a>
	else if (lflag)
  801161:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801165:	74 4f                	je     8011b6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	8b 00                	mov    (%rax),%eax
  80116d:	83 f8 30             	cmp    $0x30,%eax
  801170:	73 24                	jae    801196 <getuint+0x9c>
  801172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801176:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	8b 00                	mov    (%rax),%eax
  801180:	89 c0                	mov    %eax,%eax
  801182:	48 01 d0             	add    %rdx,%rax
  801185:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801189:	8b 12                	mov    (%rdx),%edx
  80118b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80118e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801192:	89 0a                	mov    %ecx,(%rdx)
  801194:	eb 17                	jmp    8011ad <getuint+0xb3>
  801196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80119e:	48 89 d0             	mov    %rdx,%rax
  8011a1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011ad:	48 8b 00             	mov    (%rax),%rax
  8011b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011b4:	eb 4e                	jmp    801204 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ba:	8b 00                	mov    (%rax),%eax
  8011bc:	83 f8 30             	cmp    $0x30,%eax
  8011bf:	73 24                	jae    8011e5 <getuint+0xeb>
  8011c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cd:	8b 00                	mov    (%rax),%eax
  8011cf:	89 c0                	mov    %eax,%eax
  8011d1:	48 01 d0             	add    %rdx,%rax
  8011d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d8:	8b 12                	mov    (%rdx),%edx
  8011da:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e1:	89 0a                	mov    %ecx,(%rdx)
  8011e3:	eb 17                	jmp    8011fc <getuint+0x102>
  8011e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011ed:	48 89 d0             	mov    %rdx,%rax
  8011f0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011fc:	8b 00                	mov    (%rax),%eax
  8011fe:	89 c0                	mov    %eax,%eax
  801200:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   

000000000080120a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	48 83 ec 1c          	sub    $0x1c,%rsp
  801212:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801216:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801219:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80121d:	7e 52                	jle    801271 <getint+0x67>
		x=va_arg(*ap, long long);
  80121f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801223:	8b 00                	mov    (%rax),%eax
  801225:	83 f8 30             	cmp    $0x30,%eax
  801228:	73 24                	jae    80124e <getint+0x44>
  80122a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801236:	8b 00                	mov    (%rax),%eax
  801238:	89 c0                	mov    %eax,%eax
  80123a:	48 01 d0             	add    %rdx,%rax
  80123d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801241:	8b 12                	mov    (%rdx),%edx
  801243:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801246:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124a:	89 0a                	mov    %ecx,(%rdx)
  80124c:	eb 17                	jmp    801265 <getint+0x5b>
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801252:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801256:	48 89 d0             	mov    %rdx,%rax
  801259:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80125d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801261:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801265:	48 8b 00             	mov    (%rax),%rax
  801268:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80126c:	e9 a3 00 00 00       	jmpq   801314 <getint+0x10a>
	else if (lflag)
  801271:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801275:	74 4f                	je     8012c6 <getint+0xbc>
		x=va_arg(*ap, long);
  801277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127b:	8b 00                	mov    (%rax),%eax
  80127d:	83 f8 30             	cmp    $0x30,%eax
  801280:	73 24                	jae    8012a6 <getint+0x9c>
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80128a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128e:	8b 00                	mov    (%rax),%eax
  801290:	89 c0                	mov    %eax,%eax
  801292:	48 01 d0             	add    %rdx,%rax
  801295:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801299:	8b 12                	mov    (%rdx),%edx
  80129b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80129e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012a2:	89 0a                	mov    %ecx,(%rdx)
  8012a4:	eb 17                	jmp    8012bd <getint+0xb3>
  8012a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012ae:	48 89 d0             	mov    %rdx,%rax
  8012b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012bd:	48 8b 00             	mov    (%rax),%rax
  8012c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012c4:	eb 4e                	jmp    801314 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ca:	8b 00                	mov    (%rax),%eax
  8012cc:	83 f8 30             	cmp    $0x30,%eax
  8012cf:	73 24                	jae    8012f5 <getint+0xeb>
  8012d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dd:	8b 00                	mov    (%rax),%eax
  8012df:	89 c0                	mov    %eax,%eax
  8012e1:	48 01 d0             	add    %rdx,%rax
  8012e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e8:	8b 12                	mov    (%rdx),%edx
  8012ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f1:	89 0a                	mov    %ecx,(%rdx)
  8012f3:	eb 17                	jmp    80130c <getint+0x102>
  8012f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012fd:	48 89 d0             	mov    %rdx,%rax
  801300:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801304:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801308:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80130c:	8b 00                	mov    (%rax),%eax
  80130e:	48 98                	cltq   
  801310:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801318:	c9                   	leaveq 
  801319:	c3                   	retq   

000000000080131a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80131a:	55                   	push   %rbp
  80131b:	48 89 e5             	mov    %rsp,%rbp
  80131e:	41 54                	push   %r12
  801320:	53                   	push   %rbx
  801321:	48 83 ec 60          	sub    $0x60,%rsp
  801325:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801329:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80132d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801331:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801335:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801339:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80133d:	48 8b 0a             	mov    (%rdx),%rcx
  801340:	48 89 08             	mov    %rcx,(%rax)
  801343:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801347:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80134b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80134f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801353:	eb 17                	jmp    80136c <vprintfmt+0x52>
			if (ch == '\0')
  801355:	85 db                	test   %ebx,%ebx
  801357:	0f 84 df 04 00 00    	je     80183c <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80135d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801361:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801365:	48 89 d6             	mov    %rdx,%rsi
  801368:	89 df                	mov    %ebx,%edi
  80136a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80136c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801370:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801374:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801378:	0f b6 00             	movzbl (%rax),%eax
  80137b:	0f b6 d8             	movzbl %al,%ebx
  80137e:	83 fb 25             	cmp    $0x25,%ebx
  801381:	75 d2                	jne    801355 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801383:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801387:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80138e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801395:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80139c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013ab:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	0f b6 d8             	movzbl %al,%ebx
  8013b5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8013b8:	83 f8 55             	cmp    $0x55,%eax
  8013bb:	0f 87 47 04 00 00    	ja     801808 <vprintfmt+0x4ee>
  8013c1:	89 c0                	mov    %eax,%eax
  8013c3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013ca:	00 
  8013cb:	48 b8 98 48 80 00 00 	movabs $0x804898,%rax
  8013d2:	00 00 00 
  8013d5:	48 01 d0             	add    %rdx,%rax
  8013d8:	48 8b 00             	mov    (%rax),%rax
  8013db:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8013dd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013e1:	eb c0                	jmp    8013a3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013e3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013e7:	eb ba                	jmp    8013a3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013e9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013f0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	c1 e0 02             	shl    $0x2,%eax
  8013f8:	01 d0                	add    %edx,%eax
  8013fa:	01 c0                	add    %eax,%eax
  8013fc:	01 d8                	add    %ebx,%eax
  8013fe:	83 e8 30             	sub    $0x30,%eax
  801401:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801404:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801408:	0f b6 00             	movzbl (%rax),%eax
  80140b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80140e:	83 fb 2f             	cmp    $0x2f,%ebx
  801411:	7e 0c                	jle    80141f <vprintfmt+0x105>
  801413:	83 fb 39             	cmp    $0x39,%ebx
  801416:	7f 07                	jg     80141f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801418:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80141d:	eb d1                	jmp    8013f0 <vprintfmt+0xd6>
			goto process_precision;
  80141f:	eb 58                	jmp    801479 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801421:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801424:	83 f8 30             	cmp    $0x30,%eax
  801427:	73 17                	jae    801440 <vprintfmt+0x126>
  801429:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80142d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801430:	89 c0                	mov    %eax,%eax
  801432:	48 01 d0             	add    %rdx,%rax
  801435:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801438:	83 c2 08             	add    $0x8,%edx
  80143b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80143e:	eb 0f                	jmp    80144f <vprintfmt+0x135>
  801440:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801444:	48 89 d0             	mov    %rdx,%rax
  801447:	48 83 c2 08          	add    $0x8,%rdx
  80144b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80144f:	8b 00                	mov    (%rax),%eax
  801451:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801454:	eb 23                	jmp    801479 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801456:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80145a:	79 0c                	jns    801468 <vprintfmt+0x14e>
				width = 0;
  80145c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801463:	e9 3b ff ff ff       	jmpq   8013a3 <vprintfmt+0x89>
  801468:	e9 36 ff ff ff       	jmpq   8013a3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80146d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801474:	e9 2a ff ff ff       	jmpq   8013a3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801479:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80147d:	79 12                	jns    801491 <vprintfmt+0x177>
				width = precision, precision = -1;
  80147f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801482:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801485:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80148c:	e9 12 ff ff ff       	jmpq   8013a3 <vprintfmt+0x89>
  801491:	e9 0d ff ff ff       	jmpq   8013a3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801496:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80149a:	e9 04 ff ff ff       	jmpq   8013a3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80149f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a2:	83 f8 30             	cmp    $0x30,%eax
  8014a5:	73 17                	jae    8014be <vprintfmt+0x1a4>
  8014a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014ae:	89 c0                	mov    %eax,%eax
  8014b0:	48 01 d0             	add    %rdx,%rax
  8014b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b6:	83 c2 08             	add    $0x8,%edx
  8014b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014bc:	eb 0f                	jmp    8014cd <vprintfmt+0x1b3>
  8014be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014c2:	48 89 d0             	mov    %rdx,%rax
  8014c5:	48 83 c2 08          	add    $0x8,%rdx
  8014c9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014cd:	8b 10                	mov    (%rax),%edx
  8014cf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d7:	48 89 ce             	mov    %rcx,%rsi
  8014da:	89 d7                	mov    %edx,%edi
  8014dc:	ff d0                	callq  *%rax
			break;
  8014de:	e9 53 03 00 00       	jmpq   801836 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8014e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e6:	83 f8 30             	cmp    $0x30,%eax
  8014e9:	73 17                	jae    801502 <vprintfmt+0x1e8>
  8014eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014f2:	89 c0                	mov    %eax,%eax
  8014f4:	48 01 d0             	add    %rdx,%rax
  8014f7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014fa:	83 c2 08             	add    $0x8,%edx
  8014fd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801500:	eb 0f                	jmp    801511 <vprintfmt+0x1f7>
  801502:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801506:	48 89 d0             	mov    %rdx,%rax
  801509:	48 83 c2 08          	add    $0x8,%rdx
  80150d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801511:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801513:	85 db                	test   %ebx,%ebx
  801515:	79 02                	jns    801519 <vprintfmt+0x1ff>
				err = -err;
  801517:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801519:	83 fb 15             	cmp    $0x15,%ebx
  80151c:	7f 16                	jg     801534 <vprintfmt+0x21a>
  80151e:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  801525:	00 00 00 
  801528:	48 63 d3             	movslq %ebx,%rdx
  80152b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80152f:	4d 85 e4             	test   %r12,%r12
  801532:	75 2e                	jne    801562 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801534:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801538:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80153c:	89 d9                	mov    %ebx,%ecx
  80153e:	48 ba 81 48 80 00 00 	movabs $0x804881,%rdx
  801545:	00 00 00 
  801548:	48 89 c7             	mov    %rax,%rdi
  80154b:	b8 00 00 00 00       	mov    $0x0,%eax
  801550:	49 b8 45 18 80 00 00 	movabs $0x801845,%r8
  801557:	00 00 00 
  80155a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80155d:	e9 d4 02 00 00       	jmpq   801836 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801562:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801566:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80156a:	4c 89 e1             	mov    %r12,%rcx
  80156d:	48 ba 8a 48 80 00 00 	movabs $0x80488a,%rdx
  801574:	00 00 00 
  801577:	48 89 c7             	mov    %rax,%rdi
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
  80157f:	49 b8 45 18 80 00 00 	movabs $0x801845,%r8
  801586:	00 00 00 
  801589:	41 ff d0             	callq  *%r8
			break;
  80158c:	e9 a5 02 00 00       	jmpq   801836 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801591:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801594:	83 f8 30             	cmp    $0x30,%eax
  801597:	73 17                	jae    8015b0 <vprintfmt+0x296>
  801599:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80159d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015a0:	89 c0                	mov    %eax,%eax
  8015a2:	48 01 d0             	add    %rdx,%rax
  8015a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8015a8:	83 c2 08             	add    $0x8,%edx
  8015ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015ae:	eb 0f                	jmp    8015bf <vprintfmt+0x2a5>
  8015b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015b4:	48 89 d0             	mov    %rdx,%rax
  8015b7:	48 83 c2 08          	add    $0x8,%rdx
  8015bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015bf:	4c 8b 20             	mov    (%rax),%r12
  8015c2:	4d 85 e4             	test   %r12,%r12
  8015c5:	75 0a                	jne    8015d1 <vprintfmt+0x2b7>
				p = "(null)";
  8015c7:	49 bc 8d 48 80 00 00 	movabs $0x80488d,%r12
  8015ce:	00 00 00 
			if (width > 0 && padc != '-')
  8015d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015d5:	7e 3f                	jle    801616 <vprintfmt+0x2fc>
  8015d7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015db:	74 39                	je     801616 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015dd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015e0:	48 98                	cltq   
  8015e2:	48 89 c6             	mov    %rax,%rsi
  8015e5:	4c 89 e7             	mov    %r12,%rdi
  8015e8:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8015ef:	00 00 00 
  8015f2:	ff d0                	callq  *%rax
  8015f4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015f7:	eb 17                	jmp    801610 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8015f9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8015fd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801601:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801605:	48 89 ce             	mov    %rcx,%rsi
  801608:	89 d7                	mov    %edx,%edi
  80160a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80160c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801610:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801614:	7f e3                	jg     8015f9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801616:	eb 37                	jmp    80164f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801618:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80161c:	74 1e                	je     80163c <vprintfmt+0x322>
  80161e:	83 fb 1f             	cmp    $0x1f,%ebx
  801621:	7e 05                	jle    801628 <vprintfmt+0x30e>
  801623:	83 fb 7e             	cmp    $0x7e,%ebx
  801626:	7e 14                	jle    80163c <vprintfmt+0x322>
					putch('?', putdat);
  801628:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80162c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801630:	48 89 d6             	mov    %rdx,%rsi
  801633:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801638:	ff d0                	callq  *%rax
  80163a:	eb 0f                	jmp    80164b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80163c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801640:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801644:	48 89 d6             	mov    %rdx,%rsi
  801647:	89 df                	mov    %ebx,%edi
  801649:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80164b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80164f:	4c 89 e0             	mov    %r12,%rax
  801652:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	0f be d8             	movsbl %al,%ebx
  80165c:	85 db                	test   %ebx,%ebx
  80165e:	74 10                	je     801670 <vprintfmt+0x356>
  801660:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801664:	78 b2                	js     801618 <vprintfmt+0x2fe>
  801666:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80166a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166e:	79 a8                	jns    801618 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801670:	eb 16                	jmp    801688 <vprintfmt+0x36e>
				putch(' ', putdat);
  801672:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801676:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80167a:	48 89 d6             	mov    %rdx,%rsi
  80167d:	bf 20 00 00 00       	mov    $0x20,%edi
  801682:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801684:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801688:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80168c:	7f e4                	jg     801672 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80168e:	e9 a3 01 00 00       	jmpq   801836 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801693:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801697:	be 03 00 00 00       	mov    $0x3,%esi
  80169c:	48 89 c7             	mov    %rax,%rdi
  80169f:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  8016a6:	00 00 00 
  8016a9:	ff d0                	callq  *%rax
  8016ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b3:	48 85 c0             	test   %rax,%rax
  8016b6:	79 1d                	jns    8016d5 <vprintfmt+0x3bb>
				putch('-', putdat);
  8016b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016c0:	48 89 d6             	mov    %rdx,%rsi
  8016c3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016c8:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ce:	48 f7 d8             	neg    %rax
  8016d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016d5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016dc:	e9 e8 00 00 00       	jmpq   8017c9 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016e1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016e5:	be 03 00 00 00       	mov    $0x3,%esi
  8016ea:	48 89 c7             	mov    %rax,%rdi
  8016ed:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  8016f4:	00 00 00 
  8016f7:	ff d0                	callq  *%rax
  8016f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016fd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801704:	e9 c0 00 00 00       	jmpq   8017c9 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801709:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80170d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801711:	48 89 d6             	mov    %rdx,%rsi
  801714:	bf 58 00 00 00       	mov    $0x58,%edi
  801719:	ff d0                	callq  *%rax
			putch('X', putdat);
  80171b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80171f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801723:	48 89 d6             	mov    %rdx,%rsi
  801726:	bf 58 00 00 00       	mov    $0x58,%edi
  80172b:	ff d0                	callq  *%rax
			putch('X', putdat);
  80172d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801731:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801735:	48 89 d6             	mov    %rdx,%rsi
  801738:	bf 58 00 00 00       	mov    $0x58,%edi
  80173d:	ff d0                	callq  *%rax
			break;
  80173f:	e9 f2 00 00 00       	jmpq   801836 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  801744:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801748:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80174c:	48 89 d6             	mov    %rdx,%rsi
  80174f:	bf 30 00 00 00       	mov    $0x30,%edi
  801754:	ff d0                	callq  *%rax
			putch('x', putdat);
  801756:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80175a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80175e:	48 89 d6             	mov    %rdx,%rsi
  801761:	bf 78 00 00 00       	mov    $0x78,%edi
  801766:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801768:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80176b:	83 f8 30             	cmp    $0x30,%eax
  80176e:	73 17                	jae    801787 <vprintfmt+0x46d>
  801770:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801774:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801777:	89 c0                	mov    %eax,%eax
  801779:	48 01 d0             	add    %rdx,%rax
  80177c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80177f:	83 c2 08             	add    $0x8,%edx
  801782:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801785:	eb 0f                	jmp    801796 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  801787:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80178b:	48 89 d0             	mov    %rdx,%rax
  80178e:	48 83 c2 08          	add    $0x8,%rdx
  801792:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801796:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801799:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80179d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8017a4:	eb 23                	jmp    8017c9 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8017a6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8017aa:	be 03 00 00 00       	mov    $0x3,%esi
  8017af:	48 89 c7             	mov    %rax,%rdi
  8017b2:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  8017b9:	00 00 00 
  8017bc:	ff d0                	callq  *%rax
  8017be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017c2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017c9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017ce:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017d1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017e0:	45 89 c1             	mov    %r8d,%r9d
  8017e3:	41 89 f8             	mov    %edi,%r8d
  8017e6:	48 89 c7             	mov    %rax,%rdi
  8017e9:	48 b8 3f 10 80 00 00 	movabs $0x80103f,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
			break;
  8017f5:	eb 3f                	jmp    801836 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ff:	48 89 d6             	mov    %rdx,%rsi
  801802:	89 df                	mov    %ebx,%edi
  801804:	ff d0                	callq  *%rax
			break;
  801806:	eb 2e                	jmp    801836 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801808:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80180c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801810:	48 89 d6             	mov    %rdx,%rsi
  801813:	bf 25 00 00 00       	mov    $0x25,%edi
  801818:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80181a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80181f:	eb 05                	jmp    801826 <vprintfmt+0x50c>
  801821:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801826:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80182a:	48 83 e8 01          	sub    $0x1,%rax
  80182e:	0f b6 00             	movzbl (%rax),%eax
  801831:	3c 25                	cmp    $0x25,%al
  801833:	75 ec                	jne    801821 <vprintfmt+0x507>
				/* do nothing */;
			break;
  801835:	90                   	nop
		}
	}
  801836:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801837:	e9 30 fb ff ff       	jmpq   80136c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80183c:	48 83 c4 60          	add    $0x60,%rsp
  801840:	5b                   	pop    %rbx
  801841:	41 5c                	pop    %r12
  801843:	5d                   	pop    %rbp
  801844:	c3                   	retq   

0000000000801845 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801845:	55                   	push   %rbp
  801846:	48 89 e5             	mov    %rsp,%rbp
  801849:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801850:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801857:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80185e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801865:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80186c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801873:	84 c0                	test   %al,%al
  801875:	74 20                	je     801897 <printfmt+0x52>
  801877:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80187b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80187f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801883:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801887:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80188b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80188f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801893:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801897:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80189e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8018a5:	00 00 00 
  8018a8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8018af:	00 00 00 
  8018b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8018b6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8018bd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018c4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018cb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018d2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018d9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8018e0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8018e7:	48 89 c7             	mov    %rax,%rdi
  8018ea:	48 b8 1a 13 80 00 00 	movabs $0x80131a,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	callq  *%rax
	va_end(ap);
}
  8018f6:	c9                   	leaveq 
  8018f7:	c3                   	retq   

00000000008018f8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 10          	sub    $0x10,%rsp
  801900:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801903:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190b:	8b 40 10             	mov    0x10(%rax),%eax
  80190e:	8d 50 01             	lea    0x1(%rax),%edx
  801911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801915:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191c:	48 8b 10             	mov    (%rax),%rdx
  80191f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801923:	48 8b 40 08          	mov    0x8(%rax),%rax
  801927:	48 39 c2             	cmp    %rax,%rdx
  80192a:	73 17                	jae    801943 <sprintputch+0x4b>
		*b->buf++ = ch;
  80192c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801930:	48 8b 00             	mov    (%rax),%rax
  801933:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801937:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193b:	48 89 0a             	mov    %rcx,(%rdx)
  80193e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801941:	88 10                	mov    %dl,(%rax)
}
  801943:	c9                   	leaveq 
  801944:	c3                   	retq   

0000000000801945 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801945:	55                   	push   %rbp
  801946:	48 89 e5             	mov    %rsp,%rbp
  801949:	48 83 ec 50          	sub    $0x50,%rsp
  80194d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801951:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801954:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801958:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80195c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801960:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801964:	48 8b 0a             	mov    (%rdx),%rcx
  801967:	48 89 08             	mov    %rcx,(%rax)
  80196a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80196e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801972:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801976:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80197a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80197e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801982:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801985:	48 98                	cltq   
  801987:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80198b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80198f:	48 01 d0             	add    %rdx,%rax
  801992:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801996:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80199d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8019a2:	74 06                	je     8019aa <vsnprintf+0x65>
  8019a4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8019a8:	7f 07                	jg     8019b1 <vsnprintf+0x6c>
		return -E_INVAL;
  8019aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019af:	eb 2f                	jmp    8019e0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8019b1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8019b5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8019b9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8019bd:	48 89 c6             	mov    %rax,%rsi
  8019c0:	48 bf f8 18 80 00 00 	movabs $0x8018f8,%rdi
  8019c7:	00 00 00 
  8019ca:	48 b8 1a 13 80 00 00 	movabs $0x80131a,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019da:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019dd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8019e0:	c9                   	leaveq 
  8019e1:	c3                   	retq   

00000000008019e2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019e2:	55                   	push   %rbp
  8019e3:	48 89 e5             	mov    %rsp,%rbp
  8019e6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8019ed:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8019f4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8019fa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801a01:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801a08:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801a0f:	84 c0                	test   %al,%al
  801a11:	74 20                	je     801a33 <snprintf+0x51>
  801a13:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801a17:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801a1b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801a1f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a23:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a27:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a2b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a2f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a33:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a3a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a41:	00 00 00 
  801a44:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a4b:	00 00 00 
  801a4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a52:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a59:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a60:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a67:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a6e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a75:	48 8b 0a             	mov    (%rdx),%rcx
  801a78:	48 89 08             	mov    %rcx,(%rax)
  801a7b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a7f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a83:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a87:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a8b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a92:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a99:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a9f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801aa6:	48 89 c7             	mov    %rax,%rdi
  801aa9:	48 b8 45 19 80 00 00 	movabs $0x801945,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	callq  *%rax
  801ab5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801abb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   

0000000000801ac3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	48 83 ec 18          	sub    $0x18,%rsp
  801acb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801acf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ad6:	eb 09                	jmp    801ae1 <strlen+0x1e>
		n++;
  801ad8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801adc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae5:	0f b6 00             	movzbl (%rax),%eax
  801ae8:	84 c0                	test   %al,%al
  801aea:	75 ec                	jne    801ad8 <strlen+0x15>
		n++;
	return n;
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801aef:	c9                   	leaveq 
  801af0:	c3                   	retq   

0000000000801af1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
  801af5:	48 83 ec 20          	sub    $0x20,%rsp
  801af9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801afd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b08:	eb 0e                	jmp    801b18 <strnlen+0x27>
		n++;
  801b0a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b0e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801b13:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801b18:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b1d:	74 0b                	je     801b2a <strnlen+0x39>
  801b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b23:	0f b6 00             	movzbl (%rax),%eax
  801b26:	84 c0                	test   %al,%al
  801b28:	75 e0                	jne    801b0a <strnlen+0x19>
		n++;
	return n;
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b2d:	c9                   	leaveq 
  801b2e:	c3                   	retq   

0000000000801b2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b2f:	55                   	push   %rbp
  801b30:	48 89 e5             	mov    %rsp,%rbp
  801b33:	48 83 ec 20          	sub    $0x20,%rsp
  801b37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b47:	90                   	nop
  801b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b4c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b50:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b54:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b58:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b5c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b60:	0f b6 12             	movzbl (%rdx),%edx
  801b63:	88 10                	mov    %dl,(%rax)
  801b65:	0f b6 00             	movzbl (%rax),%eax
  801b68:	84 c0                	test   %al,%al
  801b6a:	75 dc                	jne    801b48 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b86:	48 89 c7             	mov    %rax,%rdi
  801b89:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	callq  *%rax
  801b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9b:	48 63 d0             	movslq %eax,%rdx
  801b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba2:	48 01 c2             	add    %rax,%rdx
  801ba5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba9:	48 89 c6             	mov    %rax,%rsi
  801bac:	48 89 d7             	mov    %rdx,%rdi
  801baf:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  801bb6:	00 00 00 
  801bb9:	ff d0                	callq  *%rax
	return dst;
  801bbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bbf:	c9                   	leaveq 
  801bc0:	c3                   	retq   

0000000000801bc1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc1:	55                   	push   %rbp
  801bc2:	48 89 e5             	mov    %rsp,%rbp
  801bc5:	48 83 ec 28          	sub    $0x28,%rsp
  801bc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bdd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801be4:	00 
  801be5:	eb 2a                	jmp    801c11 <strncpy+0x50>
		*dst++ = *src;
  801be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801beb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bf7:	0f b6 12             	movzbl (%rdx),%edx
  801bfa:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801bfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c00:	0f b6 00             	movzbl (%rax),%eax
  801c03:	84 c0                	test   %al,%al
  801c05:	74 05                	je     801c0c <strncpy+0x4b>
			src++;
  801c07:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c0c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c15:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801c19:	72 cc                	jb     801be7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c1f:	c9                   	leaveq 
  801c20:	c3                   	retq   

0000000000801c21 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c21:	55                   	push   %rbp
  801c22:	48 89 e5             	mov    %rsp,%rbp
  801c25:	48 83 ec 28          	sub    $0x28,%rsp
  801c29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c31:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c3d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c42:	74 3d                	je     801c81 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801c44:	eb 1d                	jmp    801c63 <strlcpy+0x42>
			*dst++ = *src++;
  801c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c56:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801c5a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801c5e:	0f b6 12             	movzbl (%rdx),%edx
  801c61:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c63:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c68:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c6d:	74 0b                	je     801c7a <strlcpy+0x59>
  801c6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c73:	0f b6 00             	movzbl (%rax),%eax
  801c76:	84 c0                	test   %al,%al
  801c78:	75 cc                	jne    801c46 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c7e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c89:	48 29 c2             	sub    %rax,%rdx
  801c8c:	48 89 d0             	mov    %rdx,%rax
}
  801c8f:	c9                   	leaveq 
  801c90:	c3                   	retq   

0000000000801c91 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c91:	55                   	push   %rbp
  801c92:	48 89 e5             	mov    %rsp,%rbp
  801c95:	48 83 ec 10          	sub    $0x10,%rsp
  801c99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801ca1:	eb 0a                	jmp    801cad <strcmp+0x1c>
		p++, q++;
  801ca3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ca8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb1:	0f b6 00             	movzbl (%rax),%eax
  801cb4:	84 c0                	test   %al,%al
  801cb6:	74 12                	je     801cca <strcmp+0x39>
  801cb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbc:	0f b6 10             	movzbl (%rax),%edx
  801cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc3:	0f b6 00             	movzbl (%rax),%eax
  801cc6:	38 c2                	cmp    %al,%dl
  801cc8:	74 d9                	je     801ca3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cce:	0f b6 00             	movzbl (%rax),%eax
  801cd1:	0f b6 d0             	movzbl %al,%edx
  801cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd8:	0f b6 00             	movzbl (%rax),%eax
  801cdb:	0f b6 c0             	movzbl %al,%eax
  801cde:	29 c2                	sub    %eax,%edx
  801ce0:	89 d0                	mov    %edx,%eax
}
  801ce2:	c9                   	leaveq 
  801ce3:	c3                   	retq   

0000000000801ce4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ce4:	55                   	push   %rbp
  801ce5:	48 89 e5             	mov    %rsp,%rbp
  801ce8:	48 83 ec 18          	sub    $0x18,%rsp
  801cec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801cf8:	eb 0f                	jmp    801d09 <strncmp+0x25>
		n--, p++, q++;
  801cfa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801cff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d04:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801d09:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d0e:	74 1d                	je     801d2d <strncmp+0x49>
  801d10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d14:	0f b6 00             	movzbl (%rax),%eax
  801d17:	84 c0                	test   %al,%al
  801d19:	74 12                	je     801d2d <strncmp+0x49>
  801d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1f:	0f b6 10             	movzbl (%rax),%edx
  801d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d26:	0f b6 00             	movzbl (%rax),%eax
  801d29:	38 c2                	cmp    %al,%dl
  801d2b:	74 cd                	je     801cfa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d2d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d32:	75 07                	jne    801d3b <strncmp+0x57>
		return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	eb 18                	jmp    801d53 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	0f b6 00             	movzbl (%rax),%eax
  801d42:	0f b6 d0             	movzbl %al,%edx
  801d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d49:	0f b6 00             	movzbl (%rax),%eax
  801d4c:	0f b6 c0             	movzbl %al,%eax
  801d4f:	29 c2                	sub    %eax,%edx
  801d51:	89 d0                	mov    %edx,%eax
}
  801d53:	c9                   	leaveq 
  801d54:	c3                   	retq   

0000000000801d55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d55:	55                   	push   %rbp
  801d56:	48 89 e5             	mov    %rsp,%rbp
  801d59:	48 83 ec 0c          	sub    $0xc,%rsp
  801d5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d61:	89 f0                	mov    %esi,%eax
  801d63:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d66:	eb 17                	jmp    801d7f <strchr+0x2a>
		if (*s == c)
  801d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6c:	0f b6 00             	movzbl (%rax),%eax
  801d6f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d72:	75 06                	jne    801d7a <strchr+0x25>
			return (char *) s;
  801d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d78:	eb 15                	jmp    801d8f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d7a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d83:	0f b6 00             	movzbl (%rax),%eax
  801d86:	84 c0                	test   %al,%al
  801d88:	75 de                	jne    801d68 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8f:	c9                   	leaveq 
  801d90:	c3                   	retq   

0000000000801d91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	48 83 ec 0c          	sub    $0xc,%rsp
  801d99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801da2:	eb 13                	jmp    801db7 <strfind+0x26>
		if (*s == c)
  801da4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da8:	0f b6 00             	movzbl (%rax),%eax
  801dab:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801dae:	75 02                	jne    801db2 <strfind+0x21>
			break;
  801db0:	eb 10                	jmp    801dc2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801db2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbb:	0f b6 00             	movzbl (%rax),%eax
  801dbe:	84 c0                	test   %al,%al
  801dc0:	75 e2                	jne    801da4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801dc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801dc6:	c9                   	leaveq 
  801dc7:	c3                   	retq   

0000000000801dc8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801dc8:	55                   	push   %rbp
  801dc9:	48 89 e5             	mov    %rsp,%rbp
  801dcc:	48 83 ec 18          	sub    $0x18,%rsp
  801dd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dd4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801dd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801ddb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801de0:	75 06                	jne    801de8 <memset+0x20>
		return v;
  801de2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de6:	eb 69                	jmp    801e51 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dec:	83 e0 03             	and    $0x3,%eax
  801def:	48 85 c0             	test   %rax,%rax
  801df2:	75 48                	jne    801e3c <memset+0x74>
  801df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df8:	83 e0 03             	and    $0x3,%eax
  801dfb:	48 85 c0             	test   %rax,%rax
  801dfe:	75 3c                	jne    801e3c <memset+0x74>
		c &= 0xFF;
  801e00:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e0a:	c1 e0 18             	shl    $0x18,%eax
  801e0d:	89 c2                	mov    %eax,%edx
  801e0f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e12:	c1 e0 10             	shl    $0x10,%eax
  801e15:	09 c2                	or     %eax,%edx
  801e17:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e1a:	c1 e0 08             	shl    $0x8,%eax
  801e1d:	09 d0                	or     %edx,%eax
  801e1f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e26:	48 c1 e8 02          	shr    $0x2,%rax
  801e2a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e2d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e31:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e34:	48 89 d7             	mov    %rdx,%rdi
  801e37:	fc                   	cld    
  801e38:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e3a:	eb 11                	jmp    801e4d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e40:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e47:	48 89 d7             	mov    %rdx,%rdi
  801e4a:	fc                   	cld    
  801e4b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e51:	c9                   	leaveq 
  801e52:	c3                   	retq   

0000000000801e53 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e53:	55                   	push   %rbp
  801e54:	48 89 e5             	mov    %rsp,%rbp
  801e57:	48 83 ec 28          	sub    $0x28,%rsp
  801e5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e7f:	0f 83 88 00 00 00    	jae    801f0d <memmove+0xba>
  801e85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e89:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e8d:	48 01 d0             	add    %rdx,%rax
  801e90:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e94:	76 77                	jbe    801f0d <memmove+0xba>
		s += n;
  801e96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eaa:	83 e0 03             	and    $0x3,%eax
  801ead:	48 85 c0             	test   %rax,%rax
  801eb0:	75 3b                	jne    801eed <memmove+0x9a>
  801eb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb6:	83 e0 03             	and    $0x3,%eax
  801eb9:	48 85 c0             	test   %rax,%rax
  801ebc:	75 2f                	jne    801eed <memmove+0x9a>
  801ebe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec2:	83 e0 03             	and    $0x3,%eax
  801ec5:	48 85 c0             	test   %rax,%rax
  801ec8:	75 23                	jne    801eed <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ece:	48 83 e8 04          	sub    $0x4,%rax
  801ed2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed6:	48 83 ea 04          	sub    $0x4,%rdx
  801eda:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ede:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ee2:	48 89 c7             	mov    %rax,%rdi
  801ee5:	48 89 d6             	mov    %rdx,%rsi
  801ee8:	fd                   	std    
  801ee9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801eeb:	eb 1d                	jmp    801f0a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ef5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f01:	48 89 d7             	mov    %rdx,%rdi
  801f04:	48 89 c1             	mov    %rax,%rcx
  801f07:	fd                   	std    
  801f08:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f0a:	fc                   	cld    
  801f0b:	eb 57                	jmp    801f64 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801f0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f11:	83 e0 03             	and    $0x3,%eax
  801f14:	48 85 c0             	test   %rax,%rax
  801f17:	75 36                	jne    801f4f <memmove+0xfc>
  801f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1d:	83 e0 03             	and    $0x3,%eax
  801f20:	48 85 c0             	test   %rax,%rax
  801f23:	75 2a                	jne    801f4f <memmove+0xfc>
  801f25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f29:	83 e0 03             	and    $0x3,%eax
  801f2c:	48 85 c0             	test   %rax,%rax
  801f2f:	75 1e                	jne    801f4f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f35:	48 c1 e8 02          	shr    $0x2,%rax
  801f39:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f40:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f44:	48 89 c7             	mov    %rax,%rdi
  801f47:	48 89 d6             	mov    %rdx,%rsi
  801f4a:	fc                   	cld    
  801f4b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f4d:	eb 15                	jmp    801f64 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f53:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f57:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f5b:	48 89 c7             	mov    %rax,%rdi
  801f5e:	48 89 d6             	mov    %rdx,%rsi
  801f61:	fc                   	cld    
  801f62:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f68:	c9                   	leaveq 
  801f69:	c3                   	retq   

0000000000801f6a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f6a:	55                   	push   %rbp
  801f6b:	48 89 e5             	mov    %rsp,%rbp
  801f6e:	48 83 ec 18          	sub    $0x18,%rsp
  801f72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f82:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8a:	48 89 ce             	mov    %rcx,%rsi
  801f8d:	48 89 c7             	mov    %rax,%rdi
  801f90:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  801f97:	00 00 00 
  801f9a:	ff d0                	callq  *%rax
}
  801f9c:	c9                   	leaveq 
  801f9d:	c3                   	retq   

0000000000801f9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f9e:	55                   	push   %rbp
  801f9f:	48 89 e5             	mov    %rsp,%rbp
  801fa2:	48 83 ec 28          	sub    $0x28,%rsp
  801fa6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801faa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fbe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fc2:	eb 36                	jmp    801ffa <memcmp+0x5c>
		if (*s1 != *s2)
  801fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc8:	0f b6 10             	movzbl (%rax),%edx
  801fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fcf:	0f b6 00             	movzbl (%rax),%eax
  801fd2:	38 c2                	cmp    %al,%dl
  801fd4:	74 1a                	je     801ff0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fda:	0f b6 00             	movzbl (%rax),%eax
  801fdd:	0f b6 d0             	movzbl %al,%edx
  801fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe4:	0f b6 00             	movzbl (%rax),%eax
  801fe7:	0f b6 c0             	movzbl %al,%eax
  801fea:	29 c2                	sub    %eax,%edx
  801fec:	89 d0                	mov    %edx,%eax
  801fee:	eb 20                	jmp    802010 <memcmp+0x72>
		s1++, s2++;
  801ff0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ff5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ffa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802002:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802006:	48 85 c0             	test   %rax,%rax
  802009:	75 b9                	jne    801fc4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802010:	c9                   	leaveq 
  802011:	c3                   	retq   

0000000000802012 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802012:	55                   	push   %rbp
  802013:	48 89 e5             	mov    %rsp,%rbp
  802016:	48 83 ec 28          	sub    $0x28,%rsp
  80201a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80201e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802021:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802025:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802029:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80202d:	48 01 d0             	add    %rdx,%rax
  802030:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802034:	eb 15                	jmp    80204b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203a:	0f b6 10             	movzbl (%rax),%edx
  80203d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802040:	38 c2                	cmp    %al,%dl
  802042:	75 02                	jne    802046 <memfind+0x34>
			break;
  802044:	eb 0f                	jmp    802055 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802046:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80204b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802053:	72 e1                	jb     802036 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802059:	c9                   	leaveq 
  80205a:	c3                   	retq   

000000000080205b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80205b:	55                   	push   %rbp
  80205c:	48 89 e5             	mov    %rsp,%rbp
  80205f:	48 83 ec 34          	sub    $0x34,%rsp
  802063:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802067:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80206b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80206e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802075:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80207c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80207d:	eb 05                	jmp    802084 <strtol+0x29>
		s++;
  80207f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802088:	0f b6 00             	movzbl (%rax),%eax
  80208b:	3c 20                	cmp    $0x20,%al
  80208d:	74 f0                	je     80207f <strtol+0x24>
  80208f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802093:	0f b6 00             	movzbl (%rax),%eax
  802096:	3c 09                	cmp    $0x9,%al
  802098:	74 e5                	je     80207f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80209a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209e:	0f b6 00             	movzbl (%rax),%eax
  8020a1:	3c 2b                	cmp    $0x2b,%al
  8020a3:	75 07                	jne    8020ac <strtol+0x51>
		s++;
  8020a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020aa:	eb 17                	jmp    8020c3 <strtol+0x68>
	else if (*s == '-')
  8020ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b0:	0f b6 00             	movzbl (%rax),%eax
  8020b3:	3c 2d                	cmp    $0x2d,%al
  8020b5:	75 0c                	jne    8020c3 <strtol+0x68>
		s++, neg = 1;
  8020b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020c7:	74 06                	je     8020cf <strtol+0x74>
  8020c9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020cd:	75 28                	jne    8020f7 <strtol+0x9c>
  8020cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d3:	0f b6 00             	movzbl (%rax),%eax
  8020d6:	3c 30                	cmp    $0x30,%al
  8020d8:	75 1d                	jne    8020f7 <strtol+0x9c>
  8020da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020de:	48 83 c0 01          	add    $0x1,%rax
  8020e2:	0f b6 00             	movzbl (%rax),%eax
  8020e5:	3c 78                	cmp    $0x78,%al
  8020e7:	75 0e                	jne    8020f7 <strtol+0x9c>
		s += 2, base = 16;
  8020e9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8020ee:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8020f5:	eb 2c                	jmp    802123 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8020f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020fb:	75 19                	jne    802116 <strtol+0xbb>
  8020fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802101:	0f b6 00             	movzbl (%rax),%eax
  802104:	3c 30                	cmp    $0x30,%al
  802106:	75 0e                	jne    802116 <strtol+0xbb>
		s++, base = 8;
  802108:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80210d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802114:	eb 0d                	jmp    802123 <strtol+0xc8>
	else if (base == 0)
  802116:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80211a:	75 07                	jne    802123 <strtol+0xc8>
		base = 10;
  80211c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802123:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802127:	0f b6 00             	movzbl (%rax),%eax
  80212a:	3c 2f                	cmp    $0x2f,%al
  80212c:	7e 1d                	jle    80214b <strtol+0xf0>
  80212e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802132:	0f b6 00             	movzbl (%rax),%eax
  802135:	3c 39                	cmp    $0x39,%al
  802137:	7f 12                	jg     80214b <strtol+0xf0>
			dig = *s - '0';
  802139:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213d:	0f b6 00             	movzbl (%rax),%eax
  802140:	0f be c0             	movsbl %al,%eax
  802143:	83 e8 30             	sub    $0x30,%eax
  802146:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802149:	eb 4e                	jmp    802199 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80214b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214f:	0f b6 00             	movzbl (%rax),%eax
  802152:	3c 60                	cmp    $0x60,%al
  802154:	7e 1d                	jle    802173 <strtol+0x118>
  802156:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215a:	0f b6 00             	movzbl (%rax),%eax
  80215d:	3c 7a                	cmp    $0x7a,%al
  80215f:	7f 12                	jg     802173 <strtol+0x118>
			dig = *s - 'a' + 10;
  802161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802165:	0f b6 00             	movzbl (%rax),%eax
  802168:	0f be c0             	movsbl %al,%eax
  80216b:	83 e8 57             	sub    $0x57,%eax
  80216e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802171:	eb 26                	jmp    802199 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802173:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802177:	0f b6 00             	movzbl (%rax),%eax
  80217a:	3c 40                	cmp    $0x40,%al
  80217c:	7e 48                	jle    8021c6 <strtol+0x16b>
  80217e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802182:	0f b6 00             	movzbl (%rax),%eax
  802185:	3c 5a                	cmp    $0x5a,%al
  802187:	7f 3d                	jg     8021c6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802189:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218d:	0f b6 00             	movzbl (%rax),%eax
  802190:	0f be c0             	movsbl %al,%eax
  802193:	83 e8 37             	sub    $0x37,%eax
  802196:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802199:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80219c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80219f:	7c 02                	jl     8021a3 <strtol+0x148>
			break;
  8021a1:	eb 23                	jmp    8021c6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8021a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8021a8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021ab:	48 98                	cltq   
  8021ad:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8021b2:	48 89 c2             	mov    %rax,%rdx
  8021b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b8:	48 98                	cltq   
  8021ba:	48 01 d0             	add    %rdx,%rax
  8021bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021c1:	e9 5d ff ff ff       	jmpq   802123 <strtol+0xc8>

	if (endptr)
  8021c6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021cb:	74 0b                	je     8021d8 <strtol+0x17d>
		*endptr = (char *) s;
  8021cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021d5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021dc:	74 09                	je     8021e7 <strtol+0x18c>
  8021de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e2:	48 f7 d8             	neg    %rax
  8021e5:	eb 04                	jmp    8021eb <strtol+0x190>
  8021e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8021eb:	c9                   	leaveq 
  8021ec:	c3                   	retq   

00000000008021ed <strstr>:

char * strstr(const char *in, const char *str)
{
  8021ed:	55                   	push   %rbp
  8021ee:	48 89 e5             	mov    %rsp,%rbp
  8021f1:	48 83 ec 30          	sub    $0x30,%rsp
  8021f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8021fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802201:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802205:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802209:	0f b6 00             	movzbl (%rax),%eax
  80220c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80220f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802213:	75 06                	jne    80221b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802219:	eb 6b                	jmp    802286 <strstr+0x99>

	len = strlen(str);
  80221b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80221f:	48 89 c7             	mov    %rax,%rdi
  802222:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax
  80222e:	48 98                	cltq   
  802230:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802234:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802238:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80223c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802240:	0f b6 00             	movzbl (%rax),%eax
  802243:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802246:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80224a:	75 07                	jne    802253 <strstr+0x66>
				return (char *) 0;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
  802251:	eb 33                	jmp    802286 <strstr+0x99>
		} while (sc != c);
  802253:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802257:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80225a:	75 d8                	jne    802234 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80225c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802260:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802268:	48 89 ce             	mov    %rcx,%rsi
  80226b:	48 89 c7             	mov    %rax,%rdi
  80226e:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  802275:	00 00 00 
  802278:	ff d0                	callq  *%rax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	75 b6                	jne    802234 <strstr+0x47>

	return (char *) (in - 1);
  80227e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802282:	48 83 e8 01          	sub    $0x1,%rax
}
  802286:	c9                   	leaveq 
  802287:	c3                   	retq   

0000000000802288 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802288:	55                   	push   %rbp
  802289:	48 89 e5             	mov    %rsp,%rbp
  80228c:	53                   	push   %rbx
  80228d:	48 83 ec 48          	sub    $0x48,%rsp
  802291:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802294:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802297:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80229b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80229f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8022a3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022aa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8022ae:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8022b2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8022b6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8022ba:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8022be:	4c 89 c3             	mov    %r8,%rbx
  8022c1:	cd 30                	int    $0x30
  8022c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8022c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022cb:	74 3e                	je     80230b <syscall+0x83>
  8022cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022d2:	7e 37                	jle    80230b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022db:	49 89 d0             	mov    %rdx,%r8
  8022de:	89 c1                	mov    %eax,%ecx
  8022e0:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  8022e7:	00 00 00 
  8022ea:	be 23 00 00 00       	mov    $0x23,%esi
  8022ef:	48 bf 65 4b 80 00 00 	movabs $0x804b65,%rdi
  8022f6:	00 00 00 
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	49 b9 2e 0d 80 00 00 	movabs $0x800d2e,%r9
  802305:	00 00 00 
  802308:	41 ff d1             	callq  *%r9

	return ret;
  80230b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80230f:	48 83 c4 48          	add    $0x48,%rsp
  802313:	5b                   	pop    %rbx
  802314:	5d                   	pop    %rbp
  802315:	c3                   	retq   

0000000000802316 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 20          	sub    $0x20,%rsp
  80231e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802322:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802335:	00 
  802336:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80233c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802342:	48 89 d1             	mov    %rdx,%rcx
  802345:	48 89 c2             	mov    %rax,%rdx
  802348:	be 00 00 00 00       	mov    $0x0,%esi
  80234d:	bf 00 00 00 00       	mov    $0x0,%edi
  802352:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802359:	00 00 00 
  80235c:	ff d0                	callq  *%rax
}
  80235e:	c9                   	leaveq 
  80235f:	c3                   	retq   

0000000000802360 <sys_cgetc>:

int
sys_cgetc(void)
{
  802360:	55                   	push   %rbp
  802361:	48 89 e5             	mov    %rsp,%rbp
  802364:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802368:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80236f:	00 
  802370:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802376:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80237c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802381:	ba 00 00 00 00       	mov    $0x0,%edx
  802386:	be 00 00 00 00       	mov    $0x0,%esi
  80238b:	bf 01 00 00 00       	mov    $0x1,%edi
  802390:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
}
  80239c:	c9                   	leaveq 
  80239d:	c3                   	retq   

000000000080239e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80239e:	55                   	push   %rbp
  80239f:	48 89 e5             	mov    %rsp,%rbp
  8023a2:	48 83 ec 10          	sub    $0x10,%rsp
  8023a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8023a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ac:	48 98                	cltq   
  8023ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023b5:	00 
  8023b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023c7:	48 89 c2             	mov    %rax,%rdx
  8023ca:	be 01 00 00 00       	mov    $0x1,%esi
  8023cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8023d4:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	callq  *%rax
}
  8023e0:	c9                   	leaveq 
  8023e1:	c3                   	retq   

00000000008023e2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8023e2:	55                   	push   %rbp
  8023e3:	48 89 e5             	mov    %rsp,%rbp
  8023e6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8023ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023f1:	00 
  8023f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  802403:	ba 00 00 00 00       	mov    $0x0,%edx
  802408:	be 00 00 00 00       	mov    $0x0,%esi
  80240d:	bf 02 00 00 00       	mov    $0x2,%edi
  802412:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax
}
  80241e:	c9                   	leaveq 
  80241f:	c3                   	retq   

0000000000802420 <sys_yield>:

void
sys_yield(void)
{
  802420:	55                   	push   %rbp
  802421:	48 89 e5             	mov    %rsp,%rbp
  802424:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802428:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80242f:	00 
  802430:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802436:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80243c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802441:	ba 00 00 00 00       	mov    $0x0,%edx
  802446:	be 00 00 00 00       	mov    $0x0,%esi
  80244b:	bf 0b 00 00 00       	mov    $0xb,%edi
  802450:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
}
  80245c:	c9                   	leaveq 
  80245d:	c3                   	retq   

000000000080245e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80245e:	55                   	push   %rbp
  80245f:	48 89 e5             	mov    %rsp,%rbp
  802462:	48 83 ec 20          	sub    $0x20,%rsp
  802466:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80246d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802470:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802473:	48 63 c8             	movslq %eax,%rcx
  802476:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80247a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247d:	48 98                	cltq   
  80247f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802486:	00 
  802487:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80248d:	49 89 c8             	mov    %rcx,%r8
  802490:	48 89 d1             	mov    %rdx,%rcx
  802493:	48 89 c2             	mov    %rax,%rdx
  802496:	be 01 00 00 00       	mov    $0x1,%esi
  80249b:	bf 04 00 00 00       	mov    $0x4,%edi
  8024a0:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	callq  *%rax
}
  8024ac:	c9                   	leaveq 
  8024ad:	c3                   	retq   

00000000008024ae <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8024ae:	55                   	push   %rbp
  8024af:	48 89 e5             	mov    %rsp,%rbp
  8024b2:	48 83 ec 30          	sub    $0x30,%rsp
  8024b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024bd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8024c0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024c4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024c8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024cb:	48 63 c8             	movslq %eax,%rcx
  8024ce:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024d5:	48 63 f0             	movslq %eax,%rsi
  8024d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024df:	48 98                	cltq   
  8024e1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8024e5:	49 89 f9             	mov    %rdi,%r9
  8024e8:	49 89 f0             	mov    %rsi,%r8
  8024eb:	48 89 d1             	mov    %rdx,%rcx
  8024ee:	48 89 c2             	mov    %rax,%rdx
  8024f1:	be 01 00 00 00       	mov    $0x1,%esi
  8024f6:	bf 05 00 00 00       	mov    $0x5,%edi
  8024fb:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802502:	00 00 00 
  802505:	ff d0                	callq  *%rax
}
  802507:	c9                   	leaveq 
  802508:	c3                   	retq   

0000000000802509 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802509:	55                   	push   %rbp
  80250a:	48 89 e5             	mov    %rsp,%rbp
  80250d:	48 83 ec 20          	sub    $0x20,%rsp
  802511:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802514:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802518:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80251c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251f:	48 98                	cltq   
  802521:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802528:	00 
  802529:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80252f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802535:	48 89 d1             	mov    %rdx,%rcx
  802538:	48 89 c2             	mov    %rax,%rdx
  80253b:	be 01 00 00 00       	mov    $0x1,%esi
  802540:	bf 06 00 00 00       	mov    $0x6,%edi
  802545:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  80254c:	00 00 00 
  80254f:	ff d0                	callq  *%rax
}
  802551:	c9                   	leaveq 
  802552:	c3                   	retq   

0000000000802553 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802553:	55                   	push   %rbp
  802554:	48 89 e5             	mov    %rsp,%rbp
  802557:	48 83 ec 10          	sub    $0x10,%rsp
  80255b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80255e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802561:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802564:	48 63 d0             	movslq %eax,%rdx
  802567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256a:	48 98                	cltq   
  80256c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802573:	00 
  802574:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80257a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802580:	48 89 d1             	mov    %rdx,%rcx
  802583:	48 89 c2             	mov    %rax,%rdx
  802586:	be 01 00 00 00       	mov    $0x1,%esi
  80258b:	bf 08 00 00 00       	mov    $0x8,%edi
  802590:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
}
  80259c:	c9                   	leaveq 
  80259d:	c3                   	retq   

000000000080259e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80259e:	55                   	push   %rbp
  80259f:	48 89 e5             	mov    %rsp,%rbp
  8025a2:	48 83 ec 20          	sub    $0x20,%rsp
  8025a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8025ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b4:	48 98                	cltq   
  8025b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025bd:	00 
  8025be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025ca:	48 89 d1             	mov    %rdx,%rcx
  8025cd:	48 89 c2             	mov    %rax,%rdx
  8025d0:	be 01 00 00 00       	mov    $0x1,%esi
  8025d5:	bf 09 00 00 00       	mov    $0x9,%edi
  8025da:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	callq  *%rax
}
  8025e6:	c9                   	leaveq 
  8025e7:	c3                   	retq   

00000000008025e8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8025e8:	55                   	push   %rbp
  8025e9:	48 89 e5             	mov    %rsp,%rbp
  8025ec:	48 83 ec 20          	sub    $0x20,%rsp
  8025f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fe:	48 98                	cltq   
  802600:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802607:	00 
  802608:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80260e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802614:	48 89 d1             	mov    %rdx,%rcx
  802617:	48 89 c2             	mov    %rax,%rdx
  80261a:	be 01 00 00 00       	mov    $0x1,%esi
  80261f:	bf 0a 00 00 00       	mov    $0xa,%edi
  802624:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	callq  *%rax
}
  802630:	c9                   	leaveq 
  802631:	c3                   	retq   

0000000000802632 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802632:	55                   	push   %rbp
  802633:	48 89 e5             	mov    %rsp,%rbp
  802636:	48 83 ec 20          	sub    $0x20,%rsp
  80263a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80263d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802641:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802645:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802648:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80264b:	48 63 f0             	movslq %eax,%rsi
  80264e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802655:	48 98                	cltq   
  802657:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80265b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802662:	00 
  802663:	49 89 f1             	mov    %rsi,%r9
  802666:	49 89 c8             	mov    %rcx,%r8
  802669:	48 89 d1             	mov    %rdx,%rcx
  80266c:	48 89 c2             	mov    %rax,%rdx
  80266f:	be 00 00 00 00       	mov    $0x0,%esi
  802674:	bf 0c 00 00 00       	mov    $0xc,%edi
  802679:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  802680:	00 00 00 
  802683:	ff d0                	callq  *%rax
}
  802685:	c9                   	leaveq 
  802686:	c3                   	retq   

0000000000802687 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802687:	55                   	push   %rbp
  802688:	48 89 e5             	mov    %rsp,%rbp
  80268b:	48 83 ec 10          	sub    $0x10,%rsp
  80268f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802697:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80269e:	00 
  80269f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026b0:	48 89 c2             	mov    %rax,%rdx
  8026b3:	be 01 00 00 00       	mov    $0x1,%esi
  8026b8:	bf 0d 00 00 00       	mov    $0xd,%edi
  8026bd:	48 b8 88 22 80 00 00 	movabs $0x802288,%rax
  8026c4:	00 00 00 
  8026c7:	ff d0                	callq  *%rax
}
  8026c9:	c9                   	leaveq 
  8026ca:	c3                   	retq   

00000000008026cb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026cb:	55                   	push   %rbp
  8026cc:	48 89 e5             	mov    %rsp,%rbp
  8026cf:	48 83 ec 30          	sub    $0x30,%rsp
  8026d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8026df:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026e4:	75 0e                	jne    8026f4 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8026e6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8026ed:	00 00 00 
  8026f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8026f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f8:	48 89 c7             	mov    %rax,%rdi
  8026fb:	48 b8 87 26 80 00 00 	movabs $0x802687,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
  802707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270e:	79 27                	jns    802737 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  802710:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802715:	74 0a                	je     802721 <ipc_recv+0x56>
            *from_env_store = 0;
  802717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  802721:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802726:	74 0a                	je     802732 <ipc_recv+0x67>
            *perm_store = 0;
  802728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80272c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  802732:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802735:	eb 53                	jmp    80278a <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  802737:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80273c:	74 19                	je     802757 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80273e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802745:	00 00 00 
  802748:	48 8b 00             	mov    (%rax),%rax
  80274b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802755:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  802757:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80275c:	74 19                	je     802777 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80275e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802765:	00 00 00 
  802768:	48 8b 00             	mov    (%rax),%rax
  80276b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802775:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  802777:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80277e:	00 00 00 
  802781:	48 8b 00             	mov    (%rax),%rax
  802784:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80278a:	c9                   	leaveq 
  80278b:	c3                   	retq   

000000000080278c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80278c:	55                   	push   %rbp
  80278d:	48 89 e5             	mov    %rsp,%rbp
  802790:	48 83 ec 30          	sub    $0x30,%rsp
  802794:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802797:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80279a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80279e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8027a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8027a6:	75 0e                	jne    8027b6 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8027a8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027af:	00 00 00 
  8027b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8027b6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8027b9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8027bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027c3:	89 c7                	mov    %eax,%edi
  8027c5:	48 b8 32 26 80 00 00 	movabs $0x802632,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax
  8027d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8027d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d8:	79 36                	jns    802810 <ipc_send+0x84>
  8027da:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8027de:	74 30                	je     802810 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8027e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e3:	89 c1                	mov    %eax,%ecx
  8027e5:	48 ba 73 4b 80 00 00 	movabs $0x804b73,%rdx
  8027ec:	00 00 00 
  8027ef:	be 49 00 00 00       	mov    $0x49,%esi
  8027f4:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  8027fb:	00 00 00 
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802803:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80280a:	00 00 00 
  80280d:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  802810:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
    } while(r != 0);
  80281c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802820:	75 94                	jne    8027b6 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  802822:	c9                   	leaveq 
  802823:	c3                   	retq   

0000000000802824 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802824:	55                   	push   %rbp
  802825:	48 89 e5             	mov    %rsp,%rbp
  802828:	48 83 ec 14          	sub    $0x14,%rsp
  80282c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80282f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802836:	eb 5e                	jmp    802896 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802838:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80283f:	00 00 00 
  802842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802845:	48 63 d0             	movslq %eax,%rdx
  802848:	48 89 d0             	mov    %rdx,%rax
  80284b:	48 c1 e0 03          	shl    $0x3,%rax
  80284f:	48 01 d0             	add    %rdx,%rax
  802852:	48 c1 e0 05          	shl    $0x5,%rax
  802856:	48 01 c8             	add    %rcx,%rax
  802859:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80285f:	8b 00                	mov    (%rax),%eax
  802861:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802864:	75 2c                	jne    802892 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802866:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80286d:	00 00 00 
  802870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802873:	48 63 d0             	movslq %eax,%rdx
  802876:	48 89 d0             	mov    %rdx,%rax
  802879:	48 c1 e0 03          	shl    $0x3,%rax
  80287d:	48 01 d0             	add    %rdx,%rax
  802880:	48 c1 e0 05          	shl    $0x5,%rax
  802884:	48 01 c8             	add    %rcx,%rax
  802887:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80288d:	8b 40 08             	mov    0x8(%rax),%eax
  802890:	eb 12                	jmp    8028a4 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802892:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802896:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80289d:	7e 99                	jle    802838 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a4:	c9                   	leaveq 
  8028a5:	c3                   	retq   

00000000008028a6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8028a6:	55                   	push   %rbp
  8028a7:	48 89 e5             	mov    %rsp,%rbp
  8028aa:	48 83 ec 08          	sub    $0x8,%rsp
  8028ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8028b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028b6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8028bd:	ff ff ff 
  8028c0:	48 01 d0             	add    %rdx,%rax
  8028c3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028c7:	c9                   	leaveq 
  8028c8:	c3                   	retq   

00000000008028c9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028c9:	55                   	push   %rbp
  8028ca:	48 89 e5             	mov    %rsp,%rbp
  8028cd:	48 83 ec 08          	sub    $0x8,%rsp
  8028d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d9:	48 89 c7             	mov    %rax,%rdi
  8028dc:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  8028e3:	00 00 00 
  8028e6:	ff d0                	callq  *%rax
  8028e8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028ee:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028f2:	c9                   	leaveq 
  8028f3:	c3                   	retq   

00000000008028f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028f4:	55                   	push   %rbp
  8028f5:	48 89 e5             	mov    %rsp,%rbp
  8028f8:	48 83 ec 18          	sub    $0x18,%rsp
  8028fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802900:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802907:	eb 6b                	jmp    802974 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290c:	48 98                	cltq   
  80290e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802914:	48 c1 e0 0c          	shl    $0xc,%rax
  802918:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80291c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802920:	48 c1 e8 15          	shr    $0x15,%rax
  802924:	48 89 c2             	mov    %rax,%rdx
  802927:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80292e:	01 00 00 
  802931:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802935:	83 e0 01             	and    $0x1,%eax
  802938:	48 85 c0             	test   %rax,%rax
  80293b:	74 21                	je     80295e <fd_alloc+0x6a>
  80293d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802941:	48 c1 e8 0c          	shr    $0xc,%rax
  802945:	48 89 c2             	mov    %rax,%rdx
  802948:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80294f:	01 00 00 
  802952:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802956:	83 e0 01             	and    $0x1,%eax
  802959:	48 85 c0             	test   %rax,%rax
  80295c:	75 12                	jne    802970 <fd_alloc+0x7c>
			*fd_store = fd;
  80295e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802962:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802966:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
  80296e:	eb 1a                	jmp    80298a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802970:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802974:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802978:	7e 8f                	jle    802909 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80297a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802985:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80298a:	c9                   	leaveq 
  80298b:	c3                   	retq   

000000000080298c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 20          	sub    $0x20,%rsp
  802994:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802997:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80299b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80299f:	78 06                	js     8029a7 <fd_lookup+0x1b>
  8029a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8029a5:	7e 07                	jle    8029ae <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ac:	eb 6c                	jmp    802a1a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8029ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029b1:	48 98                	cltq   
  8029b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8029bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c5:	48 c1 e8 15          	shr    $0x15,%rax
  8029c9:	48 89 c2             	mov    %rax,%rdx
  8029cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029d3:	01 00 00 
  8029d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029da:	83 e0 01             	and    $0x1,%eax
  8029dd:	48 85 c0             	test   %rax,%rax
  8029e0:	74 21                	je     802a03 <fd_lookup+0x77>
  8029e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8029ea:	48 89 c2             	mov    %rax,%rdx
  8029ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029f4:	01 00 00 
  8029f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029fb:	83 e0 01             	and    $0x1,%eax
  8029fe:	48 85 c0             	test   %rax,%rax
  802a01:	75 07                	jne    802a0a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a08:	eb 10                	jmp    802a1a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a0e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a12:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a1a:	c9                   	leaveq 
  802a1b:	c3                   	retq   

0000000000802a1c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a1c:	55                   	push   %rbp
  802a1d:	48 89 e5             	mov    %rsp,%rbp
  802a20:	48 83 ec 30          	sub    $0x30,%rsp
  802a24:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a28:	89 f0                	mov    %esi,%eax
  802a2a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a31:	48 89 c7             	mov    %rax,%rdi
  802a34:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax
  802a40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a44:	48 89 d6             	mov    %rdx,%rsi
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
  802a55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5c:	78 0a                	js     802a68 <fd_close+0x4c>
	    || fd != fd2)
  802a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a62:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a66:	74 12                	je     802a7a <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a68:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a6c:	74 05                	je     802a73 <fd_close+0x57>
  802a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a71:	eb 05                	jmp    802a78 <fd_close+0x5c>
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	eb 69                	jmp    802ae3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a7e:	8b 00                	mov    (%rax),%eax
  802a80:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a84:	48 89 d6             	mov    %rdx,%rsi
  802a87:	89 c7                	mov    %eax,%edi
  802a89:	48 b8 e5 2a 80 00 00 	movabs $0x802ae5,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
  802a95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9c:	78 2a                	js     802ac8 <fd_close+0xac>
		if (dev->dev_close)
  802a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa2:	48 8b 40 20          	mov    0x20(%rax),%rax
  802aa6:	48 85 c0             	test   %rax,%rax
  802aa9:	74 16                	je     802ac1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aaf:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ab3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ab7:	48 89 d7             	mov    %rdx,%rdi
  802aba:	ff d0                	callq  *%rax
  802abc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802abf:	eb 07                	jmp    802ac8 <fd_close+0xac>
		else
			r = 0;
  802ac1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ac8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802acc:	48 89 c6             	mov    %rax,%rsi
  802acf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad4:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
	return r;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ae3:	c9                   	leaveq 
  802ae4:	c3                   	retq   

0000000000802ae5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ae5:	55                   	push   %rbp
  802ae6:	48 89 e5             	mov    %rsp,%rbp
  802ae9:	48 83 ec 20          	sub    $0x20,%rsp
  802aed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802af0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802af4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802afb:	eb 41                	jmp    802b3e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802afd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b04:	00 00 00 
  802b07:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b0a:	48 63 d2             	movslq %edx,%rdx
  802b0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b11:	8b 00                	mov    (%rax),%eax
  802b13:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b16:	75 22                	jne    802b3a <dev_lookup+0x55>
			*dev = devtab[i];
  802b18:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b1f:	00 00 00 
  802b22:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b25:	48 63 d2             	movslq %edx,%rdx
  802b28:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b30:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
  802b38:	eb 60                	jmp    802b9a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b3a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b3e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b45:	00 00 00 
  802b48:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b4b:	48 63 d2             	movslq %edx,%rdx
  802b4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b52:	48 85 c0             	test   %rax,%rax
  802b55:	75 a6                	jne    802afd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b57:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b5e:	00 00 00 
  802b61:	48 8b 00             	mov    (%rax),%rax
  802b64:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	48 bf 90 4b 80 00 00 	movabs $0x804b90,%rdi
  802b76:	00 00 00 
  802b79:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7e:	48 b9 67 0f 80 00 00 	movabs $0x800f67,%rcx
  802b85:	00 00 00 
  802b88:	ff d1                	callq  *%rcx
	*dev = 0;
  802b8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b8e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b9a:	c9                   	leaveq 
  802b9b:	c3                   	retq   

0000000000802b9c <close>:

int
close(int fdnum)
{
  802b9c:	55                   	push   %rbp
  802b9d:	48 89 e5             	mov    %rsp,%rbp
  802ba0:	48 83 ec 20          	sub    $0x20,%rsp
  802ba4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ba7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bae:	48 89 d6             	mov    %rdx,%rsi
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
  802bbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc6:	79 05                	jns    802bcd <close+0x31>
		return r;
  802bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcb:	eb 18                	jmp    802be5 <close+0x49>
	else
		return fd_close(fd, 1);
  802bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd1:	be 01 00 00 00       	mov    $0x1,%esi
  802bd6:	48 89 c7             	mov    %rax,%rdi
  802bd9:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
}
  802be5:	c9                   	leaveq 
  802be6:	c3                   	retq   

0000000000802be7 <close_all>:

void
close_all(void)
{
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
  802beb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bf6:	eb 15                	jmp    802c0d <close_all+0x26>
		close(i);
  802bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfb:	89 c7                	mov    %eax,%edi
  802bfd:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802c09:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c0d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c11:	7e e5                	jle    802bf8 <close_all+0x11>
		close(i);
}
  802c13:	c9                   	leaveq 
  802c14:	c3                   	retq   

0000000000802c15 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c15:	55                   	push   %rbp
  802c16:	48 89 e5             	mov    %rsp,%rbp
  802c19:	48 83 ec 40          	sub    $0x40,%rsp
  802c1d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c20:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c23:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c27:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c2a:	48 89 d6             	mov    %rdx,%rsi
  802c2d:	89 c7                	mov    %eax,%edi
  802c2f:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	callq  *%rax
  802c3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c42:	79 08                	jns    802c4c <dup+0x37>
		return r;
  802c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c47:	e9 70 01 00 00       	jmpq   802dbc <dup+0x1a7>
	close(newfdnum);
  802c4c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c4f:	89 c7                	mov    %eax,%edi
  802c51:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  802c58:	00 00 00 
  802c5b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c5d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c60:	48 98                	cltq   
  802c62:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c68:	48 c1 e0 0c          	shl    $0xc,%rax
  802c6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c74:	48 89 c7             	mov    %rax,%rdi
  802c77:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  802c7e:	00 00 00 
  802c81:	ff d0                	callq  *%rax
  802c83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8b:	48 89 c7             	mov    %rax,%rdi
  802c8e:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  802c95:	00 00 00 
  802c98:	ff d0                	callq  *%rax
  802c9a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca2:	48 c1 e8 15          	shr    $0x15,%rax
  802ca6:	48 89 c2             	mov    %rax,%rdx
  802ca9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802cb0:	01 00 00 
  802cb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cb7:	83 e0 01             	and    $0x1,%eax
  802cba:	48 85 c0             	test   %rax,%rax
  802cbd:	74 73                	je     802d32 <dup+0x11d>
  802cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc3:	48 c1 e8 0c          	shr    $0xc,%rax
  802cc7:	48 89 c2             	mov    %rax,%rdx
  802cca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cd1:	01 00 00 
  802cd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cd8:	83 e0 01             	and    $0x1,%eax
  802cdb:	48 85 c0             	test   %rax,%rax
  802cde:	74 52                	je     802d32 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce4:	48 c1 e8 0c          	shr    $0xc,%rax
  802ce8:	48 89 c2             	mov    %rax,%rdx
  802ceb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cf2:	01 00 00 
  802cf5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cf9:	25 07 0e 00 00       	and    $0xe07,%eax
  802cfe:	89 c1                	mov    %eax,%ecx
  802d00:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d08:	41 89 c8             	mov    %ecx,%r8d
  802d0b:	48 89 d1             	mov    %rdx,%rcx
  802d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d13:	48 89 c6             	mov    %rax,%rsi
  802d16:	bf 00 00 00 00       	mov    $0x0,%edi
  802d1b:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  802d22:	00 00 00 
  802d25:	ff d0                	callq  *%rax
  802d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2e:	79 02                	jns    802d32 <dup+0x11d>
			goto err;
  802d30:	eb 57                	jmp    802d89 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d36:	48 c1 e8 0c          	shr    $0xc,%rax
  802d3a:	48 89 c2             	mov    %rax,%rdx
  802d3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d44:	01 00 00 
  802d47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d4b:	25 07 0e 00 00       	and    $0xe07,%eax
  802d50:	89 c1                	mov    %eax,%ecx
  802d52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d5a:	41 89 c8             	mov    %ecx,%r8d
  802d5d:	48 89 d1             	mov    %rdx,%rcx
  802d60:	ba 00 00 00 00       	mov    $0x0,%edx
  802d65:	48 89 c6             	mov    %rax,%rsi
  802d68:	bf 00 00 00 00       	mov    $0x0,%edi
  802d6d:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d80:	79 02                	jns    802d84 <dup+0x16f>
		goto err;
  802d82:	eb 05                	jmp    802d89 <dup+0x174>

	return newfdnum;
  802d84:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d87:	eb 33                	jmp    802dbc <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8d:	48 89 c6             	mov    %rax,%rsi
  802d90:	bf 00 00 00 00       	mov    $0x0,%edi
  802d95:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802da1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da5:	48 89 c6             	mov    %rax,%rsi
  802da8:	bf 00 00 00 00       	mov    $0x0,%edi
  802dad:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  802db4:	00 00 00 
  802db7:	ff d0                	callq  *%rax
	return r;
  802db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802dbc:	c9                   	leaveq 
  802dbd:	c3                   	retq   

0000000000802dbe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802dbe:	55                   	push   %rbp
  802dbf:	48 89 e5             	mov    %rsp,%rbp
  802dc2:	48 83 ec 40          	sub    $0x40,%rsp
  802dc6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dc9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dcd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dd1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dd5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dd8:	48 89 d6             	mov    %rdx,%rsi
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
  802de9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df0:	78 24                	js     802e16 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802df2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df6:	8b 00                	mov    (%rax),%eax
  802df8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dfc:	48 89 d6             	mov    %rdx,%rsi
  802dff:	89 c7                	mov    %eax,%edi
  802e01:	48 b8 e5 2a 80 00 00 	movabs $0x802ae5,%rax
  802e08:	00 00 00 
  802e0b:	ff d0                	callq  *%rax
  802e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e14:	79 05                	jns    802e1b <read+0x5d>
		return r;
  802e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e19:	eb 76                	jmp    802e91 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1f:	8b 40 08             	mov    0x8(%rax),%eax
  802e22:	83 e0 03             	and    $0x3,%eax
  802e25:	83 f8 01             	cmp    $0x1,%eax
  802e28:	75 3a                	jne    802e64 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e2a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e31:	00 00 00 
  802e34:	48 8b 00             	mov    (%rax),%rax
  802e37:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e3d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e40:	89 c6                	mov    %eax,%esi
  802e42:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
  802e49:	00 00 00 
  802e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e51:	48 b9 67 0f 80 00 00 	movabs $0x800f67,%rcx
  802e58:	00 00 00 
  802e5b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e62:	eb 2d                	jmp    802e91 <read+0xd3>
	}
	if (!dev->dev_read)
  802e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e68:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e6c:	48 85 c0             	test   %rax,%rax
  802e6f:	75 07                	jne    802e78 <read+0xba>
		return -E_NOT_SUPP;
  802e71:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e76:	eb 19                	jmp    802e91 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e80:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e88:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e8c:	48 89 cf             	mov    %rcx,%rdi
  802e8f:	ff d0                	callq  *%rax
}
  802e91:	c9                   	leaveq 
  802e92:	c3                   	retq   

0000000000802e93 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e93:	55                   	push   %rbp
  802e94:	48 89 e5             	mov    %rsp,%rbp
  802e97:	48 83 ec 30          	sub    $0x30,%rsp
  802e9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ea2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ead:	eb 49                	jmp    802ef8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb2:	48 98                	cltq   
  802eb4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eb8:	48 29 c2             	sub    %rax,%rdx
  802ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebe:	48 63 c8             	movslq %eax,%rcx
  802ec1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ec5:	48 01 c1             	add    %rax,%rcx
  802ec8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ecb:	48 89 ce             	mov    %rcx,%rsi
  802ece:	89 c7                	mov    %eax,%edi
  802ed0:	48 b8 be 2d 80 00 00 	movabs $0x802dbe,%rax
  802ed7:	00 00 00 
  802eda:	ff d0                	callq  *%rax
  802edc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802edf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ee3:	79 05                	jns    802eea <readn+0x57>
			return m;
  802ee5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ee8:	eb 1c                	jmp    802f06 <readn+0x73>
		if (m == 0)
  802eea:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802eee:	75 02                	jne    802ef2 <readn+0x5f>
			break;
  802ef0:	eb 11                	jmp    802f03 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ef2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef5:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efb:	48 98                	cltq   
  802efd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f01:	72 ac                	jb     802eaf <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f06:	c9                   	leaveq 
  802f07:	c3                   	retq   

0000000000802f08 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802f08:	55                   	push   %rbp
  802f09:	48 89 e5             	mov    %rsp,%rbp
  802f0c:	48 83 ec 40          	sub    $0x40,%rsp
  802f10:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f13:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f17:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f1b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f22:	48 89 d6             	mov    %rdx,%rsi
  802f25:	89 c7                	mov    %eax,%edi
  802f27:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3a:	78 24                	js     802f60 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f40:	8b 00                	mov    (%rax),%eax
  802f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f46:	48 89 d6             	mov    %rdx,%rsi
  802f49:	89 c7                	mov    %eax,%edi
  802f4b:	48 b8 e5 2a 80 00 00 	movabs $0x802ae5,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5e:	79 05                	jns    802f65 <write+0x5d>
		return r;
  802f60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f63:	eb 75                	jmp    802fda <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f69:	8b 40 08             	mov    0x8(%rax),%eax
  802f6c:	83 e0 03             	and    $0x3,%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	75 3a                	jne    802fad <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f73:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802f7a:	00 00 00 
  802f7d:	48 8b 00             	mov    (%rax),%rax
  802f80:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f86:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f89:	89 c6                	mov    %eax,%esi
  802f8b:	48 bf cb 4b 80 00 00 	movabs $0x804bcb,%rdi
  802f92:	00 00 00 
  802f95:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9a:	48 b9 67 0f 80 00 00 	movabs $0x800f67,%rcx
  802fa1:	00 00 00 
  802fa4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802fa6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fab:	eb 2d                	jmp    802fda <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb1:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fb5:	48 85 c0             	test   %rax,%rax
  802fb8:	75 07                	jne    802fc1 <write+0xb9>
		return -E_NOT_SUPP;
  802fba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fbf:	eb 19                	jmp    802fda <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc5:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fc9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fcd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fd1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fd5:	48 89 cf             	mov    %rcx,%rdi
  802fd8:	ff d0                	callq  *%rax
}
  802fda:	c9                   	leaveq 
  802fdb:	c3                   	retq   

0000000000802fdc <seek>:

int
seek(int fdnum, off_t offset)
{
  802fdc:	55                   	push   %rbp
  802fdd:	48 89 e5             	mov    %rsp,%rbp
  802fe0:	48 83 ec 18          	sub    $0x18,%rsp
  802fe4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff1:	48 89 d6             	mov    %rdx,%rsi
  802ff4:	89 c7                	mov    %eax,%edi
  802ff6:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802ffd:	00 00 00 
  803000:	ff d0                	callq  *%rax
  803002:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803005:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803009:	79 05                	jns    803010 <seek+0x34>
		return r;
  80300b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300e:	eb 0f                	jmp    80301f <seek+0x43>
	fd->fd_offset = offset;
  803010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803014:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803017:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80301a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301f:	c9                   	leaveq 
  803020:	c3                   	retq   

0000000000803021 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803021:	55                   	push   %rbp
  803022:	48 89 e5             	mov    %rsp,%rbp
  803025:	48 83 ec 30          	sub    $0x30,%rsp
  803029:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80302c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80302f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803033:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803036:	48 89 d6             	mov    %rdx,%rsi
  803039:	89 c7                	mov    %eax,%edi
  80303b:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
  803047:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304e:	78 24                	js     803074 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803054:	8b 00                	mov    (%rax),%eax
  803056:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80305a:	48 89 d6             	mov    %rdx,%rsi
  80305d:	89 c7                	mov    %eax,%edi
  80305f:	48 b8 e5 2a 80 00 00 	movabs $0x802ae5,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803072:	79 05                	jns    803079 <ftruncate+0x58>
		return r;
  803074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803077:	eb 72                	jmp    8030eb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307d:	8b 40 08             	mov    0x8(%rax),%eax
  803080:	83 e0 03             	and    $0x3,%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	75 3a                	jne    8030c1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803087:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80308e:	00 00 00 
  803091:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803094:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80309a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80309d:	89 c6                	mov    %eax,%esi
  80309f:	48 bf e8 4b 80 00 00 	movabs $0x804be8,%rdi
  8030a6:	00 00 00 
  8030a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ae:	48 b9 67 0f 80 00 00 	movabs $0x800f67,%rcx
  8030b5:	00 00 00 
  8030b8:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8030ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030bf:	eb 2a                	jmp    8030eb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8030c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030c9:	48 85 c0             	test   %rax,%rax
  8030cc:	75 07                	jne    8030d5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030ce:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030d3:	eb 16                	jmp    8030eb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030e1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030e4:	89 ce                	mov    %ecx,%esi
  8030e6:	48 89 d7             	mov    %rdx,%rdi
  8030e9:	ff d0                	callq  *%rax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 30          	sub    $0x30,%rsp
  8030f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030fc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803100:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803103:	48 89 d6             	mov    %rdx,%rsi
  803106:	89 c7                	mov    %eax,%edi
  803108:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  80310f:	00 00 00 
  803112:	ff d0                	callq  *%rax
  803114:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803117:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311b:	78 24                	js     803141 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80311d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803121:	8b 00                	mov    (%rax),%eax
  803123:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803127:	48 89 d6             	mov    %rdx,%rsi
  80312a:	89 c7                	mov    %eax,%edi
  80312c:	48 b8 e5 2a 80 00 00 	movabs $0x802ae5,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313f:	79 05                	jns    803146 <fstat+0x59>
		return r;
  803141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803144:	eb 5e                	jmp    8031a4 <fstat+0xb7>
	if (!dev->dev_stat)
  803146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80314a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80314e:	48 85 c0             	test   %rax,%rax
  803151:	75 07                	jne    80315a <fstat+0x6d>
		return -E_NOT_SUPP;
  803153:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803158:	eb 4a                	jmp    8031a4 <fstat+0xb7>
	stat->st_name[0] = 0;
  80315a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803161:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803165:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80316c:	00 00 00 
	stat->st_isdir = 0;
  80316f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803173:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80317a:	00 00 00 
	stat->st_dev = dev;
  80317d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803181:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803185:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80318c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803190:	48 8b 40 28          	mov    0x28(%rax),%rax
  803194:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803198:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80319c:	48 89 ce             	mov    %rcx,%rsi
  80319f:	48 89 d7             	mov    %rdx,%rdi
  8031a2:	ff d0                	callq  *%rax
}
  8031a4:	c9                   	leaveq 
  8031a5:	c3                   	retq   

00000000008031a6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8031a6:	55                   	push   %rbp
  8031a7:	48 89 e5             	mov    %rsp,%rbp
  8031aa:	48 83 ec 20          	sub    $0x20,%rsp
  8031ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ba:	be 00 00 00 00       	mov    $0x0,%esi
  8031bf:	48 89 c7             	mov    %rax,%rdi
  8031c2:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d5:	79 05                	jns    8031dc <stat+0x36>
		return fd;
  8031d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031da:	eb 2f                	jmp    80320b <stat+0x65>
	r = fstat(fd, stat);
  8031dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e3:	48 89 d6             	mov    %rdx,%rsi
  8031e6:	89 c7                	mov    %eax,%edi
  8031e8:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
  8031f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fa:	89 c7                	mov    %eax,%edi
  8031fc:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
	return r;
  803208:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80320b:	c9                   	leaveq 
  80320c:	c3                   	retq   

000000000080320d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80320d:	55                   	push   %rbp
  80320e:	48 89 e5             	mov    %rsp,%rbp
  803211:	48 83 ec 10          	sub    $0x10,%rsp
  803215:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803218:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80321c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803223:	00 00 00 
  803226:	8b 00                	mov    (%rax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	75 1d                	jne    803249 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80322c:	bf 01 00 00 00       	mov    $0x1,%edi
  803231:	48 b8 24 28 80 00 00 	movabs $0x802824,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax
  80323d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  803244:	00 00 00 
  803247:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803249:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803250:	00 00 00 
  803253:	8b 00                	mov    (%rax),%eax
  803255:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803258:	b9 07 00 00 00       	mov    $0x7,%ecx
  80325d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803264:	00 00 00 
  803267:	89 c7                	mov    %eax,%edi
  803269:	48 b8 8c 27 80 00 00 	movabs $0x80278c,%rax
  803270:	00 00 00 
  803273:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803279:	ba 00 00 00 00       	mov    $0x0,%edx
  80327e:	48 89 c6             	mov    %rax,%rsi
  803281:	bf 00 00 00 00       	mov    $0x0,%edi
  803286:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
}
  803292:	c9                   	leaveq 
  803293:	c3                   	retq   

0000000000803294 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803294:	55                   	push   %rbp
  803295:	48 89 e5             	mov    %rsp,%rbp
  803298:	48 83 ec 20          	sub    $0x20,%rsp
  80329c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032a0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8032a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a7:	48 89 c7             	mov    %rax,%rdi
  8032aa:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8032b1:	00 00 00 
  8032b4:	ff d0                	callq  *%rax
  8032b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032bb:	7e 0a                	jle    8032c7 <open+0x33>
		return -E_BAD_PATH;
  8032bd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032c2:	e9 a5 00 00 00       	jmpq   80336c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8032c7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032cb:	48 89 c7             	mov    %rax,%rdi
  8032ce:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e1:	79 08                	jns    8032eb <open+0x57>
		return r;
  8032e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e6:	e9 81 00 00 00       	jmpq   80336c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8032eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ef:	48 89 c6             	mov    %rax,%rsi
  8032f2:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8032f9:	00 00 00 
  8032fc:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803308:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80330f:	00 00 00 
  803312:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803315:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80331b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331f:	48 89 c6             	mov    %rax,%rsi
  803322:	bf 01 00 00 00       	mov    $0x1,%edi
  803327:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
  803333:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803336:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333a:	79 1d                	jns    803359 <open+0xc5>
		fd_close(fd, 0);
  80333c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803340:	be 00 00 00 00       	mov    $0x0,%esi
  803345:	48 89 c7             	mov    %rax,%rdi
  803348:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
		return r;
  803354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803357:	eb 13                	jmp    80336c <open+0xd8>
	}

	return fd2num(fd);
  803359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335d:	48 89 c7             	mov    %rax,%rdi
  803360:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80336c:	c9                   	leaveq 
  80336d:	c3                   	retq   

000000000080336e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80336e:	55                   	push   %rbp
  80336f:	48 89 e5             	mov    %rsp,%rbp
  803372:	48 83 ec 10          	sub    $0x10,%rsp
  803376:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80337a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337e:	8b 50 0c             	mov    0xc(%rax),%edx
  803381:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803388:	00 00 00 
  80338b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80338d:	be 00 00 00 00       	mov    $0x0,%esi
  803392:	bf 06 00 00 00       	mov    $0x6,%edi
  803397:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
}
  8033a3:	c9                   	leaveq 
  8033a4:	c3                   	retq   

00000000008033a5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8033a5:	55                   	push   %rbp
  8033a6:	48 89 e5             	mov    %rsp,%rbp
  8033a9:	48 83 ec 30          	sub    $0x30,%rsp
  8033ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8033b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c7:	00 00 00 
  8033ca:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d3:	00 00 00 
  8033d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033da:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8033de:	be 00 00 00 00       	mov    $0x0,%esi
  8033e3:	bf 03 00 00 00       	mov    $0x3,%edi
  8033e8:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fb:	79 08                	jns    803405 <devfile_read+0x60>
		return r;
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	e9 a4 00 00 00       	jmpq   8034a9 <devfile_read+0x104>
	assert(r <= n);
  803405:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803408:	48 98                	cltq   
  80340a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80340e:	76 35                	jbe    803445 <devfile_read+0xa0>
  803410:	48 b9 15 4c 80 00 00 	movabs $0x804c15,%rcx
  803417:	00 00 00 
  80341a:	48 ba 1c 4c 80 00 00 	movabs $0x804c1c,%rdx
  803421:	00 00 00 
  803424:	be 84 00 00 00       	mov    $0x84,%esi
  803429:	48 bf 31 4c 80 00 00 	movabs $0x804c31,%rdi
  803430:	00 00 00 
  803433:	b8 00 00 00 00       	mov    $0x0,%eax
  803438:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80343f:	00 00 00 
  803442:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803445:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80344c:	7e 35                	jle    803483 <devfile_read+0xde>
  80344e:	48 b9 3c 4c 80 00 00 	movabs $0x804c3c,%rcx
  803455:	00 00 00 
  803458:	48 ba 1c 4c 80 00 00 	movabs $0x804c1c,%rdx
  80345f:	00 00 00 
  803462:	be 85 00 00 00       	mov    $0x85,%esi
  803467:	48 bf 31 4c 80 00 00 	movabs $0x804c31,%rdi
  80346e:	00 00 00 
  803471:	b8 00 00 00 00       	mov    $0x0,%eax
  803476:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80347d:	00 00 00 
  803480:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803486:	48 63 d0             	movslq %eax,%rdx
  803489:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803494:	00 00 00 
  803497:	48 89 c7             	mov    %rax,%rdi
  80349a:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
	return r;
  8034a6:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8034a9:	c9                   	leaveq 
  8034aa:	c3                   	retq   

00000000008034ab <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8034ab:	55                   	push   %rbp
  8034ac:	48 89 e5             	mov    %rsp,%rbp
  8034af:	48 83 ec 30          	sub    $0x30,%rsp
  8034b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c3:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034cd:	00 00 00 
  8034d0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8034d2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034d9:	00 00 00 
  8034dc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034e0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8034e4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8034eb:	00 
  8034ec:	76 35                	jbe    803523 <devfile_write+0x78>
  8034ee:	48 b9 48 4c 80 00 00 	movabs $0x804c48,%rcx
  8034f5:	00 00 00 
  8034f8:	48 ba 1c 4c 80 00 00 	movabs $0x804c1c,%rdx
  8034ff:	00 00 00 
  803502:	be 9e 00 00 00       	mov    $0x9e,%esi
  803507:	48 bf 31 4c 80 00 00 	movabs $0x804c31,%rdi
  80350e:	00 00 00 
  803511:	b8 00 00 00 00       	mov    $0x0,%eax
  803516:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  80351d:	00 00 00 
  803520:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803523:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803527:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80352b:	48 89 c6             	mov    %rax,%rsi
  80352e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803535:	00 00 00 
  803538:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803544:	be 00 00 00 00       	mov    $0x0,%esi
  803549:	bf 04 00 00 00       	mov    $0x4,%edi
  80354e:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
  80355a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80355d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803561:	79 05                	jns    803568 <devfile_write+0xbd>
		return r;
  803563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803566:	eb 43                	jmp    8035ab <devfile_write+0x100>
	assert(r <= n);
  803568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356b:	48 98                	cltq   
  80356d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803571:	76 35                	jbe    8035a8 <devfile_write+0xfd>
  803573:	48 b9 15 4c 80 00 00 	movabs $0x804c15,%rcx
  80357a:	00 00 00 
  80357d:	48 ba 1c 4c 80 00 00 	movabs $0x804c1c,%rdx
  803584:	00 00 00 
  803587:	be a2 00 00 00       	mov    $0xa2,%esi
  80358c:	48 bf 31 4c 80 00 00 	movabs $0x804c31,%rdi
  803593:	00 00 00 
  803596:	b8 00 00 00 00       	mov    $0x0,%eax
  80359b:	49 b8 2e 0d 80 00 00 	movabs $0x800d2e,%r8
  8035a2:	00 00 00 
  8035a5:	41 ff d0             	callq  *%r8
	return r;
  8035a8:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8035ab:	c9                   	leaveq 
  8035ac:	c3                   	retq   

00000000008035ad <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8035ad:	55                   	push   %rbp
  8035ae:	48 89 e5             	mov    %rsp,%rbp
  8035b1:	48 83 ec 20          	sub    $0x20,%rsp
  8035b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8035bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8035c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035cb:	00 00 00 
  8035ce:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035d0:	be 00 00 00 00       	mov    $0x0,%esi
  8035d5:	bf 05 00 00 00       	mov    $0x5,%edi
  8035da:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
  8035e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ed:	79 05                	jns    8035f4 <devfile_stat+0x47>
		return r;
  8035ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f2:	eb 56                	jmp    80364a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8035ff:	00 00 00 
  803602:	48 89 c7             	mov    %rax,%rdi
  803605:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803611:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803618:	00 00 00 
  80361b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803621:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803625:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80362b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803632:	00 00 00 
  803635:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80363b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80363f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803645:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80364a:	c9                   	leaveq 
  80364b:	c3                   	retq   

000000000080364c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80364c:	55                   	push   %rbp
  80364d:	48 89 e5             	mov    %rsp,%rbp
  803650:	48 83 ec 10          	sub    $0x10,%rsp
  803654:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803658:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80365b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365f:	8b 50 0c             	mov    0xc(%rax),%edx
  803662:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803669:	00 00 00 
  80366c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80366e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803675:	00 00 00 
  803678:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80367b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80367e:	be 00 00 00 00       	mov    $0x0,%esi
  803683:	bf 02 00 00 00       	mov    $0x2,%edi
  803688:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <remove>:

// Delete a file
int
remove(const char *path)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 10          	sub    $0x10,%rsp
  80369e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8036a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a6:	48 89 c7             	mov    %rax,%rdi
  8036a9:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8036b0:	00 00 00 
  8036b3:	ff d0                	callq  *%rax
  8036b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8036ba:	7e 07                	jle    8036c3 <remove+0x2d>
		return -E_BAD_PATH;
  8036bc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8036c1:	eb 33                	jmp    8036f6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8036c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c7:	48 89 c6             	mov    %rax,%rsi
  8036ca:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8036d1:	00 00 00 
  8036d4:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8036e0:	be 00 00 00 00       	mov    $0x0,%esi
  8036e5:	bf 07 00 00 00       	mov    $0x7,%edi
  8036ea:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
}
  8036f6:	c9                   	leaveq 
  8036f7:	c3                   	retq   

00000000008036f8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8036f8:	55                   	push   %rbp
  8036f9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036fc:	be 00 00 00 00       	mov    $0x0,%esi
  803701:	bf 08 00 00 00       	mov    $0x8,%edi
  803706:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  80370d:	00 00 00 
  803710:	ff d0                	callq  *%rax
}
  803712:	5d                   	pop    %rbp
  803713:	c3                   	retq   

0000000000803714 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803714:	55                   	push   %rbp
  803715:	48 89 e5             	mov    %rsp,%rbp
  803718:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80371f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803726:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80372d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803734:	be 00 00 00 00       	mov    $0x0,%esi
  803739:	48 89 c7             	mov    %rax,%rdi
  80373c:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80374b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374f:	79 28                	jns    803779 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803754:	89 c6                	mov    %eax,%esi
  803756:	48 bf 75 4c 80 00 00 	movabs $0x804c75,%rdi
  80375d:	00 00 00 
  803760:	b8 00 00 00 00       	mov    $0x0,%eax
  803765:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  80376c:	00 00 00 
  80376f:	ff d2                	callq  *%rdx
		return fd_src;
  803771:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803774:	e9 74 01 00 00       	jmpq   8038ed <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803779:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803780:	be 01 01 00 00       	mov    $0x101,%esi
  803785:	48 89 c7             	mov    %rax,%rdi
  803788:	48 b8 94 32 80 00 00 	movabs $0x803294,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
  803794:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803797:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80379b:	79 39                	jns    8037d6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80379d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037a0:	89 c6                	mov    %eax,%esi
  8037a2:	48 bf 8b 4c 80 00 00 	movabs $0x804c8b,%rdi
  8037a9:	00 00 00 
  8037ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b1:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  8037b8:	00 00 00 
  8037bb:	ff d2                	callq  *%rdx
		close(fd_src);
  8037bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c0:	89 c7                	mov    %eax,%edi
  8037c2:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
		return fd_dest;
  8037ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037d1:	e9 17 01 00 00       	jmpq   8038ed <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8037d6:	eb 74                	jmp    80384c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8037d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037db:	48 63 d0             	movslq %eax,%rdx
  8037de:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8037e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037e8:	48 89 ce             	mov    %rcx,%rsi
  8037eb:	89 c7                	mov    %eax,%edi
  8037ed:	48 b8 08 2f 80 00 00 	movabs $0x802f08,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
  8037f9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8037fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803800:	79 4a                	jns    80384c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803802:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803805:	89 c6                	mov    %eax,%esi
  803807:	48 bf a5 4c 80 00 00 	movabs $0x804ca5,%rdi
  80380e:	00 00 00 
  803811:	b8 00 00 00 00       	mov    $0x0,%eax
  803816:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  80381d:	00 00 00 
  803820:	ff d2                	callq  *%rdx
			close(fd_src);
  803822:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803825:	89 c7                	mov    %eax,%edi
  803827:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
			close(fd_dest);
  803833:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803836:	89 c7                	mov    %eax,%edi
  803838:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  80383f:	00 00 00 
  803842:	ff d0                	callq  *%rax
			return write_size;
  803844:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803847:	e9 a1 00 00 00       	jmpq   8038ed <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80384c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803856:	ba 00 02 00 00       	mov    $0x200,%edx
  80385b:	48 89 ce             	mov    %rcx,%rsi
  80385e:	89 c7                	mov    %eax,%edi
  803860:	48 b8 be 2d 80 00 00 	movabs $0x802dbe,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80386f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803873:	0f 8f 5f ff ff ff    	jg     8037d8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803879:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80387d:	79 47                	jns    8038c6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80387f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803882:	89 c6                	mov    %eax,%esi
  803884:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  80388b:	00 00 00 
  80388e:	b8 00 00 00 00       	mov    $0x0,%eax
  803893:	48 ba 67 0f 80 00 00 	movabs $0x800f67,%rdx
  80389a:	00 00 00 
  80389d:	ff d2                	callq  *%rdx
		close(fd_src);
  80389f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a2:	89 c7                	mov    %eax,%edi
  8038a4:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  8038ab:	00 00 00 
  8038ae:	ff d0                	callq  *%rax
		close(fd_dest);
  8038b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038b3:	89 c7                	mov    %eax,%edi
  8038b5:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  8038bc:	00 00 00 
  8038bf:	ff d0                	callq  *%rax
		return read_size;
  8038c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038c4:	eb 27                	jmp    8038ed <copy+0x1d9>
	}
	close(fd_src);
  8038c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c9:	89 c7                	mov    %eax,%edi
  8038cb:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  8038d2:	00 00 00 
  8038d5:	ff d0                	callq  *%rax
	close(fd_dest);
  8038d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038da:	89 c7                	mov    %eax,%edi
  8038dc:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
	return 0;
  8038e8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8038ed:	c9                   	leaveq 
  8038ee:	c3                   	retq   

00000000008038ef <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8038ef:	55                   	push   %rbp
  8038f0:	48 89 e5             	mov    %rsp,%rbp
  8038f3:	53                   	push   %rbx
  8038f4:	48 83 ec 38          	sub    $0x38,%rsp
  8038f8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8038fc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803900:	48 89 c7             	mov    %rax,%rdi
  803903:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
  80390f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803912:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803916:	0f 88 bf 01 00 00    	js     803adb <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80391c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803920:	ba 07 04 00 00       	mov    $0x407,%edx
  803925:	48 89 c6             	mov    %rax,%rsi
  803928:	bf 00 00 00 00       	mov    $0x0,%edi
  80392d:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
  803939:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80393c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803940:	0f 88 95 01 00 00    	js     803adb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803946:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80394a:	48 89 c7             	mov    %rax,%rdi
  80394d:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  803954:	00 00 00 
  803957:	ff d0                	callq  *%rax
  803959:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80395c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803960:	0f 88 5d 01 00 00    	js     803ac3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803966:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80396a:	ba 07 04 00 00       	mov    $0x407,%edx
  80396f:	48 89 c6             	mov    %rax,%rsi
  803972:	bf 00 00 00 00       	mov    $0x0,%edi
  803977:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
  803983:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803986:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80398a:	0f 88 33 01 00 00    	js     803ac3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803994:	48 89 c7             	mov    %rax,%rdi
  803997:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  80399e:	00 00 00 
  8039a1:	ff d0                	callq  *%rax
  8039a3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ab:	ba 07 04 00 00       	mov    $0x407,%edx
  8039b0:	48 89 c6             	mov    %rax,%rsi
  8039b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b8:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039cb:	79 05                	jns    8039d2 <pipe+0xe3>
		goto err2;
  8039cd:	e9 d9 00 00 00       	jmpq   803aab <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d6:	48 89 c7             	mov    %rax,%rdi
  8039d9:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
  8039e5:	48 89 c2             	mov    %rax,%rdx
  8039e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ec:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8039f2:	48 89 d1             	mov    %rdx,%rcx
  8039f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8039fa:	48 89 c6             	mov    %rax,%rsi
  8039fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803a02:	48 b8 ae 24 80 00 00 	movabs $0x8024ae,%rax
  803a09:	00 00 00 
  803a0c:	ff d0                	callq  *%rax
  803a0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a11:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a15:	79 1b                	jns    803a32 <pipe+0x143>
		goto err3;
  803a17:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803a18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1c:	48 89 c6             	mov    %rax,%rsi
  803a1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803a24:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
  803a30:	eb 79                	jmp    803aab <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a36:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803a3d:	00 00 00 
  803a40:	8b 12                	mov    (%rdx),%edx
  803a42:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a53:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803a5a:	00 00 00 
  803a5d:	8b 12                	mov    (%rdx),%edx
  803a5f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a65:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a70:	48 89 c7             	mov    %rax,%rdi
  803a73:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803a7a:	00 00 00 
  803a7d:	ff d0                	callq  *%rax
  803a7f:	89 c2                	mov    %eax,%edx
  803a81:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a85:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a8b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a93:	48 89 c7             	mov    %rax,%rdi
  803a96:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
  803aa2:	89 03                	mov    %eax,(%rbx)
	return 0;
  803aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa9:	eb 33                	jmp    803ade <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803aab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aaf:	48 89 c6             	mov    %rax,%rsi
  803ab2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab7:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803abe:	00 00 00 
  803ac1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac7:	48 89 c6             	mov    %rax,%rsi
  803aca:	bf 00 00 00 00       	mov    $0x0,%edi
  803acf:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
err:
	return r;
  803adb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ade:	48 83 c4 38          	add    $0x38,%rsp
  803ae2:	5b                   	pop    %rbx
  803ae3:	5d                   	pop    %rbp
  803ae4:	c3                   	retq   

0000000000803ae5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ae5:	55                   	push   %rbp
  803ae6:	48 89 e5             	mov    %rsp,%rbp
  803ae9:	53                   	push   %rbx
  803aea:	48 83 ec 28          	sub    $0x28,%rsp
  803aee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803af2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803af6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803afd:	00 00 00 
  803b00:	48 8b 00             	mov    (%rax),%rax
  803b03:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b09:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b10:	48 89 c7             	mov    %rax,%rdi
  803b13:	48 b8 6b 41 80 00 00 	movabs $0x80416b,%rax
  803b1a:	00 00 00 
  803b1d:	ff d0                	callq  *%rax
  803b1f:	89 c3                	mov    %eax,%ebx
  803b21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b25:	48 89 c7             	mov    %rax,%rdi
  803b28:	48 b8 6b 41 80 00 00 	movabs $0x80416b,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	39 c3                	cmp    %eax,%ebx
  803b36:	0f 94 c0             	sete   %al
  803b39:	0f b6 c0             	movzbl %al,%eax
  803b3c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b3f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b46:	00 00 00 
  803b49:	48 8b 00             	mov    (%rax),%rax
  803b4c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b52:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b58:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b5b:	75 05                	jne    803b62 <_pipeisclosed+0x7d>
			return ret;
  803b5d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b60:	eb 4f                	jmp    803bb1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803b62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b65:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b68:	74 42                	je     803bac <_pipeisclosed+0xc7>
  803b6a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b6e:	75 3c                	jne    803bac <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b70:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b77:	00 00 00 
  803b7a:	48 8b 00             	mov    (%rax),%rax
  803b7d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b83:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b89:	89 c6                	mov    %eax,%esi
  803b8b:	48 bf d3 4c 80 00 00 	movabs $0x804cd3,%rdi
  803b92:	00 00 00 
  803b95:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9a:	49 b8 67 0f 80 00 00 	movabs $0x800f67,%r8
  803ba1:	00 00 00 
  803ba4:	41 ff d0             	callq  *%r8
	}
  803ba7:	e9 4a ff ff ff       	jmpq   803af6 <_pipeisclosed+0x11>
  803bac:	e9 45 ff ff ff       	jmpq   803af6 <_pipeisclosed+0x11>
}
  803bb1:	48 83 c4 28          	add    $0x28,%rsp
  803bb5:	5b                   	pop    %rbx
  803bb6:	5d                   	pop    %rbp
  803bb7:	c3                   	retq   

0000000000803bb8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803bb8:	55                   	push   %rbp
  803bb9:	48 89 e5             	mov    %rsp,%rbp
  803bbc:	48 83 ec 30          	sub    $0x30,%rsp
  803bc0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bc3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bc7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803bca:	48 89 d6             	mov    %rdx,%rsi
  803bcd:	89 c7                	mov    %eax,%edi
  803bcf:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
  803bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be2:	79 05                	jns    803be9 <pipeisclosed+0x31>
		return r;
  803be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be7:	eb 31                	jmp    803c1a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bed:	48 89 c7             	mov    %rax,%rdi
  803bf0:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  803bf7:	00 00 00 
  803bfa:	ff d0                	callq  *%rax
  803bfc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c08:	48 89 d6             	mov    %rdx,%rsi
  803c0b:	48 89 c7             	mov    %rax,%rdi
  803c0e:	48 b8 e5 3a 80 00 00 	movabs $0x803ae5,%rax
  803c15:	00 00 00 
  803c18:	ff d0                	callq  *%rax
}
  803c1a:	c9                   	leaveq 
  803c1b:	c3                   	retq   

0000000000803c1c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c1c:	55                   	push   %rbp
  803c1d:	48 89 e5             	mov    %rsp,%rbp
  803c20:	48 83 ec 40          	sub    $0x40,%rsp
  803c24:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c2c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c34:	48 89 c7             	mov    %rax,%rdi
  803c37:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  803c3e:	00 00 00 
  803c41:	ff d0                	callq  *%rax
  803c43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c4f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c56:	00 
  803c57:	e9 92 00 00 00       	jmpq   803cee <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803c5c:	eb 41                	jmp    803c9f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c5e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c63:	74 09                	je     803c6e <devpipe_read+0x52>
				return i;
  803c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c69:	e9 92 00 00 00       	jmpq   803d00 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c76:	48 89 d6             	mov    %rdx,%rsi
  803c79:	48 89 c7             	mov    %rax,%rdi
  803c7c:	48 b8 e5 3a 80 00 00 	movabs $0x803ae5,%rax
  803c83:	00 00 00 
  803c86:	ff d0                	callq  *%rax
  803c88:	85 c0                	test   %eax,%eax
  803c8a:	74 07                	je     803c93 <devpipe_read+0x77>
				return 0;
  803c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c91:	eb 6d                	jmp    803d00 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c93:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca3:	8b 10                	mov    (%rax),%edx
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	8b 40 04             	mov    0x4(%rax),%eax
  803cac:	39 c2                	cmp    %eax,%edx
  803cae:	74 ae                	je     803c5e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cb8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc0:	8b 00                	mov    (%rax),%eax
  803cc2:	99                   	cltd   
  803cc3:	c1 ea 1b             	shr    $0x1b,%edx
  803cc6:	01 d0                	add    %edx,%eax
  803cc8:	83 e0 1f             	and    $0x1f,%eax
  803ccb:	29 d0                	sub    %edx,%eax
  803ccd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cd1:	48 98                	cltq   
  803cd3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803cd8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cde:	8b 00                	mov    (%rax),%eax
  803ce0:	8d 50 01             	lea    0x1(%rax),%edx
  803ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ce9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cf6:	0f 82 60 ff ff ff    	jb     803c5c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d00:	c9                   	leaveq 
  803d01:	c3                   	retq   

0000000000803d02 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d02:	55                   	push   %rbp
  803d03:	48 89 e5             	mov    %rsp,%rbp
  803d06:	48 83 ec 40          	sub    $0x40,%rsp
  803d0a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d0e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d12:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d1a:	48 89 c7             	mov    %rax,%rdi
  803d1d:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  803d24:	00 00 00 
  803d27:	ff d0                	callq  *%rax
  803d29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d35:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d3c:	00 
  803d3d:	e9 8e 00 00 00       	jmpq   803dd0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d42:	eb 31                	jmp    803d75 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4c:	48 89 d6             	mov    %rdx,%rsi
  803d4f:	48 89 c7             	mov    %rax,%rdi
  803d52:	48 b8 e5 3a 80 00 00 	movabs $0x803ae5,%rax
  803d59:	00 00 00 
  803d5c:	ff d0                	callq  *%rax
  803d5e:	85 c0                	test   %eax,%eax
  803d60:	74 07                	je     803d69 <devpipe_write+0x67>
				return 0;
  803d62:	b8 00 00 00 00       	mov    $0x0,%eax
  803d67:	eb 79                	jmp    803de2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d69:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d79:	8b 40 04             	mov    0x4(%rax),%eax
  803d7c:	48 63 d0             	movslq %eax,%rdx
  803d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d83:	8b 00                	mov    (%rax),%eax
  803d85:	48 98                	cltq   
  803d87:	48 83 c0 20          	add    $0x20,%rax
  803d8b:	48 39 c2             	cmp    %rax,%rdx
  803d8e:	73 b4                	jae    803d44 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d94:	8b 40 04             	mov    0x4(%rax),%eax
  803d97:	99                   	cltd   
  803d98:	c1 ea 1b             	shr    $0x1b,%edx
  803d9b:	01 d0                	add    %edx,%eax
  803d9d:	83 e0 1f             	and    $0x1f,%eax
  803da0:	29 d0                	sub    %edx,%eax
  803da2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803da6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803daa:	48 01 ca             	add    %rcx,%rdx
  803dad:	0f b6 0a             	movzbl (%rdx),%ecx
  803db0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803db4:	48 98                	cltq   
  803db6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbe:	8b 40 04             	mov    0x4(%rax),%eax
  803dc1:	8d 50 01             	lea    0x1(%rax),%edx
  803dc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dcb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dd8:	0f 82 64 ff ff ff    	jb     803d42 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803de2:	c9                   	leaveq 
  803de3:	c3                   	retq   

0000000000803de4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803de4:	55                   	push   %rbp
  803de5:	48 89 e5             	mov    %rsp,%rbp
  803de8:	48 83 ec 20          	sub    $0x20,%rsp
  803dec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803df0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df8:	48 89 c7             	mov    %rax,%rdi
  803dfb:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  803e02:	00 00 00 
  803e05:	ff d0                	callq  *%rax
  803e07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e0f:	48 be e6 4c 80 00 00 	movabs $0x804ce6,%rsi
  803e16:	00 00 00 
  803e19:	48 89 c7             	mov    %rax,%rdi
  803e1c:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  803e23:	00 00 00 
  803e26:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e2c:	8b 50 04             	mov    0x4(%rax),%edx
  803e2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e33:	8b 00                	mov    (%rax),%eax
  803e35:	29 c2                	sub    %eax,%edx
  803e37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e3b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e45:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e4c:	00 00 00 
	stat->st_dev = &devpipe;
  803e4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e53:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803e5a:	00 00 00 
  803e5d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e69:	c9                   	leaveq 
  803e6a:	c3                   	retq   

0000000000803e6b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e6b:	55                   	push   %rbp
  803e6c:	48 89 e5             	mov    %rsp,%rbp
  803e6f:	48 83 ec 10          	sub    $0x10,%rsp
  803e73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e7b:	48 89 c6             	mov    %rax,%rsi
  803e7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e83:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803e8a:	00 00 00 
  803e8d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e93:	48 89 c7             	mov    %rax,%rdi
  803e96:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  803e9d:	00 00 00 
  803ea0:	ff d0                	callq  *%rax
  803ea2:	48 89 c6             	mov    %rax,%rsi
  803ea5:	bf 00 00 00 00       	mov    $0x0,%edi
  803eaa:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
}
  803eb6:	c9                   	leaveq 
  803eb7:	c3                   	retq   

0000000000803eb8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803eb8:	55                   	push   %rbp
  803eb9:	48 89 e5             	mov    %rsp,%rbp
  803ebc:	48 83 ec 20          	sub    $0x20,%rsp
  803ec0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ec3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ec9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ecd:	be 01 00 00 00       	mov    $0x1,%esi
  803ed2:	48 89 c7             	mov    %rax,%rdi
  803ed5:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  803edc:	00 00 00 
  803edf:	ff d0                	callq  *%rax
}
  803ee1:	c9                   	leaveq 
  803ee2:	c3                   	retq   

0000000000803ee3 <getchar>:

int
getchar(void)
{
  803ee3:	55                   	push   %rbp
  803ee4:	48 89 e5             	mov    %rsp,%rbp
  803ee7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803eeb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803eef:	ba 01 00 00 00       	mov    $0x1,%edx
  803ef4:	48 89 c6             	mov    %rax,%rsi
  803ef7:	bf 00 00 00 00       	mov    $0x0,%edi
  803efc:	48 b8 be 2d 80 00 00 	movabs $0x802dbe,%rax
  803f03:	00 00 00 
  803f06:	ff d0                	callq  *%rax
  803f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0f:	79 05                	jns    803f16 <getchar+0x33>
		return r;
  803f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f14:	eb 14                	jmp    803f2a <getchar+0x47>
	if (r < 1)
  803f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f1a:	7f 07                	jg     803f23 <getchar+0x40>
		return -E_EOF;
  803f1c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f21:	eb 07                	jmp    803f2a <getchar+0x47>
	return c;
  803f23:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f27:	0f b6 c0             	movzbl %al,%eax
}
  803f2a:	c9                   	leaveq 
  803f2b:	c3                   	retq   

0000000000803f2c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f2c:	55                   	push   %rbp
  803f2d:	48 89 e5             	mov    %rsp,%rbp
  803f30:	48 83 ec 20          	sub    $0x20,%rsp
  803f34:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f37:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3e:	48 89 d6             	mov    %rdx,%rsi
  803f41:	89 c7                	mov    %eax,%edi
  803f43:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  803f4a:	00 00 00 
  803f4d:	ff d0                	callq  *%rax
  803f4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f56:	79 05                	jns    803f5d <iscons+0x31>
		return r;
  803f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5b:	eb 1a                	jmp    803f77 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f61:	8b 10                	mov    (%rax),%edx
  803f63:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803f6a:	00 00 00 
  803f6d:	8b 00                	mov    (%rax),%eax
  803f6f:	39 c2                	cmp    %eax,%edx
  803f71:	0f 94 c0             	sete   %al
  803f74:	0f b6 c0             	movzbl %al,%eax
}
  803f77:	c9                   	leaveq 
  803f78:	c3                   	retq   

0000000000803f79 <opencons>:

int
opencons(void)
{
  803f79:	55                   	push   %rbp
  803f7a:	48 89 e5             	mov    %rsp,%rbp
  803f7d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f81:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f85:	48 89 c7             	mov    %rax,%rdi
  803f88:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  803f8f:	00 00 00 
  803f92:	ff d0                	callq  *%rax
  803f94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9b:	79 05                	jns    803fa2 <opencons+0x29>
		return r;
  803f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa0:	eb 5b                	jmp    803ffd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa6:	ba 07 04 00 00       	mov    $0x407,%edx
  803fab:	48 89 c6             	mov    %rax,%rsi
  803fae:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb3:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
  803fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc6:	79 05                	jns    803fcd <opencons+0x54>
		return r;
  803fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcb:	eb 30                	jmp    803ffd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd1:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803fd8:	00 00 00 
  803fdb:	8b 12                	mov    (%rdx),%edx
  803fdd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803fdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fee:	48 89 c7             	mov    %rax,%rdi
  803ff1:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803ff8:	00 00 00 
  803ffb:	ff d0                	callq  *%rax
}
  803ffd:	c9                   	leaveq 
  803ffe:	c3                   	retq   

0000000000803fff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fff:	55                   	push   %rbp
  804000:	48 89 e5             	mov    %rsp,%rbp
  804003:	48 83 ec 30          	sub    $0x30,%rsp
  804007:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80400b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80400f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804013:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804018:	75 07                	jne    804021 <devcons_read+0x22>
		return 0;
  80401a:	b8 00 00 00 00       	mov    $0x0,%eax
  80401f:	eb 4b                	jmp    80406c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804021:	eb 0c                	jmp    80402f <devcons_read+0x30>
		sys_yield();
  804023:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  80402a:	00 00 00 
  80402d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80402f:	48 b8 60 23 80 00 00 	movabs $0x802360,%rax
  804036:	00 00 00 
  804039:	ff d0                	callq  *%rax
  80403b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804042:	74 df                	je     804023 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804044:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804048:	79 05                	jns    80404f <devcons_read+0x50>
		return c;
  80404a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404d:	eb 1d                	jmp    80406c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80404f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804053:	75 07                	jne    80405c <devcons_read+0x5d>
		return 0;
  804055:	b8 00 00 00 00       	mov    $0x0,%eax
  80405a:	eb 10                	jmp    80406c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80405c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405f:	89 c2                	mov    %eax,%edx
  804061:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804065:	88 10                	mov    %dl,(%rax)
	return 1;
  804067:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80406c:	c9                   	leaveq 
  80406d:	c3                   	retq   

000000000080406e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80406e:	55                   	push   %rbp
  80406f:	48 89 e5             	mov    %rsp,%rbp
  804072:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804079:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804080:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804087:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80408e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804095:	eb 76                	jmp    80410d <devcons_write+0x9f>
		m = n - tot;
  804097:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80409e:	89 c2                	mov    %eax,%edx
  8040a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a3:	29 c2                	sub    %eax,%edx
  8040a5:	89 d0                	mov    %edx,%eax
  8040a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8040aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ad:	83 f8 7f             	cmp    $0x7f,%eax
  8040b0:	76 07                	jbe    8040b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8040b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8040b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040bc:	48 63 d0             	movslq %eax,%rdx
  8040bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c2:	48 63 c8             	movslq %eax,%rcx
  8040c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8040cc:	48 01 c1             	add    %rax,%rcx
  8040cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040d6:	48 89 ce             	mov    %rcx,%rsi
  8040d9:	48 89 c7             	mov    %rax,%rdi
  8040dc:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8040e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040eb:	48 63 d0             	movslq %eax,%rdx
  8040ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040f5:	48 89 d6             	mov    %rdx,%rsi
  8040f8:	48 89 c7             	mov    %rax,%rdi
  8040fb:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  804102:	00 00 00 
  804105:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804107:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80410a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80410d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804110:	48 98                	cltq   
  804112:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804119:	0f 82 78 ff ff ff    	jb     804097 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80411f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804122:	c9                   	leaveq 
  804123:	c3                   	retq   

0000000000804124 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804124:	55                   	push   %rbp
  804125:	48 89 e5             	mov    %rsp,%rbp
  804128:	48 83 ec 08          	sub    $0x8,%rsp
  80412c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804135:	c9                   	leaveq 
  804136:	c3                   	retq   

0000000000804137 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804137:	55                   	push   %rbp
  804138:	48 89 e5             	mov    %rsp,%rbp
  80413b:	48 83 ec 10          	sub    $0x10,%rsp
  80413f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804143:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80414b:	48 be f2 4c 80 00 00 	movabs $0x804cf2,%rsi
  804152:	00 00 00 
  804155:	48 89 c7             	mov    %rax,%rdi
  804158:	48 b8 2f 1b 80 00 00 	movabs $0x801b2f,%rax
  80415f:	00 00 00 
  804162:	ff d0                	callq  *%rax
	return 0;
  804164:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804169:	c9                   	leaveq 
  80416a:	c3                   	retq   

000000000080416b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80416b:	55                   	push   %rbp
  80416c:	48 89 e5             	mov    %rsp,%rbp
  80416f:	48 83 ec 18          	sub    $0x18,%rsp
  804173:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804177:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80417b:	48 c1 e8 15          	shr    $0x15,%rax
  80417f:	48 89 c2             	mov    %rax,%rdx
  804182:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804189:	01 00 00 
  80418c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804190:	83 e0 01             	and    $0x1,%eax
  804193:	48 85 c0             	test   %rax,%rax
  804196:	75 07                	jne    80419f <pageref+0x34>
		return 0;
  804198:	b8 00 00 00 00       	mov    $0x0,%eax
  80419d:	eb 53                	jmp    8041f2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80419f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8041a7:	48 89 c2             	mov    %rax,%rdx
  8041aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041b1:	01 00 00 
  8041b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8041bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041c0:	83 e0 01             	and    $0x1,%eax
  8041c3:	48 85 c0             	test   %rax,%rax
  8041c6:	75 07                	jne    8041cf <pageref+0x64>
		return 0;
  8041c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041cd:	eb 23                	jmp    8041f2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8041cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8041d7:	48 89 c2             	mov    %rax,%rdx
  8041da:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8041e1:	00 00 00 
  8041e4:	48 c1 e2 04          	shl    $0x4,%rdx
  8041e8:	48 01 d0             	add    %rdx,%rax
  8041eb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8041ef:	0f b7 c0             	movzwl %ax,%eax
}
  8041f2:	c9                   	leaveq 
  8041f3:	c3                   	retq   
