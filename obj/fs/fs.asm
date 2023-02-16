
obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 ca 30 00 00       	callq  80310b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf e0 67 80 00 00 	movabs $0x8067e0,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba f7 67 80 00 00 	movabs $0x8067f7,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf 07 68 80 00 00 	movabs $0x806807,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 10 68 80 00 00 	movabs $0x806810,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba 1d 68 80 00 00 	movabs $0x80681d,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf 07 68 80 00 00 	movabs $0x806807,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 10 68 80 00 00 	movabs $0x806810,%rcx
  800345:	00 00 00 
  800348:	48 ba 1d 68 80 00 00 	movabs $0x80681d,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf 07 68 80 00 00 	movabs $0x806807,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba 38 68 80 00 00 	movabs $0x806838,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 30          	sub    $0x30,%rsp
  8005fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: rip %08x, va %08x, err %04x",
  800631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba 68 68 80 00 00 	movabs $0x806868,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba bf 31 80 00 00 	movabs $0x8031bf,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba 98 68 80 00 00 	movabs $0x806898,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: your code here:
	addr = (void *)ROUNDDOWN(addr, PGSIZE);
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	r = sys_page_alloc(0, addr, PTE_U | PTE_W | PTE_P);
  8006ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8006f7:	48 89 c6             	mov    %rax,%rsi
  8006fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8006ff:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	if (r < 0 )
  80070e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800712:	79 2a                	jns    80073e <bc_pgfault+0x14b>
		panic("bc_pgfault: sys_page_alloc fail\n");
  800714:	48 ba c0 68 80 00 00 	movabs $0x8068c0,%rdx
  80071b:	00 00 00 
  80071e:	be 36 00 00 00       	mov    $0x36,%esi
  800723:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  80072a:	00 00 00 
  80072d:	b8 00 00 00 00       	mov    $0x0,%eax
  800732:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800739:	00 00 00 
  80073c:	ff d1                	callq  *%rcx
	r = ide_read(blockno*BLKSECTS, addr, BLKSECTS);
  80073e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800742:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800749:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80074d:	ba 08 00 00 00       	mov    $0x8,%edx
  800752:	48 89 c6             	mov    %rax,%rsi
  800755:	89 cf                	mov    %ecx,%edi
  800757:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  80075e:	00 00 00 
  800761:	ff d0                	callq  *%rax
  800763:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	if (r < 0)
  800766:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80076a:	79 2a                	jns    800796 <bc_pgfault+0x1a3>
		panic("bc_pgfault: ide_read error\n");
  80076c:	48 ba e1 68 80 00 00 	movabs $0x8068e1,%rdx
  800773:	00 00 00 
  800776:	be 39 00 00 00       	mov    $0x39,%esi
  80077b:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800782:	00 00 00 
  800785:	b8 00 00 00 00       	mov    $0x0,%eax
  80078a:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800791:	00 00 00 
  800794:	ff d1                	callq  *%rcx


	// LAB 5: Your code here


	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80079a:	48 c1 e8 0c          	shr    $0xc,%rax
  80079e:	48 89 c2             	mov    %rax,%rdx
  8007a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007a8:	01 00 00 
  8007ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007af:	25 07 0e 00 00       	and    $0xe07,%eax
  8007b4:	89 c1                	mov    %eax,%ecx
  8007b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007be:	41 89 c8             	mov    %ecx,%r8d
  8007c1:	48 89 d1             	mov    %rdx,%rcx
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	48 89 c6             	mov    %rax,%rsi
  8007cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8007d1:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  8007d8:	00 00 00 
  8007db:	ff d0                	callq  *%rax
  8007dd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007e4:	79 30                	jns    800816 <bc_pgfault+0x223>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007e6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007e9:	89 c1                	mov    %eax,%ecx
  8007eb:	48 ba 00 69 80 00 00 	movabs $0x806900,%rdx
  8007f2:	00 00 00 
  8007f5:	be 42 00 00 00       	mov    $0x42,%esi
  8007fa:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800801:	00 00 00 
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  800810:	00 00 00 
  800813:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800816:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  80081d:	00 00 00 
  800820:	48 8b 00             	mov    (%rax),%rax
  800823:	48 85 c0             	test   %rax,%rax
  800826:	74 48                	je     800870 <bc_pgfault+0x27d>
  800828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80082c:	89 c7                	mov    %eax,%edi
  80082e:	48 b8 87 0d 80 00 00 	movabs $0x800d87,%rax
  800835:	00 00 00 
  800838:	ff d0                	callq  *%rax
  80083a:	84 c0                	test   %al,%al
  80083c:	74 32                	je     800870 <bc_pgfault+0x27d>
		panic("reading free block %08x\n", blockno);
  80083e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800842:	48 89 c1             	mov    %rax,%rcx
  800845:	48 ba 20 69 80 00 00 	movabs $0x806920,%rdx
  80084c:	00 00 00 
  80084f:	be 48 00 00 00       	mov    $0x48,%esi
  800854:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  80085b:	00 00 00 
  80085e:	b8 00 00 00 00       	mov    $0x0,%eax
  800863:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  80086a:	00 00 00 
  80086d:	41 ff d0             	callq  *%r8
}
  800870:	c9                   	leaveq 
  800871:	c3                   	retq   

0000000000800872 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800872:	55                   	push   %rbp
  800873:	48 89 e5             	mov    %rsp,%rbp
  800876:	48 83 ec 30          	sub    $0x30,%rsp
  80087a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80087e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800882:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800888:	48 c1 e8 0c          	shr    $0xc,%rax
  80088c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800890:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  800897:	0f 
  800898:	76 0b                	jbe    8008a5 <flush_block+0x33>
  80089a:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80089f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8008a3:	76 32                	jbe    8008d7 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  8008a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a9:	48 89 c1             	mov    %rax,%rcx
  8008ac:	48 ba 39 69 80 00 00 	movabs $0x806939,%rdx
  8008b3:	00 00 00 
  8008b6:	be 58 00 00 00       	mov    $0x58,%esi
  8008bb:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  8008c2:	00 00 00 
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8008d1:	00 00 00 
  8008d4:	41 ff d0             	callq  *%r8

	// LAB 5: Your code here.

	int r;
	if (!va_is_mapped(addr) || !va_is_dirty(addr))
  8008d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008db:	48 89 c7             	mov    %rax,%rdi
  8008de:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8008e5:	00 00 00 
  8008e8:	ff d0                	callq  *%rax
  8008ea:	83 f0 01             	xor    $0x1,%eax
  8008ed:	84 c0                	test   %al,%al
  8008ef:	75 1a                	jne    80090b <flush_block+0x99>
  8008f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008f5:	48 89 c7             	mov    %rax,%rdi
  8008f8:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  8008ff:	00 00 00 
  800902:	ff d0                	callq  *%rax
  800904:	83 f0 01             	xor    $0x1,%eax
  800907:	84 c0                	test   %al,%al
  800909:	74 05                	je     800910 <flush_block+0x9e>
		return ;
  80090b:	e9 e9 00 00 00       	jmpq   8009f9 <flush_block+0x187>
	addr = (void *)ROUNDDOWN(addr, PGSIZE);
  800910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800914:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80091c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800922:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (ide_write(blockno*BLKSECTS, addr, BLKSECTS) < 0)
  800926:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80092a:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800935:	ba 08 00 00 00       	mov    $0x8,%edx
  80093a:	48 89 c6             	mov    %rax,%rsi
  80093d:	89 cf                	mov    %ecx,%edi
  80093f:	48 b8 21 03 80 00 00 	movabs $0x800321,%rax
  800946:	00 00 00 
  800949:	ff d0                	callq  *%rax
  80094b:	85 c0                	test   %eax,%eax
  80094d:	79 2a                	jns    800979 <flush_block+0x107>
		panic("flush_block: ide_write error\n");
  80094f:	48 ba 54 69 80 00 00 	movabs $0x806954,%rdx
  800956:	00 00 00 
  800959:	be 61 00 00 00       	mov    $0x61,%esi
  80095e:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800965:	00 00 00 
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
  80096d:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800974:	00 00 00 
  800977:	ff d1                	callq  *%rcx

	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800979:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097d:	48 c1 e8 0c          	shr    $0xc,%rax
  800981:	48 89 c2             	mov    %rax,%rdx
  800984:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80098b:	01 00 00 
  80098e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800992:	25 07 0e 00 00       	and    $0xe07,%eax
  800997:	89 c1                	mov    %eax,%ecx
  800999:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80099d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009a1:	41 89 c8             	mov    %ecx,%r8d
  8009a4:	48 89 d1             	mov    %rdx,%rcx
  8009a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ac:	48 89 c6             	mov    %rax,%rsi
  8009af:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b4:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  8009bb:	00 00 00 
  8009be:	ff d0                	callq  *%rax
  8009c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8009c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8009c7:	79 30                	jns    8009f9 <flush_block+0x187>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8009c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009cc:	89 c1                	mov    %eax,%ecx
  8009ce:	48 ba 00 69 80 00 00 	movabs $0x806900,%rdx
  8009d5:	00 00 00 
  8009d8:	be 64 00 00 00       	mov    $0x64,%esi
  8009dd:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  8009e4:	00 00 00 
  8009e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ec:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8009f3:	00 00 00 
  8009f6:	41 ff d0             	callq  *%r8

	//panic("flush_block not implemented");
}
  8009f9:	c9                   	leaveq 
  8009fa:	c3                   	retq   

00000000008009fb <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8009fb:	55                   	push   %rbp
  8009fc:	48 89 e5             	mov    %rsp,%rbp
  8009ff:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800a06:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0b:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a12:	00 00 00 
  800a15:	ff d0                	callq  *%rax
  800a17:	48 89 c1             	mov    %rax,%rcx
  800a1a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800a21:	ba 08 01 00 00       	mov    $0x108,%edx
  800a26:	48 89 ce             	mov    %rcx,%rsi
  800a29:	48 89 c7             	mov    %rax,%rdi
  800a2c:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  800a33:	00 00 00 
  800a36:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800a38:	bf 01 00 00 00       	mov    $0x1,%edi
  800a3d:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a44:	00 00 00 
  800a47:	ff d0                	callq  *%rax
  800a49:	48 be 72 69 80 00 00 	movabs $0x806972,%rsi
  800a50:	00 00 00 
  800a53:	48 89 c7             	mov    %rax,%rdi
  800a56:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  800a5d:	00 00 00 
  800a60:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a62:	bf 01 00 00 00       	mov    $0x1,%edi
  800a67:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a6e:	00 00 00 
  800a71:	ff d0                	callq  *%rax
  800a73:	48 89 c7             	mov    %rax,%rdi
  800a76:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  800a7d:	00 00 00 
  800a80:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a82:	bf 01 00 00 00       	mov    $0x1,%edi
  800a87:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	callq  *%rax
  800a93:	48 89 c7             	mov    %rax,%rdi
  800a96:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800a9d:	00 00 00 
  800aa0:	ff d0                	callq  *%rax
  800aa2:	83 f0 01             	xor    $0x1,%eax
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 35                	je     800ade <check_bc+0xe3>
  800aa9:	48 b9 79 69 80 00 00 	movabs $0x806979,%rcx
  800ab0:	00 00 00 
  800ab3:	48 ba 93 69 80 00 00 	movabs $0x806993,%rdx
  800aba:	00 00 00 
  800abd:	be 76 00 00 00       	mov    $0x76,%esi
  800ac2:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800ac9:	00 00 00 
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  800ad8:	00 00 00 
  800adb:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800ade:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800aea:	00 00 00 
  800aed:	ff d0                	callq  *%rax
  800aef:	48 89 c7             	mov    %rax,%rdi
  800af2:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800af9:	00 00 00 
  800afc:	ff d0                	callq  *%rax
  800afe:	84 c0                	test   %al,%al
  800b00:	74 35                	je     800b37 <check_bc+0x13c>
  800b02:	48 b9 a8 69 80 00 00 	movabs $0x8069a8,%rcx
  800b09:	00 00 00 
  800b0c:	48 ba 93 69 80 00 00 	movabs $0x806993,%rdx
  800b13:	00 00 00 
  800b16:	be 77 00 00 00       	mov    $0x77,%esi
  800b1b:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800b22:	00 00 00 
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2a:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  800b31:	00 00 00 
  800b34:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800b37:	bf 01 00 00 00       	mov    $0x1,%edi
  800b3c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b43:	00 00 00 
  800b46:	ff d0                	callq  *%rax
  800b48:	48 89 c6             	mov    %rax,%rsi
  800b4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800b50:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  800b57:	00 00 00 
  800b5a:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b5c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b61:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b68:	00 00 00 
  800b6b:	ff d0                	callq  *%rax
  800b6d:	48 89 c7             	mov    %rax,%rdi
  800b70:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800b77:	00 00 00 
  800b7a:	ff d0                	callq  *%rax
  800b7c:	84 c0                	test   %al,%al
  800b7e:	74 35                	je     800bb5 <check_bc+0x1ba>
  800b80:	48 b9 c2 69 80 00 00 	movabs $0x8069c2,%rcx
  800b87:	00 00 00 
  800b8a:	48 ba 93 69 80 00 00 	movabs $0x806993,%rdx
  800b91:	00 00 00 
  800b94:	be 7b 00 00 00       	mov    $0x7b,%esi
  800b99:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800ba0:	00 00 00 
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba8:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  800baf:	00 00 00 
  800bb2:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800bb5:	bf 01 00 00 00       	mov    $0x1,%edi
  800bba:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bc1:	00 00 00 
  800bc4:	ff d0                	callq  *%rax
  800bc6:	48 be 72 69 80 00 00 	movabs $0x806972,%rsi
  800bcd:	00 00 00 
  800bd0:	48 89 c7             	mov    %rax,%rdi
  800bd3:	48 b8 22 41 80 00 00 	movabs $0x804122,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
  800bdf:	85 c0                	test   %eax,%eax
  800be1:	74 35                	je     800c18 <check_bc+0x21d>
  800be3:	48 b9 e0 69 80 00 00 	movabs $0x8069e0,%rcx
  800bea:	00 00 00 
  800bed:	48 ba 93 69 80 00 00 	movabs $0x806993,%rdx
  800bf4:	00 00 00 
  800bf7:	be 7e 00 00 00       	mov    $0x7e,%esi
  800bfc:	48 bf 5a 68 80 00 00 	movabs $0x80685a,%rdi
  800c03:	00 00 00 
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0b:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  800c12:	00 00 00 
  800c15:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800c18:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1d:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c24:	00 00 00 
  800c27:	ff d0                	callq  *%rax
  800c29:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800c30:	ba 08 01 00 00       	mov    $0x108,%edx
  800c35:	48 89 ce             	mov    %rcx,%rsi
  800c38:	48 89 c7             	mov    %rax,%rdi
  800c3b:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  800c42:	00 00 00 
  800c45:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800c47:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c53:	00 00 00 
  800c56:	ff d0                	callq  *%rax
  800c58:	48 89 c7             	mov    %rax,%rdi
  800c5b:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  800c62:	00 00 00 
  800c65:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c67:	48 bf 04 6a 80 00 00 	movabs $0x806a04,%rdi
  800c6e:	00 00 00 
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  800c7d:	00 00 00 
  800c80:	ff d2                	callq  *%rdx
}
  800c82:	c9                   	leaveq 
  800c83:	c3                   	retq   

0000000000800c84 <bc_init>:

void
bc_init(void)
{
  800c84:	55                   	push   %rbp
  800c85:	48 89 e5             	mov    %rsp,%rbp
  800c88:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c8f:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800c96:	00 00 00 
  800c99:	48 b8 5c 4b 80 00 00 	movabs $0x804b5c,%rax
  800ca0:	00 00 00 
  800ca3:	ff d0                	callq  *%rax
	check_bc();
  800ca5:	48 b8 fb 09 80 00 00 	movabs $0x8009fb,%rax
  800cac:	00 00 00 
  800caf:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800cb1:	bf 01 00 00 00       	mov    $0x1,%edi
  800cb6:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	callq  *%rax
  800cc2:	48 89 c1             	mov    %rax,%rcx
  800cc5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ccc:	ba 08 01 00 00       	mov    $0x108,%edx
  800cd1:	48 89 ce             	mov    %rcx,%rsi
  800cd4:	48 89 c7             	mov    %rax,%rdi
  800cd7:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	callq  *%rax
}
  800ce3:	c9                   	leaveq 
  800ce4:	c3                   	retq   

0000000000800ce5 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800ce5:	55                   	push   %rbp
  800ce6:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800ce9:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800cf0:	00 00 00 
  800cf3:	48 8b 00             	mov    (%rax),%rax
  800cf6:	8b 00                	mov    (%rax),%eax
  800cf8:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800cfd:	74 2a                	je     800d29 <check_super+0x44>
		panic("bad file system magic number");
  800cff:	48 ba 19 6a 80 00 00 	movabs $0x806a19,%rdx
  800d06:	00 00 00 
  800d09:	be 0e 00 00 00       	mov    $0xe,%esi
  800d0e:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  800d15:	00 00 00 
  800d18:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1d:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800d24:	00 00 00 
  800d27:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800d29:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d30:	00 00 00 
  800d33:	48 8b 00             	mov    (%rax),%rax
  800d36:	8b 40 04             	mov    0x4(%rax),%eax
  800d39:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800d3e:	76 2a                	jbe    800d6a <check_super+0x85>
		panic("file system is too large");
  800d40:	48 ba 3e 6a 80 00 00 	movabs $0x806a3e,%rdx
  800d47:	00 00 00 
  800d4a:	be 11 00 00 00       	mov    $0x11,%esi
  800d4f:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  800d56:	00 00 00 
  800d59:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5e:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800d65:	00 00 00 
  800d68:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d6a:	48 bf 57 6a 80 00 00 	movabs $0x806a57,%rdi
  800d71:	00 00 00 
  800d74:	b8 00 00 00 00       	mov    $0x0,%eax
  800d79:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  800d80:	00 00 00 
  800d83:	ff d2                	callq  *%rdx
}
  800d85:	5d                   	pop    %rbp
  800d86:	c3                   	retq   

0000000000800d87 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d87:	55                   	push   %rbp
  800d88:	48 89 e5             	mov    %rsp,%rbp
  800d8b:	48 83 ec 04          	sub    $0x4,%rsp
  800d8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d92:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d99:	00 00 00 
  800d9c:	48 8b 00             	mov    (%rax),%rax
  800d9f:	48 85 c0             	test   %rax,%rax
  800da2:	74 15                	je     800db9 <block_is_free+0x32>
  800da4:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800dab:	00 00 00 
  800dae:	48 8b 00             	mov    (%rax),%rax
  800db1:	8b 40 04             	mov    0x4(%rax),%eax
  800db4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800db7:	77 07                	ja     800dc0 <block_is_free+0x39>
		return 0;
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbe:	eb 41                	jmp    800e01 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800dc0:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800dc7:	00 00 00 
  800dca:	48 8b 00             	mov    (%rax),%rax
  800dcd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800dd0:	c1 ea 05             	shr    $0x5,%edx
  800dd3:	89 d2                	mov    %edx,%edx
  800dd5:	48 c1 e2 02          	shl    $0x2,%rdx
  800dd9:	48 01 d0             	add    %rdx,%rax
  800ddc:	8b 10                	mov    (%rax),%edx
  800dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800de1:	83 e0 1f             	and    $0x1f,%eax
  800de4:	be 01 00 00 00       	mov    $0x1,%esi
  800de9:	89 c1                	mov    %eax,%ecx
  800deb:	d3 e6                	shl    %cl,%esi
  800ded:	89 f0                	mov    %esi,%eax
  800def:	21 d0                	and    %edx,%eax
  800df1:	85 c0                	test   %eax,%eax
  800df3:	74 07                	je     800dfc <block_is_free+0x75>
		return 1;
  800df5:	b8 01 00 00 00       	mov    $0x1,%eax
  800dfa:	eb 05                	jmp    800e01 <block_is_free+0x7a>
	return 0;
  800dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e01:	c9                   	leaveq 
  800e02:	c3                   	retq   

0000000000800e03 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800e03:	55                   	push   %rbp
  800e04:	48 89 e5             	mov    %rsp,%rbp
  800e07:	48 83 ec 10          	sub    $0x10,%rsp
  800e0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800e0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e12:	75 2a                	jne    800e3e <free_block+0x3b>
		panic("attempt to free zero block");
  800e14:	48 ba 6b 6a 80 00 00 	movabs $0x806a6b,%rdx
  800e1b:	00 00 00 
  800e1e:	be 2c 00 00 00       	mov    $0x2c,%esi
  800e23:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  800e2a:	00 00 00 
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e32:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  800e39:	00 00 00 
  800e3c:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800e3e:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e45:	00 00 00 
  800e48:	48 8b 10             	mov    (%rax),%rdx
  800e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e4e:	c1 e8 05             	shr    $0x5,%eax
  800e51:	89 c1                	mov    %eax,%ecx
  800e53:	48 c1 e1 02          	shl    $0x2,%rcx
  800e57:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e5b:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800e62:	00 00 00 
  800e65:	48 8b 12             	mov    (%rdx),%rdx
  800e68:	89 c0                	mov    %eax,%eax
  800e6a:	48 c1 e0 02          	shl    $0x2,%rax
  800e6e:	48 01 d0             	add    %rdx,%rax
  800e71:	8b 10                	mov    (%rax),%edx
  800e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e76:	83 e0 1f             	and    $0x1f,%eax
  800e79:	bf 01 00 00 00       	mov    $0x1,%edi
  800e7e:	89 c1                	mov    %eax,%ecx
  800e80:	d3 e7                	shl    %cl,%edi
  800e82:	89 f8                	mov    %edi,%eax
  800e84:	09 d0                	or     %edx,%eax
  800e86:	89 06                	mov    %eax,(%rsi)
}
  800e88:	c9                   	leaveq 
  800e89:	c3                   	retq   

0000000000800e8a <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800e8a:	55                   	push   %rbp
  800e8b:	48 89 e5             	mov    %rsp,%rbp
  800e8e:	48 83 ec 10          	sub    $0x10,%rsp
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	int i;

	 for (i = 0; i < super->s_nblocks; i++) {
  800e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e99:	e9 b2 00 00 00       	jmpq   800f50 <alloc_block+0xc6>
			 if (block_is_free(i)) {
  800e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea1:	89 c7                	mov    %eax,%edi
  800ea3:	48 b8 87 0d 80 00 00 	movabs $0x800d87,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	callq  *%rax
  800eaf:	84 c0                	test   %al,%al
  800eb1:	0f 84 95 00 00 00    	je     800f4c <alloc_block+0xc2>
					 bitmap[i / 32] &= ~(1 << (i % 32));
  800eb7:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800ebe:	00 00 00 
  800ec1:	48 8b 10             	mov    (%rax),%rdx
  800ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec7:	8d 48 1f             	lea    0x1f(%rax),%ecx
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	0f 48 c1             	cmovs  %ecx,%eax
  800ecf:	c1 f8 05             	sar    $0x5,%eax
  800ed2:	48 63 c8             	movslq %eax,%rcx
  800ed5:	48 c1 e1 02          	shl    $0x2,%rcx
  800ed9:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800edd:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800ee4:	00 00 00 
  800ee7:	48 8b 12             	mov    (%rdx),%rdx
  800eea:	48 98                	cltq   
  800eec:	48 c1 e0 02          	shl    $0x2,%rax
  800ef0:	48 01 d0             	add    %rdx,%rax
  800ef3:	8b 38                	mov    (%rax),%edi
  800ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ef8:	99                   	cltd   
  800ef9:	c1 ea 1b             	shr    $0x1b,%edx
  800efc:	01 d0                	add    %edx,%eax
  800efe:	83 e0 1f             	and    $0x1f,%eax
  800f01:	29 d0                	sub    %edx,%eax
  800f03:	ba 01 00 00 00       	mov    $0x1,%edx
  800f08:	89 c1                	mov    %eax,%ecx
  800f0a:	d3 e2                	shl    %cl,%edx
  800f0c:	89 d0                	mov    %edx,%eax
  800f0e:	f7 d0                	not    %eax
  800f10:	21 f8                	and    %edi,%eax
  800f12:	89 06                	mov    %eax,(%rsi)
					 flush_block(&bitmap[i / 32]);
  800f14:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800f1b:	00 00 00 
  800f1e:	48 8b 10             	mov    (%rax),%rdx
  800f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f24:	8d 48 1f             	lea    0x1f(%rax),%ecx
  800f27:	85 c0                	test   %eax,%eax
  800f29:	0f 48 c1             	cmovs  %ecx,%eax
  800f2c:	c1 f8 05             	sar    $0x5,%eax
  800f2f:	48 98                	cltq   
  800f31:	48 c1 e0 02          	shl    $0x2,%rax
  800f35:	48 01 d0             	add    %rdx,%rax
  800f38:	48 89 c7             	mov    %rax,%rdi
  800f3b:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  800f42:	00 00 00 
  800f45:	ff d0                	callq  *%rax
					 return i;
  800f47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4a:	eb 24                	jmp    800f70 <alloc_block+0xe6>
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	int i;

	 for (i = 0; i < super->s_nblocks; i++) {
  800f4c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f53:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800f5a:	00 00 00 
  800f5d:	48 8b 00             	mov    (%rax),%rax
  800f60:	8b 40 04             	mov    0x4(%rax),%eax
  800f63:	39 c2                	cmp    %eax,%edx
  800f65:	0f 82 33 ff ff ff    	jb     800e9e <alloc_block+0x14>
					 return i;
			 }
	 }

	// panic("alloc_block not implemented");
	return -E_NO_DISK;
  800f6b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f70:	c9                   	leaveq 
  800f71:	c3                   	retq   

0000000000800f72 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800f72:	55                   	push   %rbp
  800f73:	48 89 e5             	mov    %rsp,%rbp
  800f76:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f81:	eb 51                	jmp    800fd4 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f86:	83 c0 02             	add    $0x2,%eax
  800f89:	89 c7                	mov    %eax,%edi
  800f8b:	48 b8 87 0d 80 00 00 	movabs $0x800d87,%rax
  800f92:	00 00 00 
  800f95:	ff d0                	callq  *%rax
  800f97:	84 c0                	test   %al,%al
  800f99:	74 35                	je     800fd0 <check_bitmap+0x5e>
  800f9b:	48 b9 86 6a 80 00 00 	movabs $0x806a86,%rcx
  800fa2:	00 00 00 
  800fa5:	48 ba 9a 6a 80 00 00 	movabs $0x806a9a,%rdx
  800fac:	00 00 00 
  800faf:	be 59 00 00 00       	mov    $0x59,%esi
  800fb4:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  800fbb:	00 00 00 
  800fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc3:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  800fca:	00 00 00 
  800fcd:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800fd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd7:	c1 e0 0f             	shl    $0xf,%eax
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800fe3:	00 00 00 
  800fe6:	48 8b 00             	mov    (%rax),%rax
  800fe9:	8b 40 04             	mov    0x4(%rax),%eax
  800fec:	39 c2                	cmp    %eax,%edx
  800fee:	72 93                	jb     800f83 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800ff0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff5:	48 b8 87 0d 80 00 00 	movabs $0x800d87,%rax
  800ffc:	00 00 00 
  800fff:	ff d0                	callq  *%rax
  801001:	84 c0                	test   %al,%al
  801003:	74 35                	je     80103a <check_bitmap+0xc8>
  801005:	48 b9 af 6a 80 00 00 	movabs $0x806aaf,%rcx
  80100c:	00 00 00 
  80100f:	48 ba 9a 6a 80 00 00 	movabs $0x806a9a,%rdx
  801016:	00 00 00 
  801019:	be 5c 00 00 00       	mov    $0x5c,%esi
  80101e:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  801025:	00 00 00 
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
  80102d:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  801034:	00 00 00 
  801037:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  80103a:	bf 01 00 00 00       	mov    $0x1,%edi
  80103f:	48 b8 87 0d 80 00 00 	movabs $0x800d87,%rax
  801046:	00 00 00 
  801049:	ff d0                	callq  *%rax
  80104b:	84 c0                	test   %al,%al
  80104d:	74 35                	je     801084 <check_bitmap+0x112>
  80104f:	48 b9 c1 6a 80 00 00 	movabs $0x806ac1,%rcx
  801056:	00 00 00 
  801059:	48 ba 9a 6a 80 00 00 	movabs $0x806a9a,%rdx
  801060:	00 00 00 
  801063:	be 5d 00 00 00       	mov    $0x5d,%esi
  801068:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  80106f:	00 00 00 
  801072:	b8 00 00 00 00       	mov    $0x0,%eax
  801077:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  80107e:	00 00 00 
  801081:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801084:	48 bf d3 6a 80 00 00 	movabs $0x806ad3,%rdi
  80108b:	00 00 00 
  80108e:	b8 00 00 00 00       	mov    $0x0,%eax
  801093:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  80109a:	00 00 00 
  80109d:	ff d2                	callq  *%rdx
}
  80109f:	c9                   	leaveq 
  8010a0:	c3                   	retq   

00000000008010a1 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  8010a1:	55                   	push   %rbp
  8010a2:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);


	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  8010a5:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  8010ac:	00 00 00 
  8010af:	ff d0                	callq  *%rax
  8010b1:	84 c0                	test   %al,%al
  8010b3:	74 13                	je     8010c8 <fs_init+0x27>
		ide_set_disk(1);
  8010b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ba:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	callq  *%rax
  8010c6:	eb 11                	jmp    8010d9 <fs_init+0x38>
	else
		ide_set_disk(0);
  8010c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8010cd:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010d4:	00 00 00 
  8010d7:	ff d0                	callq  *%rax


	bc_init();
  8010d9:	48 b8 84 0c 80 00 00 	movabs $0x800c84,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ea:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010f1:	00 00 00 
  8010f4:	ff d0                	callq  *%rax
  8010f6:	48 ba 10 20 81 00 00 	movabs $0x812010,%rdx
  8010fd:	00 00 00 
  801100:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  801103:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  80110a:	00 00 00 
  80110d:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  80110f:	bf 02 00 00 00       	mov    $0x2,%edi
  801114:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80111b:	00 00 00 
  80111e:	ff d0                	callq  *%rax
  801120:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  801127:	00 00 00 
  80112a:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  80112d:	48 b8 72 0f 80 00 00 	movabs $0x800f72,%rax
  801134:	00 00 00 
  801137:	ff d0                	callq  *%rax
}
  801139:	5d                   	pop    %rbp
  80113a:	c3                   	retq   

000000000080113b <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 30          	sub    $0x30,%rsp
  801143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801147:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80114a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80114e:	89 c8                	mov    %ecx,%eax
  801150:	88 45 e0             	mov    %al,-0x20(%rbp)
        // LAB 5: Your code here.
				int x;

				if (filebno >= NDIRECT + NINDIRECT)
  801153:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  80115a:	76 0a                	jbe    801166 <file_block_walk+0x2b>
					return -E_INVAL;
  80115c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801161:	e9 21 01 00 00       	jmpq   801287 <file_block_walk+0x14c>

				if (filebno < NDIRECT) {
  801166:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  80116a:	77 32                	ja     80119e <file_block_walk+0x63>
					if (ppdiskbno)
  80116c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801171:	74 21                	je     801194 <file_block_walk+0x59>
				 		*ppdiskbno = f->f_direct + filebno;
  801173:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801176:	48 83 c0 20          	add    $0x20,%rax
  80117a:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  801181:	00 
  801182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801186:	48 01 d0             	add    %rdx,%rax
  801189:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80118d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801191:	48 89 10             	mov    %rdx,(%rax)
					return 0;
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
  801199:	e9 e9 00 00 00       	jmpq   801287 <file_block_walk+0x14c>
				}

				if (!f->f_indirect && !alloc)
  80119e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a2:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	75 15                	jne    8011c1 <file_block_walk+0x86>
  8011ac:	0f b6 45 e0          	movzbl -0x20(%rbp),%eax
  8011b0:	83 f0 01             	xor    $0x1,%eax
  8011b3:	84 c0                	test   %al,%al
  8011b5:	74 0a                	je     8011c1 <file_block_walk+0x86>
					return -E_NOT_FOUND;
  8011b7:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8011bc:	e9 c6 00 00 00       	jmpq   801287 <file_block_walk+0x14c>

				if (!f->f_indirect) {
  8011c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c5:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	75 7c                	jne    80124b <file_block_walk+0x110>
					if ((x = alloc_block()) < 0)
  8011cf:	48 b8 8a 0e 80 00 00 	movabs $0x800e8a,%rax
  8011d6:	00 00 00 
  8011d9:	ff d0                	callq  *%rax
  8011db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011e2:	79 0a                	jns    8011ee <file_block_walk+0xb3>
					  return -E_NO_DISK;
  8011e4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e9:	e9 99 00 00 00       	jmpq   801287 <file_block_walk+0x14c>
					f->f_indirect = x;
  8011ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f5:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
					memset(diskaddr(x), 0, BLKSIZE);
  8011fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011fe:	48 98                	cltq   
  801200:	48 89 c7             	mov    %rax,%rdi
  801203:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80120a:	00 00 00 
  80120d:	ff d0                	callq  *%rax
  80120f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801214:	be 00 00 00 00       	mov    $0x0,%esi
  801219:	48 89 c7             	mov    %rax,%rdi
  80121c:	48 b8 59 42 80 00 00 	movabs $0x804259,%rax
  801223:	00 00 00 
  801226:	ff d0                	callq  *%rax
					flush_block(diskaddr(x));
  801228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80122b:	48 98                	cltq   
  80122d:	48 89 c7             	mov    %rax,%rdi
  801230:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801237:	00 00 00 
  80123a:	ff d0                	callq  *%rax
  80123c:	48 89 c7             	mov    %rax,%rdi
  80123f:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801246:	00 00 00 
  801249:	ff d0                	callq  *%rax
				}

				if (ppdiskbno)
  80124b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801250:	74 30                	je     801282 <file_block_walk+0x147>
					*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  801252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801256:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80125c:	89 c0                	mov    %eax,%eax
  80125e:	48 89 c7             	mov    %rax,%rdi
  801261:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801268:	00 00 00 
  80126b:	ff d0                	callq  *%rax
  80126d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801270:	48 c1 e2 02          	shl    $0x2,%rdx
  801274:	48 83 ea 28          	sub    $0x28,%rdx
  801278:	48 01 c2             	add    %rax,%rdx
  80127b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127f:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
        //panic("file_block_walk not implemented");
}
  801287:	c9                   	leaveq 
  801288:	c3                   	retq   

0000000000801289 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801289:	55                   	push   %rbp
  80128a:	48 89 e5             	mov    %rsp,%rbp
  80128d:	48 83 ec 30          	sub    $0x30,%rsp
  801291:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801295:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801298:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 5: Your code here.
	int x;
	uint32_t *pdiskno;

	if ((x = file_block_walk(f, filebno, &pdiskno, 1)) < 0)
  80129c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8012a0:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8012a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a7:	b9 01 00 00 00       	mov    $0x1,%ecx
  8012ac:	48 89 c7             	mov    %rax,%rdi
  8012af:	48 b8 3b 11 80 00 00 	movabs $0x80113b,%rax
  8012b6:	00 00 00 
  8012b9:	ff d0                	callq  *%rax
  8012bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012c2:	79 08                	jns    8012cc <file_get_block+0x43>
	    return x;
  8012c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012c7:	e9 a2 00 00 00       	jmpq   80136e <file_get_block+0xe5>

	if (*pdiskno == 0) {
  8012cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d0:	8b 00                	mov    (%rax),%eax
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 75                	jne    80134b <file_get_block+0xc2>
	    if ((x = alloc_block()) < 0)
  8012d6:	48 b8 8a 0e 80 00 00 	movabs $0x800e8a,%rax
  8012dd:	00 00 00 
  8012e0:	ff d0                	callq  *%rax
  8012e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e9:	79 07                	jns    8012f2 <file_get_block+0x69>
	        return -E_NO_DISK;
  8012eb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012f0:	eb 7c                	jmp    80136e <file_get_block+0xe5>
	    *pdiskno = x;
  8012f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8012f9:	89 10                	mov    %edx,(%rax)
		memset(diskaddr(x), 0, BLKSIZE);
  8012fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012fe:	48 98                	cltq   
  801300:	48 89 c7             	mov    %rax,%rdi
  801303:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80130a:	00 00 00 
  80130d:	ff d0                	callq  *%rax
  80130f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801314:	be 00 00 00 00       	mov    $0x0,%esi
  801319:	48 89 c7             	mov    %rax,%rdi
  80131c:	48 b8 59 42 80 00 00 	movabs $0x804259,%rax
  801323:	00 00 00 
  801326:	ff d0                	callq  *%rax
		flush_block(diskaddr(x));
  801328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80132b:	48 98                	cltq   
  80132d:	48 89 c7             	mov    %rax,%rdi
  801330:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
  80133c:	48 89 c7             	mov    %rax,%rdi
  80133f:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801346:	00 00 00 
  801349:	ff d0                	callq  *%rax
	}

	*blk = diskaddr(*pdiskno);
  80134b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134f:	8b 00                	mov    (%rax),%eax
  801351:	89 c0                	mov    %eax,%eax
  801353:	48 89 c7             	mov    %rax,%rdi
  801356:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80135d:	00 00 00 
  801360:	ff d0                	callq  *%rax
  801362:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801366:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("file_block_walk not implemented");
}
  80136e:	c9                   	leaveq 
  80136f:	c3                   	retq   

0000000000801370 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801370:	55                   	push   %rbp
  801371:	48 89 e5             	mov    %rsp,%rbp
  801374:	48 83 ec 40          	sub    $0x40,%rsp
  801378:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80137c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801380:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  801384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801388:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80138e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801393:	85 c0                	test   %eax,%eax
  801395:	74 35                	je     8013cc <dir_lookup+0x5c>
  801397:	48 b9 e3 6a 80 00 00 	movabs $0x806ae3,%rcx
  80139e:	00 00 00 
  8013a1:	48 ba 9a 6a 80 00 00 	movabs $0x806a9a,%rdx
  8013a8:	00 00 00 
  8013ab:	be e0 00 00 00       	mov    $0xe0,%esi
  8013b0:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  8013b7:	00 00 00 
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bf:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8013c6:	00 00 00 
  8013c9:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8013cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d0:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013d6:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	0f 48 c2             	cmovs  %edx,%eax
  8013e1:	c1 f8 0c             	sar    $0xc,%eax
  8013e4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  8013e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013ee:	e9 93 00 00 00       	jmpq   801486 <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8013f3:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8013f7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8013fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fe:	89 ce                	mov    %ecx,%esi
  801400:	48 89 c7             	mov    %rax,%rdi
  801403:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  80140a:	00 00 00 
  80140d:	ff d0                	callq  *%rax
  80140f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801412:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801416:	79 05                	jns    80141d <dir_lookup+0xad>
			return r;
  801418:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80141b:	eb 7a                	jmp    801497 <dir_lookup+0x127>
		f = (struct File*) blk;
  80141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801421:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801425:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80142c:	eb 4e                	jmp    80147c <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  80142e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801431:	48 c1 e0 08          	shl    $0x8,%rax
  801435:	48 89 c2             	mov    %rax,%rdx
  801438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143c:	48 01 d0             	add    %rdx,%rax
  80143f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801443:	48 89 d6             	mov    %rdx,%rsi
  801446:	48 89 c7             	mov    %rax,%rdi
  801449:	48 b8 22 41 80 00 00 	movabs $0x804122,%rax
  801450:	00 00 00 
  801453:	ff d0                	callq  *%rax
  801455:	85 c0                	test   %eax,%eax
  801457:	75 1f                	jne    801478 <dir_lookup+0x108>
				*file = &f[j];
  801459:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80145c:	48 c1 e0 08          	shl    $0x8,%rax
  801460:	48 89 c2             	mov    %rax,%rdx
  801463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801467:	48 01 c2             	add    %rax,%rdx
  80146a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80146e:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801471:	b8 00 00 00 00       	mov    $0x0,%eax
  801476:	eb 1f                	jmp    801497 <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801478:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80147c:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801480:	76 ac                	jbe    80142e <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801482:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801489:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80148c:	0f 82 61 ff ff ff    	jb     8013f3 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  801492:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  801497:	c9                   	leaveq 
  801498:	c3                   	retq   

0000000000801499 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  801499:	55                   	push   %rbp
  80149a:	48 89 e5             	mov    %rsp,%rbp
  80149d:	48 83 ec 30          	sub    $0x30,%rsp
  8014a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8014b3:	25 ff 0f 00 00       	and    $0xfff,%eax
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	74 35                	je     8014f1 <dir_alloc_file+0x58>
  8014bc:	48 b9 e3 6a 80 00 00 	movabs $0x806ae3,%rcx
  8014c3:	00 00 00 
  8014c6:	48 ba 9a 6a 80 00 00 	movabs $0x806a9a,%rdx
  8014cd:	00 00 00 
  8014d0:	be f9 00 00 00       	mov    $0xf9,%esi
  8014d5:	48 bf 36 6a 80 00 00 	movabs $0x806a36,%rdi
  8014dc:	00 00 00 
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e4:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8014eb:	00 00 00 
  8014ee:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8014fb:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801501:	85 c0                	test   %eax,%eax
  801503:	0f 48 c2             	cmovs  %edx,%eax
  801506:	c1 f8 0c             	sar    $0xc,%eax
  801509:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80150c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801513:	e9 83 00 00 00       	jmpq   80159b <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801518:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80151c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	89 ce                	mov    %ecx,%esi
  801525:	48 89 c7             	mov    %rax,%rdi
  801528:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  80152f:	00 00 00 
  801532:	ff d0                	callq  *%rax
  801534:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801537:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80153b:	79 08                	jns    801545 <dir_alloc_file+0xac>
			return r;
  80153d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801540:	e9 be 00 00 00       	jmpq   801603 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  801545:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801549:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80154d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801554:	eb 3b                	jmp    801591 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  801556:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801559:	48 c1 e0 08          	shl    $0x8,%rax
  80155d:	48 89 c2             	mov    %rax,%rdx
  801560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801564:	48 01 d0             	add    %rdx,%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	84 c0                	test   %al,%al
  80156c:	75 1f                	jne    80158d <dir_alloc_file+0xf4>
				*file = &f[j];
  80156e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801571:	48 c1 e0 08          	shl    $0x8,%rax
  801575:	48 89 c2             	mov    %rax,%rdx
  801578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157c:	48 01 c2             	add    %rax,%rdx
  80157f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801583:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801586:	b8 00 00 00 00       	mov    $0x0,%eax
  80158b:	eb 76                	jmp    801603 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80158d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801591:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801595:	76 bf                	jbe    801556 <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801597:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80159b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80159e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8015a1:	0f 82 71 ff ff ff    	jb     801518 <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8015a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ab:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8015b1:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  8015b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8015c1:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8015c5:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8015c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cc:	89 ce                	mov    %ecx,%esi
  8015ce:	48 89 c7             	mov    %rax,%rdi
  8015d1:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  8015d8:	00 00 00 
  8015db:	ff d0                	callq  *%rax
  8015dd:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8015e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8015e4:	79 05                	jns    8015eb <dir_alloc_file+0x152>
		return r;
  8015e6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015e9:	eb 18                	jmp    801603 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  8015eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  8015f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801603:	c9                   	leaveq 
  801604:	c3                   	retq   

0000000000801605 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	48 83 ec 08          	sub    $0x8,%rsp
  80160d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801611:	eb 05                	jmp    801618 <skip_slash+0x13>
		p++;
  801613:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  801618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161c:	0f b6 00             	movzbl (%rax),%eax
  80161f:	3c 2f                	cmp    $0x2f,%al
  801621:	74 f0                	je     801613 <skip_slash+0xe>
		p++;
	return p;
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801627:	c9                   	leaveq 
  801628:	c3                   	retq   

0000000000801629 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  801629:	55                   	push   %rbp
  80162a:	48 89 e5             	mov    %rsp,%rbp
  80162d:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801634:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  80163b:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  801642:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  801649:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  801650:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801657:	48 89 c7             	mov    %rax,%rdi
  80165a:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801661:	00 00 00 
  801664:	ff d0                	callq  *%rax
  801666:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  80166d:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  801674:	00 00 00 
  801677:	48 8b 00             	mov    (%rax),%rax
  80167a:	48 83 c0 08          	add    $0x8,%rax
  80167e:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  801685:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80168c:	00 
	name[0] = 0;
  80168d:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  801694:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80169b:	00 
  80169c:	74 0e                	je     8016ac <walk_path+0x83>
		*pdir = 0;
  80169e:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8016a5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  8016ac:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8016b3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  8016ba:	e9 73 01 00 00       	jmpq   801832 <walk_path+0x209>
		dir = f;
  8016bf:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8016c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  8016ca:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  8016d5:	eb 08                	jmp    8016df <walk_path+0xb6>
			path++;
  8016d7:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  8016de:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  8016df:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	3c 2f                	cmp    $0x2f,%al
  8016eb:	74 0e                	je     8016fb <walk_path+0xd2>
  8016ed:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016f4:	0f b6 00             	movzbl (%rax),%eax
  8016f7:	84 c0                	test   %al,%al
  8016f9:	75 dc                	jne    8016d7 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  8016fb:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801706:	48 29 c2             	sub    %rax,%rdx
  801709:	48 89 d0             	mov    %rdx,%rax
  80170c:	48 83 f8 7f          	cmp    $0x7f,%rax
  801710:	7e 0a                	jle    80171c <walk_path+0xf3>
			return -E_BAD_PATH;
  801712:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801717:	e9 56 01 00 00       	jmpq   801872 <walk_path+0x249>
		memmove(name, p, path - p);
  80171c:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801727:	48 29 c2             	sub    %rax,%rdx
  80172a:	48 89 d0             	mov    %rdx,%rax
  80172d:	48 89 c2             	mov    %rax,%rdx
  801730:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801734:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  80173b:	48 89 ce             	mov    %rcx,%rsi
  80173e:	48 89 c7             	mov    %rax,%rdi
  801741:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  801748:	00 00 00 
  80174b:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  80174d:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801758:	48 29 c2             	sub    %rax,%rdx
  80175b:	48 89 d0             	mov    %rdx,%rax
  80175e:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801765:	00 
		path = skip_slash(path);
  801766:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80176d:	48 89 c7             	mov    %rax,%rdi
  801770:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801777:	00 00 00 
  80177a:	ff d0                	callq  *%rax
  80177c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  801783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801787:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80178d:	83 f8 01             	cmp    $0x1,%eax
  801790:	74 0a                	je     80179c <walk_path+0x173>
			return -E_NOT_FOUND;
  801792:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801797:	e9 d6 00 00 00       	jmpq   801872 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  80179c:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8017a3:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  8017aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ae:	48 89 ce             	mov    %rcx,%rsi
  8017b1:	48 89 c7             	mov    %rax,%rdi
  8017b4:	48 b8 70 13 80 00 00 	movabs $0x801370,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	callq  *%rax
  8017c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8017c7:	79 69                	jns    801832 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  8017c9:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  8017cd:	75 5e                	jne    80182d <walk_path+0x204>
  8017cf:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8017d6:	0f b6 00             	movzbl (%rax),%eax
  8017d9:	84 c0                	test   %al,%al
  8017db:	75 50                	jne    80182d <walk_path+0x204>
				if (pdir)
  8017dd:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8017e4:	00 
  8017e5:	74 0e                	je     8017f5 <walk_path+0x1cc>
					*pdir = dir;
  8017e7:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8017ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f2:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  8017f5:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  8017fc:	00 
  8017fd:	74 20                	je     80181f <walk_path+0x1f6>
					strcpy(lastelem, name);
  8017ff:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801806:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  80180d:	48 89 d6             	mov    %rdx,%rsi
  801810:	48 89 c7             	mov    %rax,%rdi
  801813:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  80181a:	00 00 00 
  80181d:	ff d0                	callq  *%rax
				*pf = 0;
  80181f:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801826:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  80182d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801830:	eb 40                	jmp    801872 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  801832:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	84 c0                	test   %al,%al
  80183e:	0f 85 7b fe ff ff    	jne    8016bf <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  801844:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80184b:	00 
  80184c:	74 0e                	je     80185c <walk_path+0x233>
		*pdir = dir;
  80184e:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801855:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801859:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  80185c:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801863:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80186a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80186d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801872:	c9                   	leaveq 
  801873:	c3                   	retq   

0000000000801874 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80187f:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801886:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  80188d:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801894:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80189b:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  8018a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8018a9:	48 89 c7             	mov    %rax,%rdi
  8018ac:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018b3:	00 00 00 
  8018b6:	ff d0                	callq  *%rax
  8018b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018bf:	75 0a                	jne    8018cb <file_create+0x57>
		return -E_FILE_EXISTS;
  8018c1:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8018c6:	e9 91 00 00 00       	jmpq   80195c <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  8018cb:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  8018cf:	75 0c                	jne    8018dd <file_create+0x69>
  8018d1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8018d8:	48 85 c0             	test   %rax,%rax
  8018db:	75 05                	jne    8018e2 <file_create+0x6e>
		return r;
  8018dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e0:	eb 7a                	jmp    80195c <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  8018e2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8018e9:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8018f0:	48 89 d6             	mov    %rdx,%rsi
  8018f3:	48 89 c7             	mov    %rax,%rdi
  8018f6:	48 b8 99 14 80 00 00 	movabs $0x801499,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
  801902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801909:	79 05                	jns    801910 <file_create+0x9c>
		return r;
  80190b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190e:	eb 4c                	jmp    80195c <file_create+0xe8>
	strcpy(f->f_name, name);
  801910:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801917:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  80191e:	48 89 d6             	mov    %rdx,%rsi
  801921:	48 89 c7             	mov    %rax,%rdi
  801924:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  80192b:	00 00 00 
  80192e:	ff d0                	callq  *%rax
	*pf = f;
  801930:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801937:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80193e:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  801941:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801948:	48 89 c7             	mov    %rax,%rdi
  80194b:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
	return 0;
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195c:	c9                   	leaveq 
  80195d:	c3                   	retq   

000000000080195e <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 10          	sub    $0x10,%rsp
  801966:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  80196e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801976:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197b:	be 00 00 00 00       	mov    $0x0,%esi
  801980:	48 89 c7             	mov    %rax,%rdi
  801983:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  80198a:	00 00 00 
  80198d:	ff d0                	callq  *%rax
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 60          	sub    $0x60,%rsp
  801999:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  80199d:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8019a1:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8019a5:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8019a8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8019ac:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8019b2:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  8019b5:	7f 0a                	jg     8019c1 <file_read+0x30>
		return 0;
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bc:	e9 24 01 00 00       	jmpq   801ae5 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  8019c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8019c9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8019cd:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8019d3:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  8019d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019dc:	48 63 d0             	movslq %eax,%rdx
  8019df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e3:	48 39 c2             	cmp    %rax,%rdx
  8019e6:	48 0f 46 c2          	cmovbe %rdx,%rax
  8019ea:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  8019ee:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8019f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f4:	e9 cd 00 00 00       	jmpq   801ac6 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8019f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fc:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a02:	85 c0                	test   %eax,%eax
  801a04:	0f 48 c2             	cmovs  %edx,%eax
  801a07:	c1 f8 0c             	sar    $0xc,%eax
  801a0a:	89 c1                	mov    %eax,%ecx
  801a0c:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801a10:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a14:	89 ce                	mov    %ecx,%esi
  801a16:	48 89 c7             	mov    %rax,%rdi
  801a19:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
  801a25:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801a28:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801a2c:	79 08                	jns    801a36 <file_read+0xa5>
			return r;
  801a2e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801a31:	e9 af 00 00 00       	jmpq   801ae5 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a39:	99                   	cltd   
  801a3a:	c1 ea 14             	shr    $0x14,%edx
  801a3d:	01 d0                	add    %edx,%eax
  801a3f:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a44:	29 d0                	sub    %edx,%eax
  801a46:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a4b:	29 c2                	sub    %eax,%edx
  801a4d:	89 d0                	mov    %edx,%eax
  801a4f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801a52:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801a55:	48 63 d0             	movslq %eax,%rdx
  801a58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a5c:	48 01 c2             	add    %rax,%rdx
  801a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a62:	48 98                	cltq   
  801a64:	48 29 c2             	sub    %rax,%rdx
  801a67:	48 89 d0             	mov    %rdx,%rax
  801a6a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801a6e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a71:	48 63 d0             	movslq %eax,%rdx
  801a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a78:	48 39 c2             	cmp    %rax,%rdx
  801a7b:	48 0f 46 c2          	cmovbe %rdx,%rax
  801a7f:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  801a82:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a85:	48 63 c8             	movslq %eax,%rcx
  801a88:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8f:	99                   	cltd   
  801a90:	c1 ea 14             	shr    $0x14,%edx
  801a93:	01 d0                	add    %edx,%eax
  801a95:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a9a:	29 d0                	sub    %edx,%eax
  801a9c:	48 98                	cltq   
  801a9e:	48 01 c6             	add    %rax,%rsi
  801aa1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801aa5:	48 89 ca             	mov    %rcx,%rdx
  801aa8:	48 89 c7             	mov    %rax,%rdi
  801aab:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	callq  *%rax
		pos += bn;
  801ab7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801aba:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801abd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801ac0:	48 98                	cltq   
  801ac2:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac9:	48 98                	cltq   
  801acb:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801ace:	48 63 ca             	movslq %edx,%rcx
  801ad1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801ad5:	48 01 ca             	add    %rcx,%rdx
  801ad8:	48 39 d0             	cmp    %rdx,%rax
  801adb:	0f 82 18 ff ff ff    	jb     8019f9 <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801ae1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801ae5:	c9                   	leaveq 
  801ae6:	c3                   	retq   

0000000000801ae7 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801ae7:	55                   	push   %rbp
  801ae8:	48 89 e5             	mov    %rsp,%rbp
  801aeb:	48 83 ec 50          	sub    $0x50,%rsp
  801aef:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801af3:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801af7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801afb:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801afe:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b01:	48 63 d0             	movslq %eax,%rdx
  801b04:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b08:	48 01 c2             	add    %rax,%rdx
  801b0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b0f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b15:	48 98                	cltq   
  801b17:	48 39 c2             	cmp    %rax,%rdx
  801b1a:	76 33                	jbe    801b4f <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801b1c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b20:	89 c2                	mov    %eax,%edx
  801b22:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b25:	01 d0                	add    %edx,%eax
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b2d:	89 d6                	mov    %edx,%esi
  801b2f:	48 89 c7             	mov    %rax,%rdi
  801b32:	48 b8 8d 1d 80 00 00 	movabs $0x801d8d,%rax
  801b39:	00 00 00 
  801b3c:	ff d0                	callq  *%rax
  801b3e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801b41:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801b45:	79 08                	jns    801b4f <file_write+0x68>
			return r;
  801b47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4a:	e9 f8 00 00 00       	jmpq   801c47 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801b4f:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b55:	e9 ce 00 00 00       	jmpq   801c28 <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801b63:	85 c0                	test   %eax,%eax
  801b65:	0f 48 c2             	cmovs  %edx,%eax
  801b68:	c1 f8 0c             	sar    $0xc,%eax
  801b6b:	89 c1                	mov    %eax,%ecx
  801b6d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801b71:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b75:	89 ce                	mov    %ecx,%esi
  801b77:	48 89 c7             	mov    %rax,%rdi
  801b7a:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  801b81:	00 00 00 
  801b84:	ff d0                	callq  *%rax
  801b86:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801b89:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801b8d:	79 08                	jns    801b97 <file_write+0xb0>
			return r;
  801b8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b92:	e9 b0 00 00 00       	jmpq   801c47 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9a:	99                   	cltd   
  801b9b:	c1 ea 14             	shr    $0x14,%edx
  801b9e:	01 d0                	add    %edx,%eax
  801ba0:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ba5:	29 d0                	sub    %edx,%eax
  801ba7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bac:	29 c2                	sub    %eax,%edx
  801bae:	89 d0                	mov    %edx,%eax
  801bb0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801bb3:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801bb6:	48 63 d0             	movslq %eax,%rdx
  801bb9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801bbd:	48 01 c2             	add    %rax,%rdx
  801bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc3:	48 98                	cltq   
  801bc5:	48 29 c2             	sub    %rax,%rdx
  801bc8:	48 89 d0             	mov    %rdx,%rax
  801bcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bcf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd2:	48 63 d0             	movslq %eax,%rdx
  801bd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd9:	48 39 c2             	cmp    %rax,%rdx
  801bdc:	48 0f 46 c2          	cmovbe %rdx,%rax
  801be0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801be3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801be6:	48 63 c8             	movslq %eax,%rcx
  801be9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801bed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf0:	99                   	cltd   
  801bf1:	c1 ea 14             	shr    $0x14,%edx
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bfb:	29 d0                	sub    %edx,%eax
  801bfd:	48 98                	cltq   
  801bff:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801c03:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c07:	48 89 ca             	mov    %rcx,%rdx
  801c0a:	48 89 c6             	mov    %rax,%rsi
  801c0d:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  801c14:	00 00 00 
  801c17:	ff d0                	callq  *%rax
		pos += bn;
  801c19:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c1c:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801c1f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c22:	48 98                	cltq   
  801c24:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2b:	48 98                	cltq   
  801c2d:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801c30:	48 63 ca             	movslq %edx,%rcx
  801c33:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801c37:	48 01 ca             	add    %rcx,%rdx
  801c3a:	48 39 d0             	cmp    %rdx,%rax
  801c3d:	0f 82 17 ff ff ff    	jb     801b5a <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801c43:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801c47:	c9                   	leaveq 
  801c48:	c3                   	retq   

0000000000801c49 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801c49:	55                   	push   %rbp
  801c4a:	48 89 e5             	mov    %rsp,%rbp
  801c4d:	48 83 ec 20          	sub    $0x20,%rsp
  801c51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c55:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801c58:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c5c:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c63:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c68:	48 89 c7             	mov    %rax,%rdi
  801c6b:	48 b8 3b 11 80 00 00 	movabs $0x80113b,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	callq  *%rax
  801c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c7e:	79 05                	jns    801c85 <file_free_block+0x3c>
		return r;
  801c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c83:	eb 2d                	jmp    801cb2 <file_free_block+0x69>
	if (*ptr) {
  801c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c89:	8b 00                	mov    (%rax),%eax
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	74 1e                	je     801cad <file_free_block+0x64>
		free_block(*ptr);
  801c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c93:	8b 00                	mov    (%rax),%eax
  801c95:	89 c7                	mov    %eax,%edi
  801c97:	48 b8 03 0e 80 00 00 	movabs $0x800e03,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
		*ptr = 0;
  801ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb2:	c9                   	leaveq 
  801cb3:	c3                   	retq   

0000000000801cb4 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801cb4:	55                   	push   %rbp
  801cb5:	48 89 e5             	mov    %rsp,%rbp
  801cb8:	48 83 ec 20          	sub    $0x20,%rsp
  801cbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cc0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc7:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801ccd:	05 ff 0f 00 00       	add    $0xfff,%eax
  801cd2:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	0f 48 c2             	cmovs  %edx,%eax
  801cdd:	c1 f8 0c             	sar    $0xc,%eax
  801ce0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801ce3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ce6:	05 ff 0f 00 00       	add    $0xfff,%eax
  801ceb:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	0f 48 c2             	cmovs  %edx,%eax
  801cf6:	c1 f8 0c             	sar    $0xc,%eax
  801cf9:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801cfc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d02:	eb 45                	jmp    801d49 <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801d04:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0b:	89 d6                	mov    %edx,%esi
  801d0d:	48 89 c7             	mov    %rax,%rdi
  801d10:	48 b8 49 1c 80 00 00 	movabs $0x801c49,%rax
  801d17:	00 00 00 
  801d1a:	ff d0                	callq  *%rax
  801d1c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801d1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d23:	79 20                	jns    801d45 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801d25:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d28:	89 c6                	mov    %eax,%esi
  801d2a:	48 bf 00 6b 80 00 00 	movabs $0x806b00,%rdi
  801d31:	00 00 00 
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  801d40:	00 00 00 
  801d43:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801d45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4c:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801d4f:	72 b3                	jb     801d04 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801d51:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801d55:	77 34                	ja     801d8b <file_truncate_blocks+0xd7>
  801d57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801d61:	85 c0                	test   %eax,%eax
  801d63:	74 26                	je     801d8b <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d69:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801d6f:	89 c7                	mov    %eax,%edi
  801d71:	48 b8 03 0e 80 00 00 	movabs $0x800e03,%rax
  801d78:	00 00 00 
  801d7b:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d81:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801d88:	00 00 00 
	}
}
  801d8b:	c9                   	leaveq 
  801d8c:	c3                   	retq   

0000000000801d8d <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801d8d:	55                   	push   %rbp
  801d8e:	48 89 e5             	mov    %rsp,%rbp
  801d91:	48 83 ec 10          	sub    $0x10,%rsp
  801d95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d99:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801d9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da0:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801da6:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801da9:	7e 18                	jle    801dc3 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801dab:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801dae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db2:	89 d6                	mov    %edx,%esi
  801db4:	48 89 c7             	mov    %rax,%rdi
  801db7:	48 b8 b4 1c 80 00 00 	movabs $0x801cb4,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801dc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801dca:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd4:	48 89 c7             	mov    %rax,%rdi
  801dd7:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	callq  *%rax
	return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	c9                   	leaveq 
  801de9:	c3                   	retq   

0000000000801dea <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	48 83 ec 20          	sub    $0x20,%rsp
  801df2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801df6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dfd:	eb 62                	jmp    801e61 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801dff:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0f:	48 89 c7             	mov    %rax,%rdi
  801e12:	48 b8 3b 11 80 00 00 	movabs $0x80113b,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	78 13                	js     801e35 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801e22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801e26:	48 85 c0             	test   %rax,%rax
  801e29:	74 0a                	je     801e35 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2f:	8b 00                	mov    (%rax),%eax
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 02                	jne    801e37 <file_flush+0x4d>
			continue;
  801e35:	eb 26                	jmp    801e5d <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3b:	8b 00                	mov    (%rax),%eax
  801e3d:	89 c0                	mov    %eax,%eax
  801e3f:	48 89 c7             	mov    %rax,%rdi
  801e42:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	callq  *%rax
  801e4e:	48 89 c7             	mov    %rax,%rdi
  801e51:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801e5d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e65:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801e6b:	05 ff 0f 00 00       	add    $0xfff,%eax
  801e70:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801e76:	85 c0                	test   %eax,%eax
  801e78:	0f 48 c2             	cmovs  %edx,%eax
  801e7b:	c1 f8 0c             	sar    $0xc,%eax
  801e7e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801e81:	0f 8f 78 ff ff ff    	jg     801dff <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8b:	48 89 c7             	mov    %rax,%rdi
  801e8e:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9e:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	74 2a                	je     801ed2 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eac:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801eb2:	89 c0                	mov    %eax,%eax
  801eb4:	48 89 c7             	mov    %rax,%rdi
  801eb7:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
  801ec3:	48 89 c7             	mov    %rax,%rdi
  801ec6:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801ecd:	00 00 00 
  801ed0:	ff d0                	callq  *%rax
}
  801ed2:	c9                   	leaveq 
  801ed3:	c3                   	retq   

0000000000801ed4 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801ed4:	55                   	push   %rbp
  801ed5:	48 89 e5             	mov    %rsp,%rbp
  801ed8:	48 83 ec 20          	sub    $0x20,%rsp
  801edc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801ee0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eed:	be 00 00 00 00       	mov    $0x0,%esi
  801ef2:	48 89 c7             	mov    %rax,%rdi
  801ef5:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	callq  *%rax
  801f01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f08:	79 05                	jns    801f0f <file_remove+0x3b>
		return r;
  801f0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0d:	eb 45                	jmp    801f54 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f13:	be 00 00 00 00       	mov    $0x0,%esi
  801f18:	48 89 c7             	mov    %rax,%rdi
  801f1b:	48 b8 b4 1c 80 00 00 	movabs $0x801cb4,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2b:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f32:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801f39:	00 00 00 
	flush_block(f);
  801f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f40:	48 89 c7             	mov    %rax,%rdi
  801f43:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	callq  *%rax

	return 0;
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f54:	c9                   	leaveq 
  801f55:	c3                   	retq   

0000000000801f56 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801f56:	55                   	push   %rbp
  801f57:	48 89 e5             	mov    %rsp,%rbp
  801f5a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801f5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801f65:	eb 27                	jmp    801f8e <fs_sync+0x38>
		flush_block(diskaddr(i));
  801f67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6a:	48 98                	cltq   
  801f6c:	48 89 c7             	mov    %rax,%rdi
  801f6f:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	callq  *%rax
  801f7b:	48 89 c7             	mov    %rax,%rdi
  801f7e:	48 b8 72 08 80 00 00 	movabs $0x800872,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801f8a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f91:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  801f98:	00 00 00 
  801f9b:	48 8b 00             	mov    (%rax),%rax
  801f9e:	8b 40 04             	mov    0x4(%rax),%eax
  801fa1:	39 c2                	cmp    %eax,%edx
  801fa3:	72 c2                	jb     801f67 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801faf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801fb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801fb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fbf:	eb 4b                	jmp    80200c <serve_init+0x65>
		opentab[i].o_fileid = i;
  801fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc4:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801fcb:	00 00 00 
  801fce:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801fd1:	48 63 c9             	movslq %ecx,%rcx
  801fd4:	48 c1 e1 05          	shl    $0x5,%rcx
  801fd8:	48 01 ca             	add    %rcx,%rdx
  801fdb:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe1:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801fe8:	00 00 00 
  801feb:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801fee:	48 63 c9             	movslq %ecx,%rcx
  801ff1:	48 c1 e1 05          	shl    $0x5,%rcx
  801ff5:	48 01 ca             	add    %rcx,%rdx
  801ff8:	48 83 c2 10          	add    $0x10,%rdx
  801ffc:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  802000:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  802007:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  802008:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80200c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802013:	7e ac                	jle    801fc1 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 20          	sub    $0x20,%rsp
  80201f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80202a:	e9 24 01 00 00       	jmpq   802153 <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  80202f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802036:	00 00 00 
  802039:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203c:	48 63 d2             	movslq %edx,%rdx
  80203f:	48 c1 e2 05          	shl    $0x5,%rdx
  802043:	48 01 d0             	add    %rdx,%rax
  802046:	48 83 c0 10          	add    $0x10,%rax
  80204a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80204e:	48 89 c7             	mov    %rax,%rdi
  802051:	48 b8 ca 5e 80 00 00 	movabs $0x805eca,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 0a                	je     80206b <openfile_alloc+0x54>
  802061:	83 f8 01             	cmp    $0x1,%eax
  802064:	74 4e                	je     8020b4 <openfile_alloc+0x9d>
  802066:	e9 e4 00 00 00       	jmpq   80214f <openfile_alloc+0x138>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  80206b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802072:	00 00 00 
  802075:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802078:	48 63 d2             	movslq %edx,%rdx
  80207b:	48 c1 e2 05          	shl    $0x5,%rdx
  80207f:	48 01 d0             	add    %rdx,%rax
  802082:	48 83 c0 10          	add    $0x10,%rax
  802086:	48 8b 40 08          	mov    0x8(%rax),%rax
  80208a:	ba 07 00 00 00       	mov    $0x7,%edx
  80208f:	48 89 c6             	mov    %rax,%rsi
  802092:	bf 00 00 00 00       	mov    $0x0,%edi
  802097:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
  8020a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020aa:	79 08                	jns    8020b4 <openfile_alloc+0x9d>
				return r;
  8020ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020af:	e9 b1 00 00 00       	jmpq   802165 <openfile_alloc+0x14e>
			/* fall through */
		case 1:

			opentab[i].o_fileid += MAXOPEN;
  8020b4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020bb:	00 00 00 
  8020be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c1:	48 63 d2             	movslq %edx,%rdx
  8020c4:	48 c1 e2 05          	shl    $0x5,%rdx
  8020c8:	48 01 d0             	add    %rdx,%rax
  8020cb:	8b 00                	mov    (%rax),%eax
  8020cd:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  8020d3:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020da:	00 00 00 
  8020dd:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020e0:	48 63 c9             	movslq %ecx,%rcx
  8020e3:	48 c1 e1 05          	shl    $0x5,%rcx
  8020e7:	48 01 c8             	add    %rcx,%rax
  8020ea:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  8020ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ef:	48 98                	cltq   
  8020f1:	48 c1 e0 05          	shl    $0x5,%rax
  8020f5:	48 89 c2             	mov    %rax,%rdx
  8020f8:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020ff:	00 00 00 
  802102:	48 01 c2             	add    %rax,%rdx
  802105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802109:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80210c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802113:	00 00 00 
  802116:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802119:	48 63 d2             	movslq %edx,%rdx
  80211c:	48 c1 e2 05          	shl    $0x5,%rdx
  802120:	48 01 d0             	add    %rdx,%rax
  802123:	48 83 c0 10          	add    $0x10,%rax
  802127:	48 8b 40 08          	mov    0x8(%rax),%rax
  80212b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802130:	be 00 00 00 00       	mov    $0x0,%esi
  802135:	48 89 c7             	mov    %rax,%rdi
  802138:	48 b8 59 42 80 00 00 	movabs $0x804259,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  802144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802148:	48 8b 00             	mov    (%rax),%rax
  80214b:	8b 00                	mov    (%rax),%eax
  80214d:	eb 16                	jmp    802165 <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  80214f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802153:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80215a:	0f 8e cf fe ff ff    	jle    80202f <openfile_alloc+0x18>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
	         }
        }
	return -E_MAX_OPEN;
  802160:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802165:	c9                   	leaveq 
  802166:	c3                   	retq   

0000000000802167 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  802167:	55                   	push   %rbp
  802168:	48 89 e5             	mov    %rsp,%rbp
  80216b:	48 83 ec 20          	sub    $0x20,%rsp
  80216f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802172:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802175:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  802179:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80217c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802181:	89 c0                	mov    %eax,%eax
  802183:	48 c1 e0 05          	shl    $0x5,%rax
  802187:	48 89 c2             	mov    %rax,%rdx
  80218a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802191:	00 00 00 
  802194:	48 01 d0             	add    %rdx,%rax
  802197:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80219b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021a3:	48 89 c7             	mov    %rax,%rdi
  8021a6:	48 b8 ca 5e 80 00 00 	movabs $0x805eca,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
  8021b2:	83 f8 01             	cmp    $0x1,%eax
  8021b5:	74 0b                	je     8021c2 <openfile_lookup+0x5b>
  8021b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bb:	8b 00                	mov    (%rax),%eax
  8021bd:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8021c0:	74 07                	je     8021c9 <openfile_lookup+0x62>
		return -E_INVAL;
  8021c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021c7:	eb 10                	jmp    8021d9 <openfile_lookup+0x72>
	*po = o;
  8021c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021d1:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d9:	c9                   	leaveq 
  8021da:	c3                   	retq   

00000000008021db <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  8021db:	55                   	push   %rbp
  8021dc:	48 89 e5             	mov    %rsp,%rbp
  8021df:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  8021e6:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  8021ec:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  8021f3:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  8021fa:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802201:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  802208:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80220f:	ba 00 04 00 00       	mov    $0x400,%edx
  802214:	48 89 ce             	mov    %rcx,%rsi
  802217:	48 89 c7             	mov    %rax,%rdi
  80221a:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  802221:	00 00 00 
  802224:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802226:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80222a:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802231:	48 89 c7             	mov    %rax,%rdi
  802234:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  80223b:	00 00 00 
  80223e:	ff d0                	callq  *%rax
  802240:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802243:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802247:	79 08                	jns    802251 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  802249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224c:	e9 7c 01 00 00       	jmpq   8023cd <serve_open+0x1f2>
	}
	fileid = r;
  802251:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802254:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  802257:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80225e:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802264:	25 00 01 00 00       	and    $0x100,%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	74 4f                	je     8022bc <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  80226d:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802274:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80227b:	48 89 d6             	mov    %rdx,%rsi
  80227e:	48 89 c7             	mov    %rax,%rdi
  802281:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax
  80228d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802294:	79 57                	jns    8022ed <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  802296:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80229d:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022a3:	25 00 04 00 00       	and    $0x400,%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	75 08                	jne    8022b4 <serve_open+0xd9>
  8022ac:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8022b0:	75 02                	jne    8022b4 <serve_open+0xd9>
				goto try_open;
  8022b2:	eb 08                	jmp    8022bc <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8022b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b7:	e9 11 01 00 00       	jmpq   8023cd <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8022bc:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8022c3:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8022ca:	48 89 d6             	mov    %rdx,%rsi
  8022cd:	48 89 c7             	mov    %rax,%rdi
  8022d0:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	callq  *%rax
  8022dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e3:	79 08                	jns    8022ed <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  8022e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e8:	e9 e0 00 00 00       	jmpq   8023cd <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8022ed:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8022f4:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022fa:	25 00 02 00 00       	and    $0x200,%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 2c                	je     80232f <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802303:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  80230a:	be 00 00 00 00       	mov    $0x0,%esi
  80230f:	48 89 c7             	mov    %rax,%rdi
  802312:	48 b8 8d 1d 80 00 00 	movabs $0x801d8d,%rax
  802319:	00 00 00 
  80231c:	ff d0                	callq  *%rax
  80231e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802325:	79 08                	jns    80232f <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  802327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232a:	e9 9e 00 00 00       	jmpq   8023cd <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  80232f:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802336:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  80233d:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802341:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802348:	48 8b 40 18          	mov    0x18(%rax),%rax
  80234c:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802353:	8b 12                	mov    (%rdx),%edx
  802355:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  802358:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80235f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802363:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  80236a:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802370:	83 e2 03             	and    $0x3,%edx
  802373:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  802376:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80237d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802381:	48 ba c0 10 81 00 00 	movabs $0x8110c0,%rdx
  802388:	00 00 00 
  80238b:	8b 12                	mov    (%rdx),%edx
  80238d:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  80238f:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802396:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  80239d:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8023a3:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8023a6:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023ad:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8023b1:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8023b8:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8023bb:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  8023c2:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cd:	c9                   	leaveq 
  8023ce:	c3                   	retq   

00000000008023cf <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8023cf:	55                   	push   %rbp
  8023d0:	48 89 e5             	mov    %rsp,%rbp
  8023d3:	48 83 ec 20          	sub    $0x20,%rsp
  8023d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8023de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e2:	8b 00                	mov    (%rax),%eax
  8023e4:	89 c1                	mov    %eax,%ecx
  8023e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ed:	89 ce                	mov    %ecx,%esi
  8023ef:	89 c7                	mov    %eax,%edi
  8023f1:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
  8023fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802400:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802404:	79 05                	jns    80240b <serve_set_size+0x3c>
		return r;
  802406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802409:	eb 20                	jmp    80242b <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80240b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240f:	8b 50 04             	mov    0x4(%rax),%edx
  802412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802416:	48 8b 40 08          	mov    0x8(%rax),%rax
  80241a:	89 d6                	mov    %edx,%esi
  80241c:	48 89 c7             	mov    %rax,%rdi
  80241f:	48 b8 8d 1d 80 00 00 	movabs $0x801d8d,%rax
  802426:	00 00 00 
  802429:	ff d0                	callq  *%rax
}
  80242b:	c9                   	leaveq 
  80242c:	c3                   	retq   

000000000080242d <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  80242d:	55                   	push   %rbp
  80242e:	48 89 e5             	mov    %rsp,%rbp
  802431:	48 83 ec 30          	sub    $0x30,%rsp
  802435:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802438:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_read *req = &ipc->read;
  80243c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802440:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  802444:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802448:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//
	// LAB 5: Your code here

	struct OpenFile *o;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80244c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802450:	8b 00                	mov    (%rax),%eax
  802452:	89 c1                	mov    %eax,%ecx
  802454:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802458:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80245b:	89 ce                	mov    %ecx,%esi
  80245d:	89 c7                	mov    %eax,%edi
  80245f:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802466:	00 00 00 
  802469:	ff d0                	callq  *%rax
  80246b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80246e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802472:	79 05                	jns    802479 <serve_read+0x4c>
		return r;
  802474:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802477:	eb 72                	jmp    8024eb <serve_read+0xbe>

	int req_n = req->req_n > PGSIZE ? PGSIZE : req->req_n;
  802479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802481:	ba 00 10 00 00       	mov    $0x1000,%edx
  802486:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  80248c:	48 0f 47 c2          	cmova  %rdx,%rax
  802490:	89 45 e8             	mov    %eax,-0x18(%rbp)
	if ((r = file_read(o->o_file, ret->ret_buf, req_n, o->o_fd->fd_offset)) < 0)
  802493:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802497:	48 8b 40 18          	mov    0x18(%rax),%rax
  80249b:	8b 48 04             	mov    0x4(%rax),%ecx
  80249e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8024a1:	48 63 d0             	movslq %eax,%rdx
  8024a4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8024a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ac:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024b0:	48 89 c7             	mov    %rax,%rdi
  8024b3:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8024ba:	00 00 00 
  8024bd:	ff d0                	callq  *%rax
  8024bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024c6:	79 05                	jns    8024cd <serve_read+0xa0>
		return r;
  8024c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024cb:	eb 1e                	jmp    8024eb <serve_read+0xbe>
	o->o_fd->fd_offset += r;
  8024cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024d9:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8024dd:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8024e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024e3:	01 ca                	add    %ecx,%edx
  8024e5:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  8024e8:	8b 45 ec             	mov    -0x14(%rbp),%eax

	//panic("serve_read not implemented");
}
  8024eb:	c9                   	leaveq 
  8024ec:	c3                   	retq   

00000000008024ed <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8024ed:	55                   	push   %rbp
  8024ee:	48 89 e5             	mov    %rsp,%rbp
  8024f1:	48 83 ec 20          	sub    $0x20,%rsp
  8024f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	// LAB 5: Your code here.

	struct OpenFile *o;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8024fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802500:	8b 00                	mov    (%rax),%eax
  802502:	89 c1                	mov    %eax,%ecx
  802504:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802508:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250b:	89 ce                	mov    %ecx,%esi
  80250d:	89 c7                	mov    %eax,%edi
  80250f:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802516:	00 00 00 
  802519:	ff d0                	callq  *%rax
  80251b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802522:	79 05                	jns    802529 <serve_write+0x3c>
		return r;
  802524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802527:	eb 76                	jmp    80259f <serve_write+0xb2>

	int req_n = req->req_n > PGSIZE ? PGSIZE : req->req_n;
  802529:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80252d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802531:	ba 00 10 00 00       	mov    $0x1000,%edx
  802536:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  80253c:	48 0f 47 c2          	cmova  %rdx,%rax
  802540:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if ((r = file_write(o->o_file, req->req_buf, req_n, o->o_fd->fd_offset)) < 0)
  802543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802547:	48 8b 40 18          	mov    0x18(%rax),%rax
  80254b:	8b 48 04             	mov    0x4(%rax),%ecx
  80254e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802551:	48 63 d0             	movslq %eax,%rdx
  802554:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802558:	48 8d 70 10          	lea    0x10(%rax),%rsi
  80255c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802560:	48 8b 40 08          	mov    0x8(%rax),%rax
  802564:	48 89 c7             	mov    %rax,%rdi
  802567:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  80256e:	00 00 00 
  802571:	ff d0                	callq  *%rax
  802573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257a:	79 05                	jns    802581 <serve_write+0x94>
		return r;
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	eb 1e                	jmp    80259f <serve_write+0xb2>
	o->o_fd->fd_offset += r;
  802581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802585:	48 8b 40 18          	mov    0x18(%rax),%rax
  802589:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80258d:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802591:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802594:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802597:	01 ca                	add    %ecx,%edx
  802599:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  80259c:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("serve_write not implemented");
}
  80259f:	c9                   	leaveq 
  8025a0:	c3                   	retq   

00000000008025a1 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8025a1:	55                   	push   %rbp
  8025a2:	48 89 e5             	mov    %rsp,%rbp
  8025a5:	48 83 ec 30          	sub    $0x30,%rsp
  8025a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  8025b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  8025b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8025c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c4:	8b 00                	mov    (%rax),%eax
  8025c6:	89 c1                	mov    %eax,%ecx
  8025c8:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8025cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025cf:	89 ce                	mov    %ecx,%esi
  8025d1:	89 c7                	mov    %eax,%edi
  8025d3:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8025da:	00 00 00 
  8025dd:	ff d0                	callq  *%rax
  8025df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8025e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025e6:	79 05                	jns    8025ed <serve_stat+0x4c>
		return r;
  8025e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025eb:	eb 5f                	jmp    80264c <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  8025ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025f5:	48 89 c2             	mov    %rax,%rdx
  8025f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fc:	48 89 d6             	mov    %rdx,%rsi
  8025ff:	48 89 c7             	mov    %rax,%rdi
  802602:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  802609:	00 00 00 
  80260c:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  80260e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802612:	48 8b 40 08          	mov    0x8(%rax),%rax
  802616:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80261c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802620:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  802626:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80262e:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802634:	83 f8 01             	cmp    $0x1,%eax
  802637:	0f 94 c0             	sete   %al
  80263a:	0f b6 d0             	movzbl %al,%edx
  80263d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802641:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264c:	c9                   	leaveq 
  80264d:	c3                   	retq   

000000000080264e <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  80264e:	55                   	push   %rbp
  80264f:	48 89 e5             	mov    %rsp,%rbp
  802652:	48 83 ec 20          	sub    $0x20,%rsp
  802656:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802659:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80265d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802661:	8b 00                	mov    (%rax),%eax
  802663:	89 c1                	mov    %eax,%ecx
  802665:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802669:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80266c:	89 ce                	mov    %ecx,%esi
  80266e:	89 c7                	mov    %eax,%edi
  802670:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802677:	00 00 00 
  80267a:	ff d0                	callq  *%rax
  80267c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802683:	79 05                	jns    80268a <serve_flush+0x3c>
		return r;
  802685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802688:	eb 1c                	jmp    8026a6 <serve_flush+0x58>
	file_flush(o->o_file);
  80268a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802692:	48 89 c7             	mov    %rax,%rdi
  802695:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  80269c:	00 00 00 
  80269f:	ff d0                	callq  *%rax
	return 0;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a6:	c9                   	leaveq 
  8026a7:	c3                   	retq   

00000000008026a8 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
  8026ac:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  8026b3:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  8026b9:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8026c0:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  8026c7:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8026ce:	ba 00 04 00 00       	mov    $0x400,%edx
  8026d3:	48 89 ce             	mov    %rcx,%rsi
  8026d6:	48 89 c7             	mov    %rax,%rdi
  8026d9:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8026e5:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  8026e9:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8026f0:	48 89 c7             	mov    %rax,%rdi
  8026f3:	48 b8 d4 1e 80 00 00 	movabs $0x801ed4,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	callq  *%rax
}
  8026ff:	c9                   	leaveq 
  802700:	c3                   	retq   

0000000000802701 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  802701:	55                   	push   %rbp
  802702:	48 89 e5             	mov    %rsp,%rbp
  802705:	48 83 ec 10          	sub    $0x10,%rsp
  802709:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80270c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802710:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
	return 0;
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802721:	c9                   	leaveq 
  802722:	c3                   	retq   

0000000000802723 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  802723:	55                   	push   %rbp
  802724:	48 89 e5             	mov    %rsp,%rbp
  802727:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  80272b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  802732:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802739:	00 00 00 
  80273c:	48 8b 08             	mov    (%rax),%rcx
  80273f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802743:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  802747:	48 89 ce             	mov    %rcx,%rsi
  80274a:	48 89 c7             	mov    %rax,%rdi
  80274d:	48 b8 a6 4c 80 00 00 	movabs $0x804ca6,%rax
  802754:	00 00 00 
  802757:	ff d0                	callq  *%rax
  802759:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  80275c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80275f:	83 e0 01             	and    $0x1,%eax
  802762:	85 c0                	test   %eax,%eax
  802764:	75 23                	jne    802789 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  802766:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802769:	89 c6                	mov    %eax,%esi
  80276b:	48 bf 20 6b 80 00 00 	movabs $0x806b20,%rdi
  802772:	00 00 00 
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
  80277a:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  802781:	00 00 00 
  802784:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  802786:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  802787:	eb a2                	jmp    80272b <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  802789:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802790:	00 
		if (req == FSREQ_OPEN) {
  802791:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  802795:	75 2b                	jne    8027c2 <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  802797:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  80279e:	00 00 00 
  8027a1:	48 8b 30             	mov    (%rax),%rsi
  8027a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027a7:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8027ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027af:	89 c7                	mov    %eax,%edi
  8027b1:	48 b8 db 21 80 00 00 	movabs $0x8021db,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	callq  *%rax
  8027bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c0:	eb 73                	jmp    802835 <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  8027c2:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  8027c6:	77 43                	ja     80280b <serve+0xe8>
  8027c8:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  8027cf:	00 00 00 
  8027d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8027d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027d9:	48 85 c0             	test   %rax,%rax
  8027dc:	74 2d                	je     80280b <serve+0xe8>
			r = handlers[req](whom, fsreq);
  8027de:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  8027e5:	00 00 00 
  8027e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8027eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ef:	48 ba 20 10 81 00 00 	movabs $0x811020,%rdx
  8027f6:	00 00 00 
  8027f9:	48 8b 0a             	mov    (%rdx),%rcx
  8027fc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027ff:	48 89 ce             	mov    %rcx,%rsi
  802802:	89 d7                	mov    %edx,%edi
  802804:	ff d0                	callq  *%rax
  802806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802809:	eb 2a                	jmp    802835 <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  80280b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80280e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802811:	89 c6                	mov    %eax,%esi
  802813:	48 bf 50 6b 80 00 00 	movabs $0x806b50,%rdi
  80281a:	00 00 00 
  80281d:	b8 00 00 00 00       	mov    $0x0,%eax
  802822:	48 b9 f8 33 80 00 00 	movabs $0x8033f8,%rcx
  802829:	00 00 00 
  80282c:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  80282e:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  802835:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  802838:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80283c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80283f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802842:	89 c7                	mov    %eax,%edi
  802844:	48 b8 67 4d 80 00 00 	movabs $0x804d67,%rax
  80284b:	00 00 00 
  80284e:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802850:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802857:	00 00 00 
  80285a:	48 8b 00             	mov    (%rax),%rax
  80285d:	48 89 c6             	mov    %rax,%rsi
  802860:	bf 00 00 00 00       	mov    $0x0,%edi
  802865:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  80286c:	00 00 00 
  80286f:	ff d0                	callq  *%rax
	}
  802871:	e9 b5 fe ff ff       	jmpq   80272b <serve+0x8>

0000000000802876 <umain>:
}

void
umain(int argc, char **argv)
{
  802876:	55                   	push   %rbp
  802877:	48 89 e5             	mov    %rsp,%rbp
  80287a:	48 83 ec 20          	sub    $0x20,%rsp
  80287e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802881:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  802885:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  80288c:	00 00 00 
  80288f:	48 b9 73 6b 80 00 00 	movabs $0x806b73,%rcx
  802896:	00 00 00 
  802899:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  80289c:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  8028a3:	00 00 00 
  8028a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ab:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  8028b2:	00 00 00 
  8028b5:	ff d2                	callq  *%rdx
  8028b7:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  8028be:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8028c4:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  8028c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028cb:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8028cd:	48 bf 85 6b 80 00 00 	movabs $0x806b85,%rdi
  8028d4:	00 00 00 
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028dc:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  8028e3:	00 00 00 
  8028e6:	ff d2                	callq  *%rdx

	serve_init();
  8028e8:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
	fs_init();
  8028f4:	48 b8 a1 10 80 00 00 	movabs $0x8010a1,%rax
  8028fb:	00 00 00 
  8028fe:	ff d0                	callq  *%rax
	fs_test();
  802900:	48 b8 1a 29 80 00 00 	movabs $0x80291a,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
	serve();
  80290c:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  802913:	00 00 00 
  802916:	ff d0                	callq  *%rax
}
  802918:	c9                   	leaveq 
  802919:	c3                   	retq   

000000000080291a <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  80291a:	55                   	push   %rbp
  80291b:	48 89 e5             	mov    %rsp,%rbp
  80291e:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802922:	ba 07 00 00 00       	mov    $0x7,%edx
  802927:	be 00 10 00 00       	mov    $0x1000,%esi
  80292c:	bf 00 00 00 00       	mov    $0x0,%edi
  802931:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
  80293d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802940:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802944:	79 30                	jns    802976 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802949:	89 c1                	mov    %eax,%ecx
  80294b:	48 ba be 6b 80 00 00 	movabs $0x806bbe,%rdx
  802952:	00 00 00 
  802955:	be 13 00 00 00       	mov    $0x13,%esi
  80295a:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802961:	00 00 00 
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
  802969:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802970:	00 00 00 
  802973:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802976:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  80297d:	00 
	memmove(bits, bitmap, PGSIZE);
  80297e:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802985:	00 00 00 
  802988:	48 8b 08             	mov    (%rax),%rcx
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802994:	48 89 ce             	mov    %rcx,%rsi
  802997:	48 89 c7             	mov    %rax,%rdi
  80299a:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  8029a6:	48 b8 8a 0e 80 00 00 	movabs $0x800e8a,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	callq  *%rax
  8029b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b9:	79 30                	jns    8029eb <fs_test+0xd1>
		panic("alloc_block: %e", r);
  8029bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029be:	89 c1                	mov    %eax,%ecx
  8029c0:	48 ba db 6b 80 00 00 	movabs $0x806bdb,%rdx
  8029c7:	00 00 00 
  8029ca:	be 18 00 00 00       	mov    $0x18,%esi
  8029cf:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  8029d6:	00 00 00 
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029de:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8029e5:	00 00 00 
  8029e8:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8029eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ee:	8d 50 1f             	lea    0x1f(%rax),%edx
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	0f 48 c2             	cmovs  %edx,%eax
  8029f6:	c1 f8 05             	sar    $0x5,%eax
  8029f9:	48 98                	cltq   
  8029fb:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802a02:	00 
  802a03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a07:	48 01 d0             	add    %rdx,%rax
  802a0a:	8b 30                	mov    (%rax),%esi
  802a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0f:	99                   	cltd   
  802a10:	c1 ea 1b             	shr    $0x1b,%edx
  802a13:	01 d0                	add    %edx,%eax
  802a15:	83 e0 1f             	and    $0x1f,%eax
  802a18:	29 d0                	sub    %edx,%eax
  802a1a:	ba 01 00 00 00       	mov    $0x1,%edx
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	d3 e2                	shl    %cl,%edx
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	21 f0                	and    %esi,%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	75 35                	jne    802a60 <fs_test+0x146>
  802a2b:	48 b9 eb 6b 80 00 00 	movabs $0x806beb,%rcx
  802a32:	00 00 00 
  802a35:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802a3c:	00 00 00 
  802a3f:	be 1a 00 00 00       	mov    $0x1a,%esi
  802a44:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802a4b:	00 00 00 
  802a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a53:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802a5a:	00 00 00 
  802a5d:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802a60:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802a67:	00 00 00 
  802a6a:	48 8b 10             	mov    (%rax),%rdx
  802a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a70:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802a73:	85 c0                	test   %eax,%eax
  802a75:	0f 48 c1             	cmovs  %ecx,%eax
  802a78:	c1 f8 05             	sar    $0x5,%eax
  802a7b:	48 98                	cltq   
  802a7d:	48 c1 e0 02          	shl    $0x2,%rax
  802a81:	48 01 d0             	add    %rdx,%rax
  802a84:	8b 30                	mov    (%rax),%esi
  802a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a89:	99                   	cltd   
  802a8a:	c1 ea 1b             	shr    $0x1b,%edx
  802a8d:	01 d0                	add    %edx,%eax
  802a8f:	83 e0 1f             	and    $0x1f,%eax
  802a92:	29 d0                	sub    %edx,%eax
  802a94:	ba 01 00 00 00       	mov    $0x1,%edx
  802a99:	89 c1                	mov    %eax,%ecx
  802a9b:	d3 e2                	shl    %cl,%edx
  802a9d:	89 d0                	mov    %edx,%eax
  802a9f:	21 f0                	and    %esi,%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 35                	je     802ada <fs_test+0x1c0>
  802aa5:	48 b9 20 6c 80 00 00 	movabs $0x806c20,%rcx
  802aac:	00 00 00 
  802aaf:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802ab6:	00 00 00 
  802ab9:	be 1c 00 00 00       	mov    $0x1c,%esi
  802abe:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802ac5:	00 00 00 
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802ad4:	00 00 00 
  802ad7:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802ada:	48 bf 40 6c 80 00 00 	movabs $0x806c40,%rdi
  802ae1:	00 00 00 
  802ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae9:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  802af0:	00 00 00 
  802af3:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802af5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802af9:	48 89 c6             	mov    %rax,%rsi
  802afc:	48 bf 55 6c 80 00 00 	movabs $0x806c55,%rdi
  802b03:	00 00 00 
  802b06:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802b0d:	00 00 00 
  802b10:	ff d0                	callq  *%rax
  802b12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b19:	79 36                	jns    802b51 <fs_test+0x237>
  802b1b:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802b1f:	74 30                	je     802b51 <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b24:	89 c1                	mov    %eax,%ecx
  802b26:	48 ba 60 6c 80 00 00 	movabs $0x806c60,%rdx
  802b2d:	00 00 00 
  802b30:	be 20 00 00 00       	mov    $0x20,%esi
  802b35:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802b3c:	00 00 00 
  802b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b44:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802b4b:	00 00 00 
  802b4e:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b55:	75 2a                	jne    802b81 <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802b57:	48 ba 80 6c 80 00 00 	movabs $0x806c80,%rdx
  802b5e:	00 00 00 
  802b61:	be 22 00 00 00       	mov    $0x22,%esi
  802b66:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802b6d:	00 00 00 
  802b70:	b8 00 00 00 00       	mov    $0x0,%eax
  802b75:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  802b7c:	00 00 00 
  802b7f:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802b81:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b85:	48 89 c6             	mov    %rax,%rsi
  802b88:	48 bf a0 6c 80 00 00 	movabs $0x806ca0,%rdi
  802b8f:	00 00 00 
  802b92:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba5:	79 30                	jns    802bd7 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802ba7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802baa:	89 c1                	mov    %eax,%ecx
  802bac:	48 ba a9 6c 80 00 00 	movabs $0x806ca9,%rdx
  802bb3:	00 00 00 
  802bb6:	be 24 00 00 00       	mov    $0x24,%esi
  802bbb:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802bc2:	00 00 00 
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bca:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802bd1:	00 00 00 
  802bd4:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802bd7:	48 bf c0 6c 80 00 00 	movabs $0x806cc0,%rdi
  802bde:	00 00 00 
  802be1:	b8 00 00 00 00       	mov    $0x0,%eax
  802be6:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  802bed:	00 00 00 
  802bf0:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf6:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802bfa:	be 00 00 00 00       	mov    $0x0,%esi
  802bff:	48 89 c7             	mov    %rax,%rdi
  802c02:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  802c09:	00 00 00 
  802c0c:	ff d0                	callq  *%rax
  802c0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c15:	79 30                	jns    802c47 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802c17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1a:	89 c1                	mov    %eax,%ecx
  802c1c:	48 ba d3 6c 80 00 00 	movabs $0x806cd3,%rdx
  802c23:	00 00 00 
  802c26:	be 28 00 00 00       	mov    $0x28,%esi
  802c2b:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802c32:	00 00 00 
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3a:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802c41:	00 00 00 
  802c44:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802c47:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802c4e:	00 00 00 
  802c51:	48 8b 10             	mov    (%rax),%rdx
  802c54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c58:	48 89 d6             	mov    %rdx,%rsi
  802c5b:	48 89 c7             	mov    %rax,%rdi
  802c5e:	48 b8 22 41 80 00 00 	movabs $0x804122,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	74 2a                	je     802c98 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802c6e:	48 ba e8 6c 80 00 00 	movabs $0x806ce8,%rdx
  802c75:	00 00 00 
  802c78:	be 2a 00 00 00       	mov    $0x2a,%esi
  802c7d:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802c84:	00 00 00 
  802c87:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8c:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  802c93:	00 00 00 
  802c96:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802c98:	48 bf 0b 6d 80 00 00 	movabs $0x806d0b,%rdi
  802c9f:	00 00 00 
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca7:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  802cae:	00 00 00 
  802cb1:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802cb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cbb:	0f b6 12             	movzbl (%rdx),%edx
  802cbe:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802cc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc4:	48 c1 e8 0c          	shr    $0xc,%rax
  802cc8:	48 89 c2             	mov    %rax,%rdx
  802ccb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cd2:	01 00 00 
  802cd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cd9:	83 e0 40             	and    $0x40,%eax
  802cdc:	48 85 c0             	test   %rax,%rax
  802cdf:	75 35                	jne    802d16 <fs_test+0x3fc>
  802ce1:	48 b9 23 6d 80 00 00 	movabs $0x806d23,%rcx
  802ce8:	00 00 00 
  802ceb:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802cf2:	00 00 00 
  802cf5:	be 2e 00 00 00       	mov    $0x2e,%esi
  802cfa:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802d01:	00 00 00 
  802d04:	b8 00 00 00 00       	mov    $0x0,%eax
  802d09:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802d10:	00 00 00 
  802d13:	41 ff d0             	callq  *%r8
	file_flush(f);
  802d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1a:	48 89 c7             	mov    %rax,%rdi
  802d1d:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802d29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2d:	48 c1 e8 0c          	shr    $0xc,%rax
  802d31:	48 89 c2             	mov    %rax,%rdx
  802d34:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d3b:	01 00 00 
  802d3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d42:	83 e0 40             	and    $0x40,%eax
  802d45:	48 85 c0             	test   %rax,%rax
  802d48:	74 35                	je     802d7f <fs_test+0x465>
  802d4a:	48 b9 3e 6d 80 00 00 	movabs $0x806d3e,%rcx
  802d51:	00 00 00 
  802d54:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802d5b:	00 00 00 
  802d5e:	be 30 00 00 00       	mov    $0x30,%esi
  802d63:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802d6a:	00 00 00 
  802d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d72:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802d79:	00 00 00 
  802d7c:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802d7f:	48 bf 5a 6d 80 00 00 	movabs $0x806d5a,%rdi
  802d86:	00 00 00 
  802d89:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8e:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  802d95:	00 00 00 
  802d98:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	be 00 00 00 00       	mov    $0x0,%esi
  802da3:	48 89 c7             	mov    %rax,%rdi
  802da6:	48 b8 8d 1d 80 00 00 	movabs $0x801d8d,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	79 30                	jns    802deb <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbe:	89 c1                	mov    %eax,%ecx
  802dc0:	48 ba 6e 6d 80 00 00 	movabs $0x806d6e,%rdx
  802dc7:	00 00 00 
  802dca:	be 34 00 00 00       	mov    $0x34,%esi
  802dcf:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802dd6:	00 00 00 
  802dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dde:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802de5:	00 00 00 
  802de8:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802def:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 35                	je     802e2e <fs_test+0x514>
  802df9:	48 b9 80 6d 80 00 00 	movabs $0x806d80,%rcx
  802e00:	00 00 00 
  802e03:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802e0a:	00 00 00 
  802e0d:	be 35 00 00 00       	mov    $0x35,%esi
  802e12:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802e19:	00 00 00 
  802e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e21:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802e28:	00 00 00 
  802e2b:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	48 c1 e8 0c          	shr    $0xc,%rax
  802e36:	48 89 c2             	mov    %rax,%rdx
  802e39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e40:	01 00 00 
  802e43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e47:	83 e0 40             	and    $0x40,%eax
  802e4a:	48 85 c0             	test   %rax,%rax
  802e4d:	74 35                	je     802e84 <fs_test+0x56a>
  802e4f:	48 b9 94 6d 80 00 00 	movabs $0x806d94,%rcx
  802e56:	00 00 00 
  802e59:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802e60:	00 00 00 
  802e63:	be 36 00 00 00       	mov    $0x36,%esi
  802e68:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802e6f:	00 00 00 
  802e72:	b8 00 00 00 00       	mov    $0x0,%eax
  802e77:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802e7e:	00 00 00 
  802e81:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802e84:	48 bf ae 6d 80 00 00 	movabs $0x806dae,%rdi
  802e8b:	00 00 00 
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e93:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  802e9a:	00 00 00 
  802e9d:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802e9f:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802ea6:	00 00 00 
  802ea9:	48 8b 00             	mov    (%rax),%rax
  802eac:	48 89 c7             	mov    %rax,%rdi
  802eaf:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
  802ebb:	89 c2                	mov    %eax,%edx
  802ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec1:	89 d6                	mov    %edx,%esi
  802ec3:	48 89 c7             	mov    %rax,%rdi
  802ec6:	48 b8 8d 1d 80 00 00 	movabs $0x801d8d,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
  802ed2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed9:	79 30                	jns    802f0b <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ede:	89 c1                	mov    %eax,%ecx
  802ee0:	48 ba c5 6d 80 00 00 	movabs $0x806dc5,%rdx
  802ee7:	00 00 00 
  802eea:	be 3a 00 00 00       	mov    $0x3a,%esi
  802eef:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802ef6:	00 00 00 
  802ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  802efe:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802f05:	00 00 00 
  802f08:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0f:	48 c1 e8 0c          	shr    $0xc,%rax
  802f13:	48 89 c2             	mov    %rax,%rdx
  802f16:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f1d:	01 00 00 
  802f20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f24:	83 e0 40             	and    $0x40,%eax
  802f27:	48 85 c0             	test   %rax,%rax
  802f2a:	74 35                	je     802f61 <fs_test+0x647>
  802f2c:	48 b9 94 6d 80 00 00 	movabs $0x806d94,%rcx
  802f33:	00 00 00 
  802f36:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  802f3d:	00 00 00 
  802f40:	be 3b 00 00 00       	mov    $0x3b,%esi
  802f45:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802f4c:	00 00 00 
  802f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f54:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802f5b:	00 00 00 
  802f5e:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f65:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802f69:	be 00 00 00 00       	mov    $0x0,%esi
  802f6e:	48 89 c7             	mov    %rax,%rdi
  802f71:	48 b8 89 12 80 00 00 	movabs $0x801289,%rax
  802f78:	00 00 00 
  802f7b:	ff d0                	callq  *%rax
  802f7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f84:	79 30                	jns    802fb6 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f89:	89 c1                	mov    %eax,%ecx
  802f8b:	48 ba d9 6d 80 00 00 	movabs $0x806dd9,%rdx
  802f92:	00 00 00 
  802f95:	be 3d 00 00 00       	mov    $0x3d,%esi
  802f9a:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  802fa1:	00 00 00 
  802fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa9:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  802fb0:	00 00 00 
  802fb3:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802fb6:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802fbd:	00 00 00 
  802fc0:	48 8b 10             	mov    (%rax),%rdx
  802fc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc7:	48 89 d6             	mov    %rdx,%rsi
  802fca:	48 89 c7             	mov    %rax,%rdi
  802fcd:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802fd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdd:	48 c1 e8 0c          	shr    $0xc,%rax
  802fe1:	48 89 c2             	mov    %rax,%rdx
  802fe4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802feb:	01 00 00 
  802fee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ff2:	83 e0 40             	and    $0x40,%eax
  802ff5:	48 85 c0             	test   %rax,%rax
  802ff8:	75 35                	jne    80302f <fs_test+0x715>
  802ffa:	48 b9 23 6d 80 00 00 	movabs $0x806d23,%rcx
  803001:	00 00 00 
  803004:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  80300b:	00 00 00 
  80300e:	be 3f 00 00 00       	mov    $0x3f,%esi
  803013:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  80301a:	00 00 00 
  80301d:	b8 00 00 00 00       	mov    $0x0,%eax
  803022:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  803029:	00 00 00 
  80302c:	41 ff d0             	callq  *%r8
	file_flush(f);
  80302f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803033:	48 89 c7             	mov    %rax,%rdi
  803036:	48 b8 ea 1d 80 00 00 	movabs $0x801dea,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  803042:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803046:	48 c1 e8 0c          	shr    $0xc,%rax
  80304a:	48 89 c2             	mov    %rax,%rdx
  80304d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803054:	01 00 00 
  803057:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80305b:	83 e0 40             	and    $0x40,%eax
  80305e:	48 85 c0             	test   %rax,%rax
  803061:	74 35                	je     803098 <fs_test+0x77e>
  803063:	48 b9 3e 6d 80 00 00 	movabs $0x806d3e,%rcx
  80306a:	00 00 00 
  80306d:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  803074:	00 00 00 
  803077:	be 41 00 00 00       	mov    $0x41,%esi
  80307c:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  803083:	00 00 00 
  803086:	b8 00 00 00 00       	mov    $0x0,%eax
  80308b:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  803092:	00 00 00 
  803095:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309c:	48 c1 e8 0c          	shr    $0xc,%rax
  8030a0:	48 89 c2             	mov    %rax,%rdx
  8030a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030aa:	01 00 00 
  8030ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030b1:	83 e0 40             	and    $0x40,%eax
  8030b4:	48 85 c0             	test   %rax,%rax
  8030b7:	74 35                	je     8030ee <fs_test+0x7d4>
  8030b9:	48 b9 94 6d 80 00 00 	movabs $0x806d94,%rcx
  8030c0:	00 00 00 
  8030c3:	48 ba 06 6c 80 00 00 	movabs $0x806c06,%rdx
  8030ca:	00 00 00 
  8030cd:	be 42 00 00 00       	mov    $0x42,%esi
  8030d2:	48 bf d1 6b 80 00 00 	movabs $0x806bd1,%rdi
  8030d9:	00 00 00 
  8030dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e1:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  8030e8:	00 00 00 
  8030eb:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  8030ee:	48 bf ee 6d 80 00 00 	movabs $0x806dee,%rdi
  8030f5:	00 00 00 
  8030f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fd:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  803104:	00 00 00 
  803107:	ff d2                	callq  *%rdx
}
  803109:	c9                   	leaveq 
  80310a:	c3                   	retq   

000000000080310b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80310b:	55                   	push   %rbp
  80310c:	48 89 e5             	mov    %rsp,%rbp
  80310f:	48 83 ec 20          	sub    $0x20,%rsp
  803113:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80311a:	48 b8 73 48 80 00 00 	movabs $0x804873,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
  803126:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  803129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803131:	48 63 d0             	movslq %eax,%rdx
  803134:	48 89 d0             	mov    %rdx,%rax
  803137:	48 c1 e0 03          	shl    $0x3,%rax
  80313b:	48 01 d0             	add    %rdx,%rax
  80313e:	48 c1 e0 05          	shl    $0x5,%rax
  803142:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803149:	00 00 00 
  80314c:	48 01 c2             	add    %rax,%rdx
  80314f:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  803156:	00 00 00 
  803159:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80315c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803160:	7e 14                	jle    803176 <libmain+0x6b>
		binaryname = argv[0];
  803162:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803166:	48 8b 10             	mov    (%rax),%rdx
  803169:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  803170:	00 00 00 
  803173:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  803176:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80317a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80317d:	48 89 d6             	mov    %rdx,%rsi
  803180:	89 c7                	mov    %eax,%edi
  803182:	48 b8 76 28 80 00 00 	movabs $0x802876,%rax
  803189:	00 00 00 
  80318c:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80318e:	48 b8 9c 31 80 00 00 	movabs $0x80319c,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
}
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8031a0:	48 b8 c2 51 80 00 00 	movabs $0x8051c2,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8031ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b1:	48 b8 2f 48 80 00 00 	movabs $0x80482f,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
}
  8031bd:	5d                   	pop    %rbp
  8031be:	c3                   	retq   

00000000008031bf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8031bf:	55                   	push   %rbp
  8031c0:	48 89 e5             	mov    %rsp,%rbp
  8031c3:	53                   	push   %rbx
  8031c4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8031cb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8031d2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8031d8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8031df:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8031e6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8031ed:	84 c0                	test   %al,%al
  8031ef:	74 23                	je     803214 <_panic+0x55>
  8031f1:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8031f8:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8031fc:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803200:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803204:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803208:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80320c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803210:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803214:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80321b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803222:	00 00 00 
  803225:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80322c:	00 00 00 
  80322f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803233:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80323a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803241:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803248:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  80324f:	00 00 00 
  803252:	48 8b 18             	mov    (%rax),%rbx
  803255:	48 b8 73 48 80 00 00 	movabs $0x804873,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
  803261:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803267:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80326e:	41 89 c8             	mov    %ecx,%r8d
  803271:	48 89 d1             	mov    %rdx,%rcx
  803274:	48 89 da             	mov    %rbx,%rdx
  803277:	89 c6                	mov    %eax,%esi
  803279:	48 bf 10 6e 80 00 00 	movabs $0x806e10,%rdi
  803280:	00 00 00 
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
  803288:	49 b9 f8 33 80 00 00 	movabs $0x8033f8,%r9
  80328f:	00 00 00 
  803292:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803295:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80329c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8032a3:	48 89 d6             	mov    %rdx,%rsi
  8032a6:	48 89 c7             	mov    %rax,%rdi
  8032a9:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
	cprintf("\n");
  8032b5:	48 bf 33 6e 80 00 00 	movabs $0x806e33,%rdi
  8032bc:	00 00 00 
  8032bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c4:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  8032cb:	00 00 00 
  8032ce:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8032d0:	cc                   	int3   
  8032d1:	eb fd                	jmp    8032d0 <_panic+0x111>

00000000008032d3 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8032d3:	55                   	push   %rbp
  8032d4:	48 89 e5             	mov    %rsp,%rbp
  8032d7:	48 83 ec 10          	sub    $0x10,%rsp
  8032db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8032e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e6:	8b 00                	mov    (%rax),%eax
  8032e8:	8d 48 01             	lea    0x1(%rax),%ecx
  8032eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ef:	89 0a                	mov    %ecx,(%rdx)
  8032f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032f4:	89 d1                	mov    %edx,%ecx
  8032f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032fa:	48 98                	cltq   
  8032fc:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	8b 00                	mov    (%rax),%eax
  803306:	3d ff 00 00 00       	cmp    $0xff,%eax
  80330b:	75 2c                	jne    803339 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80330d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803311:	8b 00                	mov    (%rax),%eax
  803313:	48 98                	cltq   
  803315:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803319:	48 83 c2 08          	add    $0x8,%rdx
  80331d:	48 89 c6             	mov    %rax,%rsi
  803320:	48 89 d7             	mov    %rdx,%rdi
  803323:	48 b8 a7 47 80 00 00 	movabs $0x8047a7,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
        b->idx = 0;
  80332f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803333:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  803339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333d:	8b 40 04             	mov    0x4(%rax),%eax
  803340:	8d 50 01             	lea    0x1(%rax),%edx
  803343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803347:	89 50 04             	mov    %edx,0x4(%rax)
}
  80334a:	c9                   	leaveq 
  80334b:	c3                   	retq   

000000000080334c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80334c:	55                   	push   %rbp
  80334d:	48 89 e5             	mov    %rsp,%rbp
  803350:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  803357:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80335e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  803365:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80336c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803373:	48 8b 0a             	mov    (%rdx),%rcx
  803376:	48 89 08             	mov    %rcx,(%rax)
  803379:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80337d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803381:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803385:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  803389:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803390:	00 00 00 
    b.cnt = 0;
  803393:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80339a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80339d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8033a4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8033ab:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8033b2:	48 89 c6             	mov    %rax,%rsi
  8033b5:	48 bf d3 32 80 00 00 	movabs $0x8032d3,%rdi
  8033bc:	00 00 00 
  8033bf:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8033cb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8033d1:	48 98                	cltq   
  8033d3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8033da:	48 83 c2 08          	add    $0x8,%rdx
  8033de:	48 89 c6             	mov    %rax,%rsi
  8033e1:	48 89 d7             	mov    %rdx,%rdi
  8033e4:	48 b8 a7 47 80 00 00 	movabs $0x8047a7,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8033f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8033f6:	c9                   	leaveq 
  8033f7:	c3                   	retq   

00000000008033f8 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8033f8:	55                   	push   %rbp
  8033f9:	48 89 e5             	mov    %rsp,%rbp
  8033fc:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803403:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80340a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803411:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803418:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80341f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803426:	84 c0                	test   %al,%al
  803428:	74 20                	je     80344a <cprintf+0x52>
  80342a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80342e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803432:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803436:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80343a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80343e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803442:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803446:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80344a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  803451:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803458:	00 00 00 
  80345b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803462:	00 00 00 
  803465:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803469:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803470:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803477:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80347e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803485:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80348c:	48 8b 0a             	mov    (%rdx),%rcx
  80348f:	48 89 08             	mov    %rcx,(%rax)
  803492:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803496:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80349a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80349e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8034a2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8034a9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034b0:	48 89 d6             	mov    %rdx,%rsi
  8034b3:	48 89 c7             	mov    %rax,%rdi
  8034b6:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8034bd:	00 00 00 
  8034c0:	ff d0                	callq  *%rax
  8034c2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8034c8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034ce:	c9                   	leaveq 
  8034cf:	c3                   	retq   

00000000008034d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8034d0:	55                   	push   %rbp
  8034d1:	48 89 e5             	mov    %rsp,%rbp
  8034d4:	53                   	push   %rbx
  8034d5:	48 83 ec 38          	sub    $0x38,%rsp
  8034d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8034e5:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8034e8:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8034ec:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8034f0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034f3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8034f7:	77 3b                	ja     803534 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8034f9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8034fc:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803500:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  803503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803507:	ba 00 00 00 00       	mov    $0x0,%edx
  80350c:	48 f7 f3             	div    %rbx
  80350f:	48 89 c2             	mov    %rax,%rdx
  803512:	8b 7d cc             	mov    -0x34(%rbp),%edi
  803515:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803518:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80351c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803520:	41 89 f9             	mov    %edi,%r9d
  803523:	48 89 c7             	mov    %rax,%rdi
  803526:	48 b8 d0 34 80 00 00 	movabs $0x8034d0,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
  803532:	eb 1e                	jmp    803552 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803534:	eb 12                	jmp    803548 <printnum+0x78>
			putch(padc, putdat);
  803536:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80353a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80353d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803541:	48 89 ce             	mov    %rcx,%rsi
  803544:	89 d7                	mov    %edx,%edi
  803546:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803548:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80354c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  803550:	7f e4                	jg     803536 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803552:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803559:	ba 00 00 00 00       	mov    $0x0,%edx
  80355e:	48 f7 f1             	div    %rcx
  803561:	48 89 d0             	mov    %rdx,%rax
  803564:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  80356b:	00 00 00 
  80356e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803572:	0f be d0             	movsbl %al,%edx
  803575:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357d:	48 89 ce             	mov    %rcx,%rsi
  803580:	89 d7                	mov    %edx,%edi
  803582:	ff d0                	callq  *%rax
}
  803584:	48 83 c4 38          	add    $0x38,%rsp
  803588:	5b                   	pop    %rbx
  803589:	5d                   	pop    %rbp
  80358a:	c3                   	retq   

000000000080358b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80358b:	55                   	push   %rbp
  80358c:	48 89 e5             	mov    %rsp,%rbp
  80358f:	48 83 ec 1c          	sub    $0x1c,%rsp
  803593:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803597:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80359a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80359e:	7e 52                	jle    8035f2 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8035a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a4:	8b 00                	mov    (%rax),%eax
  8035a6:	83 f8 30             	cmp    $0x30,%eax
  8035a9:	73 24                	jae    8035cf <getuint+0x44>
  8035ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8035b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b7:	8b 00                	mov    (%rax),%eax
  8035b9:	89 c0                	mov    %eax,%eax
  8035bb:	48 01 d0             	add    %rdx,%rax
  8035be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035c2:	8b 12                	mov    (%rdx),%edx
  8035c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8035c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035cb:	89 0a                	mov    %ecx,(%rdx)
  8035cd:	eb 17                	jmp    8035e6 <getuint+0x5b>
  8035cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8035d7:	48 89 d0             	mov    %rdx,%rax
  8035da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8035de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8035e6:	48 8b 00             	mov    (%rax),%rax
  8035e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8035ed:	e9 a3 00 00 00       	jmpq   803695 <getuint+0x10a>
	else if (lflag)
  8035f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8035f6:	74 4f                	je     803647 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8035f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fc:	8b 00                	mov    (%rax),%eax
  8035fe:	83 f8 30             	cmp    $0x30,%eax
  803601:	73 24                	jae    803627 <getuint+0x9c>
  803603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803607:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80360b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360f:	8b 00                	mov    (%rax),%eax
  803611:	89 c0                	mov    %eax,%eax
  803613:	48 01 d0             	add    %rdx,%rax
  803616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361a:	8b 12                	mov    (%rdx),%edx
  80361c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80361f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803623:	89 0a                	mov    %ecx,(%rdx)
  803625:	eb 17                	jmp    80363e <getuint+0xb3>
  803627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80362f:	48 89 d0             	mov    %rdx,%rax
  803632:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80363a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80363e:	48 8b 00             	mov    (%rax),%rax
  803641:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803645:	eb 4e                	jmp    803695 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  803647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364b:	8b 00                	mov    (%rax),%eax
  80364d:	83 f8 30             	cmp    $0x30,%eax
  803650:	73 24                	jae    803676 <getuint+0xeb>
  803652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803656:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80365a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365e:	8b 00                	mov    (%rax),%eax
  803660:	89 c0                	mov    %eax,%eax
  803662:	48 01 d0             	add    %rdx,%rax
  803665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803669:	8b 12                	mov    (%rdx),%edx
  80366b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80366e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803672:	89 0a                	mov    %ecx,(%rdx)
  803674:	eb 17                	jmp    80368d <getuint+0x102>
  803676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80367e:	48 89 d0             	mov    %rdx,%rax
  803681:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803685:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803689:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80368d:	8b 00                	mov    (%rax),%eax
  80368f:	89 c0                	mov    %eax,%eax
  803691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803699:	c9                   	leaveq 
  80369a:	c3                   	retq   

000000000080369b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80369b:	55                   	push   %rbp
  80369c:	48 89 e5             	mov    %rsp,%rbp
  80369f:	48 83 ec 1c          	sub    $0x1c,%rsp
  8036a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8036aa:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8036ae:	7e 52                	jle    803702 <getint+0x67>
		x=va_arg(*ap, long long);
  8036b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b4:	8b 00                	mov    (%rax),%eax
  8036b6:	83 f8 30             	cmp    $0x30,%eax
  8036b9:	73 24                	jae    8036df <getint+0x44>
  8036bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c7:	8b 00                	mov    (%rax),%eax
  8036c9:	89 c0                	mov    %eax,%eax
  8036cb:	48 01 d0             	add    %rdx,%rax
  8036ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036d2:	8b 12                	mov    (%rdx),%edx
  8036d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036db:	89 0a                	mov    %ecx,(%rdx)
  8036dd:	eb 17                	jmp    8036f6 <getint+0x5b>
  8036df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036e7:	48 89 d0             	mov    %rdx,%rax
  8036ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8036ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036f6:	48 8b 00             	mov    (%rax),%rax
  8036f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036fd:	e9 a3 00 00 00       	jmpq   8037a5 <getint+0x10a>
	else if (lflag)
  803702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803706:	74 4f                	je     803757 <getint+0xbc>
		x=va_arg(*ap, long);
  803708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370c:	8b 00                	mov    (%rax),%eax
  80370e:	83 f8 30             	cmp    $0x30,%eax
  803711:	73 24                	jae    803737 <getint+0x9c>
  803713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803717:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80371b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371f:	8b 00                	mov    (%rax),%eax
  803721:	89 c0                	mov    %eax,%eax
  803723:	48 01 d0             	add    %rdx,%rax
  803726:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80372a:	8b 12                	mov    (%rdx),%edx
  80372c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80372f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803733:	89 0a                	mov    %ecx,(%rdx)
  803735:	eb 17                	jmp    80374e <getint+0xb3>
  803737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80373b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80373f:	48 89 d0             	mov    %rdx,%rax
  803742:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80374a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80374e:	48 8b 00             	mov    (%rax),%rax
  803751:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803755:	eb 4e                	jmp    8037a5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375b:	8b 00                	mov    (%rax),%eax
  80375d:	83 f8 30             	cmp    $0x30,%eax
  803760:	73 24                	jae    803786 <getint+0xeb>
  803762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803766:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80376a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80376e:	8b 00                	mov    (%rax),%eax
  803770:	89 c0                	mov    %eax,%eax
  803772:	48 01 d0             	add    %rdx,%rax
  803775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803779:	8b 12                	mov    (%rdx),%edx
  80377b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80377e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803782:	89 0a                	mov    %ecx,(%rdx)
  803784:	eb 17                	jmp    80379d <getint+0x102>
  803786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80378e:	48 89 d0             	mov    %rdx,%rax
  803791:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803795:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803799:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80379d:	8b 00                	mov    (%rax),%eax
  80379f:	48 98                	cltq   
  8037a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8037a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037a9:	c9                   	leaveq 
  8037aa:	c3                   	retq   

00000000008037ab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8037ab:	55                   	push   %rbp
  8037ac:	48 89 e5             	mov    %rsp,%rbp
  8037af:	41 54                	push   %r12
  8037b1:	53                   	push   %rbx
  8037b2:	48 83 ec 60          	sub    $0x60,%rsp
  8037b6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8037ba:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8037be:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8037c2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8037c6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8037ca:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8037ce:	48 8b 0a             	mov    (%rdx),%rcx
  8037d1:	48 89 08             	mov    %rcx,(%rax)
  8037d4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8037d8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8037dc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8037e0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8037e4:	eb 17                	jmp    8037fd <vprintfmt+0x52>
			if (ch == '\0')
  8037e6:	85 db                	test   %ebx,%ebx
  8037e8:	0f 84 df 04 00 00    	je     803ccd <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8037ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8037f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8037f6:	48 89 d6             	mov    %rdx,%rsi
  8037f9:	89 df                	mov    %ebx,%edi
  8037fb:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8037fd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803801:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803805:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803809:	0f b6 00             	movzbl (%rax),%eax
  80380c:	0f b6 d8             	movzbl %al,%ebx
  80380f:	83 fb 25             	cmp    $0x25,%ebx
  803812:	75 d2                	jne    8037e6 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803814:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803818:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80381f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80382d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803834:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803838:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80383c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803840:	0f b6 00             	movzbl (%rax),%eax
  803843:	0f b6 d8             	movzbl %al,%ebx
  803846:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803849:	83 f8 55             	cmp    $0x55,%eax
  80384c:	0f 87 47 04 00 00    	ja     803c99 <vprintfmt+0x4ee>
  803852:	89 c0                	mov    %eax,%eax
  803854:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80385b:	00 
  80385c:	48 b8 58 70 80 00 00 	movabs $0x807058,%rax
  803863:	00 00 00 
  803866:	48 01 d0             	add    %rdx,%rax
  803869:	48 8b 00             	mov    (%rax),%rax
  80386c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80386e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803872:	eb c0                	jmp    803834 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803874:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803878:	eb ba                	jmp    803834 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80387a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803881:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803884:	89 d0                	mov    %edx,%eax
  803886:	c1 e0 02             	shl    $0x2,%eax
  803889:	01 d0                	add    %edx,%eax
  80388b:	01 c0                	add    %eax,%eax
  80388d:	01 d8                	add    %ebx,%eax
  80388f:	83 e8 30             	sub    $0x30,%eax
  803892:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803895:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803899:	0f b6 00             	movzbl (%rax),%eax
  80389c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80389f:	83 fb 2f             	cmp    $0x2f,%ebx
  8038a2:	7e 0c                	jle    8038b0 <vprintfmt+0x105>
  8038a4:	83 fb 39             	cmp    $0x39,%ebx
  8038a7:	7f 07                	jg     8038b0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8038a9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8038ae:	eb d1                	jmp    803881 <vprintfmt+0xd6>
			goto process_precision;
  8038b0:	eb 58                	jmp    80390a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8038b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038b5:	83 f8 30             	cmp    $0x30,%eax
  8038b8:	73 17                	jae    8038d1 <vprintfmt+0x126>
  8038ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8038be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038c1:	89 c0                	mov    %eax,%eax
  8038c3:	48 01 d0             	add    %rdx,%rax
  8038c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038c9:	83 c2 08             	add    $0x8,%edx
  8038cc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8038cf:	eb 0f                	jmp    8038e0 <vprintfmt+0x135>
  8038d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8038d5:	48 89 d0             	mov    %rdx,%rax
  8038d8:	48 83 c2 08          	add    $0x8,%rdx
  8038dc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8038e0:	8b 00                	mov    (%rax),%eax
  8038e2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8038e5:	eb 23                	jmp    80390a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8038e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8038eb:	79 0c                	jns    8038f9 <vprintfmt+0x14e>
				width = 0;
  8038ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8038f4:	e9 3b ff ff ff       	jmpq   803834 <vprintfmt+0x89>
  8038f9:	e9 36 ff ff ff       	jmpq   803834 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8038fe:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803905:	e9 2a ff ff ff       	jmpq   803834 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80390a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80390e:	79 12                	jns    803922 <vprintfmt+0x177>
				width = precision, precision = -1;
  803910:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803913:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803916:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80391d:	e9 12 ff ff ff       	jmpq   803834 <vprintfmt+0x89>
  803922:	e9 0d ff ff ff       	jmpq   803834 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803927:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80392b:	e9 04 ff ff ff       	jmpq   803834 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803930:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803933:	83 f8 30             	cmp    $0x30,%eax
  803936:	73 17                	jae    80394f <vprintfmt+0x1a4>
  803938:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80393c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80393f:	89 c0                	mov    %eax,%eax
  803941:	48 01 d0             	add    %rdx,%rax
  803944:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803947:	83 c2 08             	add    $0x8,%edx
  80394a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80394d:	eb 0f                	jmp    80395e <vprintfmt+0x1b3>
  80394f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803953:	48 89 d0             	mov    %rdx,%rax
  803956:	48 83 c2 08          	add    $0x8,%rdx
  80395a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80395e:	8b 10                	mov    (%rax),%edx
  803960:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803964:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803968:	48 89 ce             	mov    %rcx,%rsi
  80396b:	89 d7                	mov    %edx,%edi
  80396d:	ff d0                	callq  *%rax
			break;
  80396f:	e9 53 03 00 00       	jmpq   803cc7 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803974:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803977:	83 f8 30             	cmp    $0x30,%eax
  80397a:	73 17                	jae    803993 <vprintfmt+0x1e8>
  80397c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803980:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803983:	89 c0                	mov    %eax,%eax
  803985:	48 01 d0             	add    %rdx,%rax
  803988:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80398b:	83 c2 08             	add    $0x8,%edx
  80398e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803991:	eb 0f                	jmp    8039a2 <vprintfmt+0x1f7>
  803993:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803997:	48 89 d0             	mov    %rdx,%rax
  80399a:	48 83 c2 08          	add    $0x8,%rdx
  80399e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039a2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8039a4:	85 db                	test   %ebx,%ebx
  8039a6:	79 02                	jns    8039aa <vprintfmt+0x1ff>
				err = -err;
  8039a8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8039aa:	83 fb 15             	cmp    $0x15,%ebx
  8039ad:	7f 16                	jg     8039c5 <vprintfmt+0x21a>
  8039af:	48 b8 80 6f 80 00 00 	movabs $0x806f80,%rax
  8039b6:	00 00 00 
  8039b9:	48 63 d3             	movslq %ebx,%rdx
  8039bc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8039c0:	4d 85 e4             	test   %r12,%r12
  8039c3:	75 2e                	jne    8039f3 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8039c5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8039c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039cd:	89 d9                	mov    %ebx,%ecx
  8039cf:	48 ba 41 70 80 00 00 	movabs $0x807041,%rdx
  8039d6:	00 00 00 
  8039d9:	48 89 c7             	mov    %rax,%rdi
  8039dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e1:	49 b8 d6 3c 80 00 00 	movabs $0x803cd6,%r8
  8039e8:	00 00 00 
  8039eb:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8039ee:	e9 d4 02 00 00       	jmpq   803cc7 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8039f3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8039f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039fb:	4c 89 e1             	mov    %r12,%rcx
  8039fe:	48 ba 4a 70 80 00 00 	movabs $0x80704a,%rdx
  803a05:	00 00 00 
  803a08:	48 89 c7             	mov    %rax,%rdi
  803a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a10:	49 b8 d6 3c 80 00 00 	movabs $0x803cd6,%r8
  803a17:	00 00 00 
  803a1a:	41 ff d0             	callq  *%r8
			break;
  803a1d:	e9 a5 02 00 00       	jmpq   803cc7 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803a22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a25:	83 f8 30             	cmp    $0x30,%eax
  803a28:	73 17                	jae    803a41 <vprintfmt+0x296>
  803a2a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803a2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a31:	89 c0                	mov    %eax,%eax
  803a33:	48 01 d0             	add    %rdx,%rax
  803a36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a39:	83 c2 08             	add    $0x8,%edx
  803a3c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803a3f:	eb 0f                	jmp    803a50 <vprintfmt+0x2a5>
  803a41:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803a45:	48 89 d0             	mov    %rdx,%rax
  803a48:	48 83 c2 08          	add    $0x8,%rdx
  803a4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803a50:	4c 8b 20             	mov    (%rax),%r12
  803a53:	4d 85 e4             	test   %r12,%r12
  803a56:	75 0a                	jne    803a62 <vprintfmt+0x2b7>
				p = "(null)";
  803a58:	49 bc 4d 70 80 00 00 	movabs $0x80704d,%r12
  803a5f:	00 00 00 
			if (width > 0 && padc != '-')
  803a62:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a66:	7e 3f                	jle    803aa7 <vprintfmt+0x2fc>
  803a68:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803a6c:	74 39                	je     803aa7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803a6e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a71:	48 98                	cltq   
  803a73:	48 89 c6             	mov    %rax,%rsi
  803a76:	4c 89 e7             	mov    %r12,%rdi
  803a79:	48 b8 82 3f 80 00 00 	movabs $0x803f82,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
  803a85:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803a88:	eb 17                	jmp    803aa1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  803a8a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803a8e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803a92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a96:	48 89 ce             	mov    %rcx,%rsi
  803a99:	89 d7                	mov    %edx,%edi
  803a9b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803a9d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803aa1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803aa5:	7f e3                	jg     803a8a <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803aa7:	eb 37                	jmp    803ae0 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803aa9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803aad:	74 1e                	je     803acd <vprintfmt+0x322>
  803aaf:	83 fb 1f             	cmp    $0x1f,%ebx
  803ab2:	7e 05                	jle    803ab9 <vprintfmt+0x30e>
  803ab4:	83 fb 7e             	cmp    $0x7e,%ebx
  803ab7:	7e 14                	jle    803acd <vprintfmt+0x322>
					putch('?', putdat);
  803ab9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803abd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ac1:	48 89 d6             	mov    %rdx,%rsi
  803ac4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803ac9:	ff d0                	callq  *%rax
  803acb:	eb 0f                	jmp    803adc <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803acd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ad1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ad5:	48 89 d6             	mov    %rdx,%rsi
  803ad8:	89 df                	mov    %ebx,%edi
  803ada:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803adc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803ae0:	4c 89 e0             	mov    %r12,%rax
  803ae3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803ae7:	0f b6 00             	movzbl (%rax),%eax
  803aea:	0f be d8             	movsbl %al,%ebx
  803aed:	85 db                	test   %ebx,%ebx
  803aef:	74 10                	je     803b01 <vprintfmt+0x356>
  803af1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803af5:	78 b2                	js     803aa9 <vprintfmt+0x2fe>
  803af7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803afb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803aff:	79 a8                	jns    803aa9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803b01:	eb 16                	jmp    803b19 <vprintfmt+0x36e>
				putch(' ', putdat);
  803b03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b0b:	48 89 d6             	mov    %rdx,%rsi
  803b0e:	bf 20 00 00 00       	mov    $0x20,%edi
  803b13:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803b15:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b1d:	7f e4                	jg     803b03 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803b1f:	e9 a3 01 00 00       	jmpq   803cc7 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803b24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b28:	be 03 00 00 00       	mov    $0x3,%esi
  803b2d:	48 89 c7             	mov    %rax,%rdi
  803b30:	48 b8 9b 36 80 00 00 	movabs $0x80369b,%rax
  803b37:	00 00 00 
  803b3a:	ff d0                	callq  *%rax
  803b3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b44:	48 85 c0             	test   %rax,%rax
  803b47:	79 1d                	jns    803b66 <vprintfmt+0x3bb>
				putch('-', putdat);
  803b49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b51:	48 89 d6             	mov    %rdx,%rsi
  803b54:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803b59:	ff d0                	callq  *%rax
				num = -(long long) num;
  803b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b5f:	48 f7 d8             	neg    %rax
  803b62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803b66:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803b6d:	e9 e8 00 00 00       	jmpq   803c5a <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803b72:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b76:	be 03 00 00 00       	mov    $0x3,%esi
  803b7b:	48 89 c7             	mov    %rax,%rdi
  803b7e:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  803b85:	00 00 00 
  803b88:	ff d0                	callq  *%rax
  803b8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803b8e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803b95:	e9 c0 00 00 00       	jmpq   803c5a <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  803b9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ba2:	48 89 d6             	mov    %rdx,%rsi
  803ba5:	bf 58 00 00 00       	mov    $0x58,%edi
  803baa:	ff d0                	callq  *%rax
			putch('X', putdat);
  803bac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bb4:	48 89 d6             	mov    %rdx,%rsi
  803bb7:	bf 58 00 00 00       	mov    $0x58,%edi
  803bbc:	ff d0                	callq  *%rax
			putch('X', putdat);
  803bbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bc6:	48 89 d6             	mov    %rdx,%rsi
  803bc9:	bf 58 00 00 00       	mov    $0x58,%edi
  803bce:	ff d0                	callq  *%rax
			break;
  803bd0:	e9 f2 00 00 00       	jmpq   803cc7 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  803bd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bdd:	48 89 d6             	mov    %rdx,%rsi
  803be0:	bf 30 00 00 00       	mov    $0x30,%edi
  803be5:	ff d0                	callq  *%rax
			putch('x', putdat);
  803be7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bef:	48 89 d6             	mov    %rdx,%rsi
  803bf2:	bf 78 00 00 00       	mov    $0x78,%edi
  803bf7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803bf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803bfc:	83 f8 30             	cmp    $0x30,%eax
  803bff:	73 17                	jae    803c18 <vprintfmt+0x46d>
  803c01:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c08:	89 c0                	mov    %eax,%eax
  803c0a:	48 01 d0             	add    %rdx,%rax
  803c0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c10:	83 c2 08             	add    $0x8,%edx
  803c13:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803c16:	eb 0f                	jmp    803c27 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  803c18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803c1c:	48 89 d0             	mov    %rdx,%rax
  803c1f:	48 83 c2 08          	add    $0x8,%rdx
  803c23:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c27:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803c2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803c2e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803c35:	eb 23                	jmp    803c5a <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803c37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c3b:	be 03 00 00 00       	mov    $0x3,%esi
  803c40:	48 89 c7             	mov    %rax,%rdi
  803c43:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  803c4a:	00 00 00 
  803c4d:	ff d0                	callq  *%rax
  803c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803c53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803c5a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803c5f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803c62:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803c65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c71:	45 89 c1             	mov    %r8d,%r9d
  803c74:	41 89 f8             	mov    %edi,%r8d
  803c77:	48 89 c7             	mov    %rax,%rdi
  803c7a:	48 b8 d0 34 80 00 00 	movabs $0x8034d0,%rax
  803c81:	00 00 00 
  803c84:	ff d0                	callq  *%rax
			break;
  803c86:	eb 3f                	jmp    803cc7 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803c88:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c90:	48 89 d6             	mov    %rdx,%rsi
  803c93:	89 df                	mov    %ebx,%edi
  803c95:	ff d0                	callq  *%rax
			break;
  803c97:	eb 2e                	jmp    803cc7 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803c99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ca1:	48 89 d6             	mov    %rdx,%rsi
  803ca4:	bf 25 00 00 00       	mov    $0x25,%edi
  803ca9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803cab:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803cb0:	eb 05                	jmp    803cb7 <vprintfmt+0x50c>
  803cb2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803cb7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803cbb:	48 83 e8 01          	sub    $0x1,%rax
  803cbf:	0f b6 00             	movzbl (%rax),%eax
  803cc2:	3c 25                	cmp    $0x25,%al
  803cc4:	75 ec                	jne    803cb2 <vprintfmt+0x507>
				/* do nothing */;
			break;
  803cc6:	90                   	nop
		}
	}
  803cc7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803cc8:	e9 30 fb ff ff       	jmpq   8037fd <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803ccd:	48 83 c4 60          	add    $0x60,%rsp
  803cd1:	5b                   	pop    %rbx
  803cd2:	41 5c                	pop    %r12
  803cd4:	5d                   	pop    %rbp
  803cd5:	c3                   	retq   

0000000000803cd6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803cd6:	55                   	push   %rbp
  803cd7:	48 89 e5             	mov    %rsp,%rbp
  803cda:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803ce1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803ce8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803cef:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803cf6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803cfd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803d04:	84 c0                	test   %al,%al
  803d06:	74 20                	je     803d28 <printfmt+0x52>
  803d08:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803d0c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803d10:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803d14:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803d18:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803d1c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803d20:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803d24:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803d28:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803d2f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803d36:	00 00 00 
  803d39:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803d40:	00 00 00 
  803d43:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803d47:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803d4e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803d55:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803d5c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803d63:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803d6a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803d71:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803d78:	48 89 c7             	mov    %rax,%rdi
  803d7b:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	callq  *%rax
	va_end(ap);
}
  803d87:	c9                   	leaveq 
  803d88:	c3                   	retq   

0000000000803d89 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803d89:	55                   	push   %rbp
  803d8a:	48 89 e5             	mov    %rsp,%rbp
  803d8d:	48 83 ec 10          	sub    $0x10,%rsp
  803d91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803d98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9c:	8b 40 10             	mov    0x10(%rax),%eax
  803d9f:	8d 50 01             	lea    0x1(%rax),%edx
  803da2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dad:	48 8b 10             	mov    (%rax),%rdx
  803db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db4:	48 8b 40 08          	mov    0x8(%rax),%rax
  803db8:	48 39 c2             	cmp    %rax,%rdx
  803dbb:	73 17                	jae    803dd4 <sprintputch+0x4b>
		*b->buf++ = ch;
  803dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc1:	48 8b 00             	mov    (%rax),%rax
  803dc4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803dc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dcc:	48 89 0a             	mov    %rcx,(%rdx)
  803dcf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803dd2:	88 10                	mov    %dl,(%rax)
}
  803dd4:	c9                   	leaveq 
  803dd5:	c3                   	retq   

0000000000803dd6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803dd6:	55                   	push   %rbp
  803dd7:	48 89 e5             	mov    %rsp,%rbp
  803dda:	48 83 ec 50          	sub    $0x50,%rsp
  803dde:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803de2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803de5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803de9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803ded:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803df1:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803df5:	48 8b 0a             	mov    (%rdx),%rcx
  803df8:	48 89 08             	mov    %rcx,(%rax)
  803dfb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803dff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803e03:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803e07:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803e0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e0f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803e13:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803e16:	48 98                	cltq   
  803e18:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803e1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e20:	48 01 d0             	add    %rdx,%rax
  803e23:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803e27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803e2e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803e33:	74 06                	je     803e3b <vsnprintf+0x65>
  803e35:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803e39:	7f 07                	jg     803e42 <vsnprintf+0x6c>
		return -E_INVAL;
  803e3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e40:	eb 2f                	jmp    803e71 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803e42:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803e46:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803e4a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e4e:	48 89 c6             	mov    %rax,%rsi
  803e51:	48 bf 89 3d 80 00 00 	movabs $0x803d89,%rdi
  803e58:	00 00 00 
  803e5b:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803e67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e6b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803e6e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803e71:	c9                   	leaveq 
  803e72:	c3                   	retq   

0000000000803e73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803e73:	55                   	push   %rbp
  803e74:	48 89 e5             	mov    %rsp,%rbp
  803e77:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803e7e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803e85:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803e8b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803e92:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803e99:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803ea0:	84 c0                	test   %al,%al
  803ea2:	74 20                	je     803ec4 <snprintf+0x51>
  803ea4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803ea8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803eac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803eb0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803eb4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803eb8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803ebc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803ec0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803ec4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803ecb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803ed2:	00 00 00 
  803ed5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803edc:	00 00 00 
  803edf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ee3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803eea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803ef1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803ef8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803eff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803f06:	48 8b 0a             	mov    (%rdx),%rcx
  803f09:	48 89 08             	mov    %rcx,(%rax)
  803f0c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803f10:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803f14:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803f18:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803f1c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803f23:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803f2a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803f30:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f37:	48 89 c7             	mov    %rax,%rdi
  803f3a:	48 b8 d6 3d 80 00 00 	movabs $0x803dd6,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803f4c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803f52:	c9                   	leaveq 
  803f53:	c3                   	retq   

0000000000803f54 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803f54:	55                   	push   %rbp
  803f55:	48 89 e5             	mov    %rsp,%rbp
  803f58:	48 83 ec 18          	sub    $0x18,%rsp
  803f5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803f60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f67:	eb 09                	jmp    803f72 <strlen+0x1e>
		n++;
  803f69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803f6d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f76:	0f b6 00             	movzbl (%rax),%eax
  803f79:	84 c0                	test   %al,%al
  803f7b:	75 ec                	jne    803f69 <strlen+0x15>
		n++;
	return n;
  803f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f80:	c9                   	leaveq 
  803f81:	c3                   	retq   

0000000000803f82 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803f82:	55                   	push   %rbp
  803f83:	48 89 e5             	mov    %rsp,%rbp
  803f86:	48 83 ec 20          	sub    $0x20,%rsp
  803f8a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f8e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f99:	eb 0e                	jmp    803fa9 <strnlen+0x27>
		n++;
  803f9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803f9f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803fa4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803fa9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fae:	74 0b                	je     803fbb <strnlen+0x39>
  803fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb4:	0f b6 00             	movzbl (%rax),%eax
  803fb7:	84 c0                	test   %al,%al
  803fb9:	75 e0                	jne    803f9b <strnlen+0x19>
		n++;
	return n;
  803fbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fbe:	c9                   	leaveq 
  803fbf:	c3                   	retq   

0000000000803fc0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803fc0:	55                   	push   %rbp
  803fc1:	48 89 e5             	mov    %rsp,%rbp
  803fc4:	48 83 ec 20          	sub    $0x20,%rsp
  803fc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803fd8:	90                   	nop
  803fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fdd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803fe1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803fe5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fe9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803fed:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803ff1:	0f b6 12             	movzbl (%rdx),%edx
  803ff4:	88 10                	mov    %dl,(%rax)
  803ff6:	0f b6 00             	movzbl (%rax),%eax
  803ff9:	84 c0                	test   %al,%al
  803ffb:	75 dc                	jne    803fd9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803ffd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804001:	c9                   	leaveq 
  804002:	c3                   	retq   

0000000000804003 <strcat>:

char *
strcat(char *dst, const char *src)
{
  804003:	55                   	push   %rbp
  804004:	48 89 e5             	mov    %rsp,%rbp
  804007:	48 83 ec 20          	sub    $0x20,%rsp
  80400b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80400f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  804013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804017:	48 89 c7             	mov    %rax,%rdi
  80401a:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  804021:	00 00 00 
  804024:	ff d0                	callq  *%rax
  804026:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  804029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402c:	48 63 d0             	movslq %eax,%rdx
  80402f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804033:	48 01 c2             	add    %rax,%rdx
  804036:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403a:	48 89 c6             	mov    %rax,%rsi
  80403d:	48 89 d7             	mov    %rdx,%rdi
  804040:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  804047:	00 00 00 
  80404a:	ff d0                	callq  *%rax
	return dst;
  80404c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804050:	c9                   	leaveq 
  804051:	c3                   	retq   

0000000000804052 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  804052:	55                   	push   %rbp
  804053:	48 89 e5             	mov    %rsp,%rbp
  804056:	48 83 ec 28          	sub    $0x28,%rsp
  80405a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80405e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804062:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  804066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80406a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80406e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804075:	00 
  804076:	eb 2a                	jmp    8040a2 <strncpy+0x50>
		*dst++ = *src;
  804078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80407c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804080:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804084:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804088:	0f b6 12             	movzbl (%rdx),%edx
  80408b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80408d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804091:	0f b6 00             	movzbl (%rax),%eax
  804094:	84 c0                	test   %al,%al
  804096:	74 05                	je     80409d <strncpy+0x4b>
			src++;
  804098:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80409d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8040aa:	72 cc                	jb     804078 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8040ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8040b0:	c9                   	leaveq 
  8040b1:	c3                   	retq   

00000000008040b2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8040b2:	55                   	push   %rbp
  8040b3:	48 89 e5             	mov    %rsp,%rbp
  8040b6:	48 83 ec 28          	sub    $0x28,%rsp
  8040ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8040c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8040ce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040d3:	74 3d                	je     804112 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8040d5:	eb 1d                	jmp    8040f4 <strlcpy+0x42>
			*dst++ = *src++;
  8040d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8040df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8040e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040e7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8040eb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8040ef:	0f b6 12             	movzbl (%rdx),%edx
  8040f2:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8040f4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8040f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040fe:	74 0b                	je     80410b <strlcpy+0x59>
  804100:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804104:	0f b6 00             	movzbl (%rax),%eax
  804107:	84 c0                	test   %al,%al
  804109:	75 cc                	jne    8040d7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80410b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804112:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411a:	48 29 c2             	sub    %rax,%rdx
  80411d:	48 89 d0             	mov    %rdx,%rax
}
  804120:	c9                   	leaveq 
  804121:	c3                   	retq   

0000000000804122 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804122:	55                   	push   %rbp
  804123:	48 89 e5             	mov    %rsp,%rbp
  804126:	48 83 ec 10          	sub    $0x10,%rsp
  80412a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80412e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  804132:	eb 0a                	jmp    80413e <strcmp+0x1c>
		p++, q++;
  804134:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804139:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80413e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804142:	0f b6 00             	movzbl (%rax),%eax
  804145:	84 c0                	test   %al,%al
  804147:	74 12                	je     80415b <strcmp+0x39>
  804149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414d:	0f b6 10             	movzbl (%rax),%edx
  804150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804154:	0f b6 00             	movzbl (%rax),%eax
  804157:	38 c2                	cmp    %al,%dl
  804159:	74 d9                	je     804134 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80415b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80415f:	0f b6 00             	movzbl (%rax),%eax
  804162:	0f b6 d0             	movzbl %al,%edx
  804165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804169:	0f b6 00             	movzbl (%rax),%eax
  80416c:	0f b6 c0             	movzbl %al,%eax
  80416f:	29 c2                	sub    %eax,%edx
  804171:	89 d0                	mov    %edx,%eax
}
  804173:	c9                   	leaveq 
  804174:	c3                   	retq   

0000000000804175 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  804175:	55                   	push   %rbp
  804176:	48 89 e5             	mov    %rsp,%rbp
  804179:	48 83 ec 18          	sub    $0x18,%rsp
  80417d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804181:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804185:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  804189:	eb 0f                	jmp    80419a <strncmp+0x25>
		n--, p++, q++;
  80418b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  804190:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804195:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80419a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80419f:	74 1d                	je     8041be <strncmp+0x49>
  8041a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a5:	0f b6 00             	movzbl (%rax),%eax
  8041a8:	84 c0                	test   %al,%al
  8041aa:	74 12                	je     8041be <strncmp+0x49>
  8041ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b0:	0f b6 10             	movzbl (%rax),%edx
  8041b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b7:	0f b6 00             	movzbl (%rax),%eax
  8041ba:	38 c2                	cmp    %al,%dl
  8041bc:	74 cd                	je     80418b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8041be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041c3:	75 07                	jne    8041cc <strncmp+0x57>
		return 0;
  8041c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ca:	eb 18                	jmp    8041e4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8041cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d0:	0f b6 00             	movzbl (%rax),%eax
  8041d3:	0f b6 d0             	movzbl %al,%edx
  8041d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041da:	0f b6 00             	movzbl (%rax),%eax
  8041dd:	0f b6 c0             	movzbl %al,%eax
  8041e0:	29 c2                	sub    %eax,%edx
  8041e2:	89 d0                	mov    %edx,%eax
}
  8041e4:	c9                   	leaveq 
  8041e5:	c3                   	retq   

00000000008041e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8041e6:	55                   	push   %rbp
  8041e7:	48 89 e5             	mov    %rsp,%rbp
  8041ea:	48 83 ec 0c          	sub    $0xc,%rsp
  8041ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041f2:	89 f0                	mov    %esi,%eax
  8041f4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8041f7:	eb 17                	jmp    804210 <strchr+0x2a>
		if (*s == c)
  8041f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fd:	0f b6 00             	movzbl (%rax),%eax
  804200:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804203:	75 06                	jne    80420b <strchr+0x25>
			return (char *) s;
  804205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804209:	eb 15                	jmp    804220 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80420b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804214:	0f b6 00             	movzbl (%rax),%eax
  804217:	84 c0                	test   %al,%al
  804219:	75 de                	jne    8041f9 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80421b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804220:	c9                   	leaveq 
  804221:	c3                   	retq   

0000000000804222 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804222:	55                   	push   %rbp
  804223:	48 89 e5             	mov    %rsp,%rbp
  804226:	48 83 ec 0c          	sub    $0xc,%rsp
  80422a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80422e:	89 f0                	mov    %esi,%eax
  804230:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804233:	eb 13                	jmp    804248 <strfind+0x26>
		if (*s == c)
  804235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804239:	0f b6 00             	movzbl (%rax),%eax
  80423c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80423f:	75 02                	jne    804243 <strfind+0x21>
			break;
  804241:	eb 10                	jmp    804253 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  804243:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424c:	0f b6 00             	movzbl (%rax),%eax
  80424f:	84 c0                	test   %al,%al
  804251:	75 e2                	jne    804235 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  804253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804257:	c9                   	leaveq 
  804258:	c3                   	retq   

0000000000804259 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  804259:	55                   	push   %rbp
  80425a:	48 89 e5             	mov    %rsp,%rbp
  80425d:	48 83 ec 18          	sub    $0x18,%rsp
  804261:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804265:	89 75 f4             	mov    %esi,-0xc(%rbp)
  804268:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80426c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804271:	75 06                	jne    804279 <memset+0x20>
		return v;
  804273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804277:	eb 69                	jmp    8042e2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  804279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427d:	83 e0 03             	and    $0x3,%eax
  804280:	48 85 c0             	test   %rax,%rax
  804283:	75 48                	jne    8042cd <memset+0x74>
  804285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804289:	83 e0 03             	and    $0x3,%eax
  80428c:	48 85 c0             	test   %rax,%rax
  80428f:	75 3c                	jne    8042cd <memset+0x74>
		c &= 0xFF;
  804291:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  804298:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80429b:	c1 e0 18             	shl    $0x18,%eax
  80429e:	89 c2                	mov    %eax,%edx
  8042a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042a3:	c1 e0 10             	shl    $0x10,%eax
  8042a6:	09 c2                	or     %eax,%edx
  8042a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042ab:	c1 e0 08             	shl    $0x8,%eax
  8042ae:	09 d0                	or     %edx,%eax
  8042b0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8042b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042b7:	48 c1 e8 02          	shr    $0x2,%rax
  8042bb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8042be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042c5:	48 89 d7             	mov    %rdx,%rdi
  8042c8:	fc                   	cld    
  8042c9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8042cb:	eb 11                	jmp    8042de <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8042cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042d4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8042d8:	48 89 d7             	mov    %rdx,%rdi
  8042db:	fc                   	cld    
  8042dc:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8042de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042e2:	c9                   	leaveq 
  8042e3:	c3                   	retq   

00000000008042e4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8042e4:	55                   	push   %rbp
  8042e5:	48 89 e5             	mov    %rsp,%rbp
  8042e8:	48 83 ec 28          	sub    $0x28,%rsp
  8042ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8042f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804304:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  804308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80430c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804310:	0f 83 88 00 00 00    	jae    80439e <memmove+0xba>
  804316:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80431a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80431e:	48 01 d0             	add    %rdx,%rax
  804321:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804325:	76 77                	jbe    80439e <memmove+0xba>
		s += n;
  804327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80432b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80432f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804333:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80433b:	83 e0 03             	and    $0x3,%eax
  80433e:	48 85 c0             	test   %rax,%rax
  804341:	75 3b                	jne    80437e <memmove+0x9a>
  804343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804347:	83 e0 03             	and    $0x3,%eax
  80434a:	48 85 c0             	test   %rax,%rax
  80434d:	75 2f                	jne    80437e <memmove+0x9a>
  80434f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804353:	83 e0 03             	and    $0x3,%eax
  804356:	48 85 c0             	test   %rax,%rax
  804359:	75 23                	jne    80437e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80435b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80435f:	48 83 e8 04          	sub    $0x4,%rax
  804363:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804367:	48 83 ea 04          	sub    $0x4,%rdx
  80436b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80436f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  804373:	48 89 c7             	mov    %rax,%rdi
  804376:	48 89 d6             	mov    %rdx,%rsi
  804379:	fd                   	std    
  80437a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80437c:	eb 1d                	jmp    80439b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80437e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804382:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80438a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80438e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804392:	48 89 d7             	mov    %rdx,%rdi
  804395:	48 89 c1             	mov    %rax,%rcx
  804398:	fd                   	std    
  804399:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80439b:	fc                   	cld    
  80439c:	eb 57                	jmp    8043f5 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80439e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a2:	83 e0 03             	and    $0x3,%eax
  8043a5:	48 85 c0             	test   %rax,%rax
  8043a8:	75 36                	jne    8043e0 <memmove+0xfc>
  8043aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ae:	83 e0 03             	and    $0x3,%eax
  8043b1:	48 85 c0             	test   %rax,%rax
  8043b4:	75 2a                	jne    8043e0 <memmove+0xfc>
  8043b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ba:	83 e0 03             	and    $0x3,%eax
  8043bd:	48 85 c0             	test   %rax,%rax
  8043c0:	75 1e                	jne    8043e0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8043c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043c6:	48 c1 e8 02          	shr    $0x2,%rax
  8043ca:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8043cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043d5:	48 89 c7             	mov    %rax,%rdi
  8043d8:	48 89 d6             	mov    %rdx,%rsi
  8043db:	fc                   	cld    
  8043dc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8043de:	eb 15                	jmp    8043f5 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8043e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043e8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8043ec:	48 89 c7             	mov    %rax,%rdi
  8043ef:	48 89 d6             	mov    %rdx,%rsi
  8043f2:	fc                   	cld    
  8043f3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8043f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8043f9:	c9                   	leaveq 
  8043fa:	c3                   	retq   

00000000008043fb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8043fb:	55                   	push   %rbp
  8043fc:	48 89 e5             	mov    %rsp,%rbp
  8043ff:	48 83 ec 18          	sub    $0x18,%rsp
  804403:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804407:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80440b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80440f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804413:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80441b:	48 89 ce             	mov    %rcx,%rsi
  80441e:	48 89 c7             	mov    %rax,%rdi
  804421:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  804428:	00 00 00 
  80442b:	ff d0                	callq  *%rax
}
  80442d:	c9                   	leaveq 
  80442e:	c3                   	retq   

000000000080442f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80442f:	55                   	push   %rbp
  804430:	48 89 e5             	mov    %rsp,%rbp
  804433:	48 83 ec 28          	sub    $0x28,%rsp
  804437:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80443b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80443f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  804443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804447:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80444b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  804453:	eb 36                	jmp    80448b <memcmp+0x5c>
		if (*s1 != *s2)
  804455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804459:	0f b6 10             	movzbl (%rax),%edx
  80445c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804460:	0f b6 00             	movzbl (%rax),%eax
  804463:	38 c2                	cmp    %al,%dl
  804465:	74 1a                	je     804481 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  804467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80446b:	0f b6 00             	movzbl (%rax),%eax
  80446e:	0f b6 d0             	movzbl %al,%edx
  804471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804475:	0f b6 00             	movzbl (%rax),%eax
  804478:	0f b6 c0             	movzbl %al,%eax
  80447b:	29 c2                	sub    %eax,%edx
  80447d:	89 d0                	mov    %edx,%eax
  80447f:	eb 20                	jmp    8044a1 <memcmp+0x72>
		s1++, s2++;
  804481:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804486:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80448b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80448f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804493:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804497:	48 85 c0             	test   %rax,%rax
  80449a:	75 b9                	jne    804455 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80449c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044a1:	c9                   	leaveq 
  8044a2:	c3                   	retq   

00000000008044a3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8044a3:	55                   	push   %rbp
  8044a4:	48 89 e5             	mov    %rsp,%rbp
  8044a7:	48 83 ec 28          	sub    $0x28,%rsp
  8044ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8044b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8044b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044be:	48 01 d0             	add    %rdx,%rax
  8044c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8044c5:	eb 15                	jmp    8044dc <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8044c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044cb:	0f b6 10             	movzbl (%rax),%edx
  8044ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8044d1:	38 c2                	cmp    %al,%dl
  8044d3:	75 02                	jne    8044d7 <memfind+0x34>
			break;
  8044d5:	eb 0f                	jmp    8044e6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8044d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8044dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044e0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8044e4:	72 e1                	jb     8044c7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8044e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8044ea:	c9                   	leaveq 
  8044eb:	c3                   	retq   

00000000008044ec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8044ec:	55                   	push   %rbp
  8044ed:	48 89 e5             	mov    %rsp,%rbp
  8044f0:	48 83 ec 34          	sub    $0x34,%rsp
  8044f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044fc:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8044ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804506:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80450d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80450e:	eb 05                	jmp    804515 <strtol+0x29>
		s++;
  804510:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804519:	0f b6 00             	movzbl (%rax),%eax
  80451c:	3c 20                	cmp    $0x20,%al
  80451e:	74 f0                	je     804510 <strtol+0x24>
  804520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804524:	0f b6 00             	movzbl (%rax),%eax
  804527:	3c 09                	cmp    $0x9,%al
  804529:	74 e5                	je     804510 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80452b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80452f:	0f b6 00             	movzbl (%rax),%eax
  804532:	3c 2b                	cmp    $0x2b,%al
  804534:	75 07                	jne    80453d <strtol+0x51>
		s++;
  804536:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80453b:	eb 17                	jmp    804554 <strtol+0x68>
	else if (*s == '-')
  80453d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804541:	0f b6 00             	movzbl (%rax),%eax
  804544:	3c 2d                	cmp    $0x2d,%al
  804546:	75 0c                	jne    804554 <strtol+0x68>
		s++, neg = 1;
  804548:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80454d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  804554:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804558:	74 06                	je     804560 <strtol+0x74>
  80455a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80455e:	75 28                	jne    804588 <strtol+0x9c>
  804560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804564:	0f b6 00             	movzbl (%rax),%eax
  804567:	3c 30                	cmp    $0x30,%al
  804569:	75 1d                	jne    804588 <strtol+0x9c>
  80456b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80456f:	48 83 c0 01          	add    $0x1,%rax
  804573:	0f b6 00             	movzbl (%rax),%eax
  804576:	3c 78                	cmp    $0x78,%al
  804578:	75 0e                	jne    804588 <strtol+0x9c>
		s += 2, base = 16;
  80457a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80457f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  804586:	eb 2c                	jmp    8045b4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  804588:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80458c:	75 19                	jne    8045a7 <strtol+0xbb>
  80458e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804592:	0f b6 00             	movzbl (%rax),%eax
  804595:	3c 30                	cmp    $0x30,%al
  804597:	75 0e                	jne    8045a7 <strtol+0xbb>
		s++, base = 8;
  804599:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80459e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8045a5:	eb 0d                	jmp    8045b4 <strtol+0xc8>
	else if (base == 0)
  8045a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8045ab:	75 07                	jne    8045b4 <strtol+0xc8>
		base = 10;
  8045ad:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8045b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b8:	0f b6 00             	movzbl (%rax),%eax
  8045bb:	3c 2f                	cmp    $0x2f,%al
  8045bd:	7e 1d                	jle    8045dc <strtol+0xf0>
  8045bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045c3:	0f b6 00             	movzbl (%rax),%eax
  8045c6:	3c 39                	cmp    $0x39,%al
  8045c8:	7f 12                	jg     8045dc <strtol+0xf0>
			dig = *s - '0';
  8045ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ce:	0f b6 00             	movzbl (%rax),%eax
  8045d1:	0f be c0             	movsbl %al,%eax
  8045d4:	83 e8 30             	sub    $0x30,%eax
  8045d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045da:	eb 4e                	jmp    80462a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8045dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045e0:	0f b6 00             	movzbl (%rax),%eax
  8045e3:	3c 60                	cmp    $0x60,%al
  8045e5:	7e 1d                	jle    804604 <strtol+0x118>
  8045e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045eb:	0f b6 00             	movzbl (%rax),%eax
  8045ee:	3c 7a                	cmp    $0x7a,%al
  8045f0:	7f 12                	jg     804604 <strtol+0x118>
			dig = *s - 'a' + 10;
  8045f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f6:	0f b6 00             	movzbl (%rax),%eax
  8045f9:	0f be c0             	movsbl %al,%eax
  8045fc:	83 e8 57             	sub    $0x57,%eax
  8045ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804602:	eb 26                	jmp    80462a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804608:	0f b6 00             	movzbl (%rax),%eax
  80460b:	3c 40                	cmp    $0x40,%al
  80460d:	7e 48                	jle    804657 <strtol+0x16b>
  80460f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804613:	0f b6 00             	movzbl (%rax),%eax
  804616:	3c 5a                	cmp    $0x5a,%al
  804618:	7f 3d                	jg     804657 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80461a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461e:	0f b6 00             	movzbl (%rax),%eax
  804621:	0f be c0             	movsbl %al,%eax
  804624:	83 e8 37             	sub    $0x37,%eax
  804627:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80462a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80462d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804630:	7c 02                	jl     804634 <strtol+0x148>
			break;
  804632:	eb 23                	jmp    804657 <strtol+0x16b>
		s++, val = (val * base) + dig;
  804634:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804639:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80463c:	48 98                	cltq   
  80463e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  804643:	48 89 c2             	mov    %rax,%rdx
  804646:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804649:	48 98                	cltq   
  80464b:	48 01 d0             	add    %rdx,%rax
  80464e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  804652:	e9 5d ff ff ff       	jmpq   8045b4 <strtol+0xc8>

	if (endptr)
  804657:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80465c:	74 0b                	je     804669 <strtol+0x17d>
		*endptr = (char *) s;
  80465e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804662:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804666:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  804669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80466d:	74 09                	je     804678 <strtol+0x18c>
  80466f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804673:	48 f7 d8             	neg    %rax
  804676:	eb 04                	jmp    80467c <strtol+0x190>
  804678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80467c:	c9                   	leaveq 
  80467d:	c3                   	retq   

000000000080467e <strstr>:

char * strstr(const char *in, const char *str)
{
  80467e:	55                   	push   %rbp
  80467f:	48 89 e5             	mov    %rsp,%rbp
  804682:	48 83 ec 30          	sub    $0x30,%rsp
  804686:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80468a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80468e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804692:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804696:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80469a:	0f b6 00             	movzbl (%rax),%eax
  80469d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8046a0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8046a4:	75 06                	jne    8046ac <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8046a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046aa:	eb 6b                	jmp    804717 <strstr+0x99>

	len = strlen(str);
  8046ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046b0:	48 89 c7             	mov    %rax,%rdi
  8046b3:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  8046ba:	00 00 00 
  8046bd:	ff d0                	callq  *%rax
  8046bf:	48 98                	cltq   
  8046c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8046c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8046d1:	0f b6 00             	movzbl (%rax),%eax
  8046d4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8046d7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8046db:	75 07                	jne    8046e4 <strstr+0x66>
				return (char *) 0;
  8046dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e2:	eb 33                	jmp    804717 <strstr+0x99>
		} while (sc != c);
  8046e4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8046e8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8046eb:	75 d8                	jne    8046c5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8046ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046f1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8046f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f9:	48 89 ce             	mov    %rcx,%rsi
  8046fc:	48 89 c7             	mov    %rax,%rdi
  8046ff:	48 b8 75 41 80 00 00 	movabs $0x804175,%rax
  804706:	00 00 00 
  804709:	ff d0                	callq  *%rax
  80470b:	85 c0                	test   %eax,%eax
  80470d:	75 b6                	jne    8046c5 <strstr+0x47>

	return (char *) (in - 1);
  80470f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804713:	48 83 e8 01          	sub    $0x1,%rax
}
  804717:	c9                   	leaveq 
  804718:	c3                   	retq   

0000000000804719 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804719:	55                   	push   %rbp
  80471a:	48 89 e5             	mov    %rsp,%rbp
  80471d:	53                   	push   %rbx
  80471e:	48 83 ec 48          	sub    $0x48,%rsp
  804722:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804725:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804728:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80472c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804730:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804734:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804738:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80473b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80473f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804743:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804747:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80474b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80474f:	4c 89 c3             	mov    %r8,%rbx
  804752:	cd 30                	int    $0x30
  804754:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  804758:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80475c:	74 3e                	je     80479c <syscall+0x83>
  80475e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804763:	7e 37                	jle    80479c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  804765:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804769:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80476c:	49 89 d0             	mov    %rdx,%r8
  80476f:	89 c1                	mov    %eax,%ecx
  804771:	48 ba 08 73 80 00 00 	movabs $0x807308,%rdx
  804778:	00 00 00 
  80477b:	be 23 00 00 00       	mov    $0x23,%esi
  804780:	48 bf 25 73 80 00 00 	movabs $0x807325,%rdi
  804787:	00 00 00 
  80478a:	b8 00 00 00 00       	mov    $0x0,%eax
  80478f:	49 b9 bf 31 80 00 00 	movabs $0x8031bf,%r9
  804796:	00 00 00 
  804799:	41 ff d1             	callq  *%r9

	return ret;
  80479c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8047a0:	48 83 c4 48          	add    $0x48,%rsp
  8047a4:	5b                   	pop    %rbx
  8047a5:	5d                   	pop    %rbp
  8047a6:	c3                   	retq   

00000000008047a7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8047a7:	55                   	push   %rbp
  8047a8:	48 89 e5             	mov    %rsp,%rbp
  8047ab:	48 83 ec 20          	sub    $0x20,%rsp
  8047af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8047b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8047c6:	00 
  8047c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8047cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8047d3:	48 89 d1             	mov    %rdx,%rcx
  8047d6:	48 89 c2             	mov    %rax,%rdx
  8047d9:	be 00 00 00 00       	mov    $0x0,%esi
  8047de:	bf 00 00 00 00       	mov    $0x0,%edi
  8047e3:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  8047ea:	00 00 00 
  8047ed:	ff d0                	callq  *%rax
}
  8047ef:	c9                   	leaveq 
  8047f0:	c3                   	retq   

00000000008047f1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8047f1:	55                   	push   %rbp
  8047f2:	48 89 e5             	mov    %rsp,%rbp
  8047f5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8047f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804800:	00 
  804801:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804807:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80480d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804812:	ba 00 00 00 00       	mov    $0x0,%edx
  804817:	be 00 00 00 00       	mov    $0x0,%esi
  80481c:	bf 01 00 00 00       	mov    $0x1,%edi
  804821:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
}
  80482d:	c9                   	leaveq 
  80482e:	c3                   	retq   

000000000080482f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80482f:	55                   	push   %rbp
  804830:	48 89 e5             	mov    %rsp,%rbp
  804833:	48 83 ec 10          	sub    $0x10,%rsp
  804837:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80483a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80483d:	48 98                	cltq   
  80483f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804846:	00 
  804847:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80484d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804853:	b9 00 00 00 00       	mov    $0x0,%ecx
  804858:	48 89 c2             	mov    %rax,%rdx
  80485b:	be 01 00 00 00       	mov    $0x1,%esi
  804860:	bf 03 00 00 00       	mov    $0x3,%edi
  804865:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  80486c:	00 00 00 
  80486f:	ff d0                	callq  *%rax
}
  804871:	c9                   	leaveq 
  804872:	c3                   	retq   

0000000000804873 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804873:	55                   	push   %rbp
  804874:	48 89 e5             	mov    %rsp,%rbp
  804877:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80487b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804882:	00 
  804883:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804889:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80488f:	b9 00 00 00 00       	mov    $0x0,%ecx
  804894:	ba 00 00 00 00       	mov    $0x0,%edx
  804899:	be 00 00 00 00       	mov    $0x0,%esi
  80489e:	bf 02 00 00 00       	mov    $0x2,%edi
  8048a3:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  8048aa:	00 00 00 
  8048ad:	ff d0                	callq  *%rax
}
  8048af:	c9                   	leaveq 
  8048b0:	c3                   	retq   

00000000008048b1 <sys_yield>:

void
sys_yield(void)
{
  8048b1:	55                   	push   %rbp
  8048b2:	48 89 e5             	mov    %rsp,%rbp
  8048b5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8048b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048c0:	00 
  8048c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8048d7:	be 00 00 00 00       	mov    $0x0,%esi
  8048dc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8048e1:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  8048e8:	00 00 00 
  8048eb:	ff d0                	callq  *%rax
}
  8048ed:	c9                   	leaveq 
  8048ee:	c3                   	retq   

00000000008048ef <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8048ef:	55                   	push   %rbp
  8048f0:	48 89 e5             	mov    %rsp,%rbp
  8048f3:	48 83 ec 20          	sub    $0x20,%rsp
  8048f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8048fe:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804901:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804904:	48 63 c8             	movslq %eax,%rcx
  804907:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80490b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80490e:	48 98                	cltq   
  804910:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804917:	00 
  804918:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80491e:	49 89 c8             	mov    %rcx,%r8
  804921:	48 89 d1             	mov    %rdx,%rcx
  804924:	48 89 c2             	mov    %rax,%rdx
  804927:	be 01 00 00 00       	mov    $0x1,%esi
  80492c:	bf 04 00 00 00       	mov    $0x4,%edi
  804931:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804938:	00 00 00 
  80493b:	ff d0                	callq  *%rax
}
  80493d:	c9                   	leaveq 
  80493e:	c3                   	retq   

000000000080493f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80493f:	55                   	push   %rbp
  804940:	48 89 e5             	mov    %rsp,%rbp
  804943:	48 83 ec 30          	sub    $0x30,%rsp
  804947:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80494a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80494e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804951:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804955:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804959:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80495c:	48 63 c8             	movslq %eax,%rcx
  80495f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804963:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804966:	48 63 f0             	movslq %eax,%rsi
  804969:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80496d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804970:	48 98                	cltq   
  804972:	48 89 0c 24          	mov    %rcx,(%rsp)
  804976:	49 89 f9             	mov    %rdi,%r9
  804979:	49 89 f0             	mov    %rsi,%r8
  80497c:	48 89 d1             	mov    %rdx,%rcx
  80497f:	48 89 c2             	mov    %rax,%rdx
  804982:	be 01 00 00 00       	mov    $0x1,%esi
  804987:	bf 05 00 00 00       	mov    $0x5,%edi
  80498c:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804993:	00 00 00 
  804996:	ff d0                	callq  *%rax
}
  804998:	c9                   	leaveq 
  804999:	c3                   	retq   

000000000080499a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80499a:	55                   	push   %rbp
  80499b:	48 89 e5             	mov    %rsp,%rbp
  80499e:	48 83 ec 20          	sub    $0x20,%rsp
  8049a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8049a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049b0:	48 98                	cltq   
  8049b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8049b9:	00 
  8049ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049c6:	48 89 d1             	mov    %rdx,%rcx
  8049c9:	48 89 c2             	mov    %rax,%rdx
  8049cc:	be 01 00 00 00       	mov    $0x1,%esi
  8049d1:	bf 06 00 00 00       	mov    $0x6,%edi
  8049d6:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  8049dd:	00 00 00 
  8049e0:	ff d0                	callq  *%rax
}
  8049e2:	c9                   	leaveq 
  8049e3:	c3                   	retq   

00000000008049e4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8049e4:	55                   	push   %rbp
  8049e5:	48 89 e5             	mov    %rsp,%rbp
  8049e8:	48 83 ec 10          	sub    $0x10,%rsp
  8049ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049ef:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8049f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049f5:	48 63 d0             	movslq %eax,%rdx
  8049f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049fb:	48 98                	cltq   
  8049fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a04:	00 
  804a05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a11:	48 89 d1             	mov    %rdx,%rcx
  804a14:	48 89 c2             	mov    %rax,%rdx
  804a17:	be 01 00 00 00       	mov    $0x1,%esi
  804a1c:	bf 08 00 00 00       	mov    $0x8,%edi
  804a21:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804a28:	00 00 00 
  804a2b:	ff d0                	callq  *%rax
}
  804a2d:	c9                   	leaveq 
  804a2e:	c3                   	retq   

0000000000804a2f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804a2f:	55                   	push   %rbp
  804a30:	48 89 e5             	mov    %rsp,%rbp
  804a33:	48 83 ec 20          	sub    $0x20,%rsp
  804a37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804a3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a45:	48 98                	cltq   
  804a47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a4e:	00 
  804a4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a5b:	48 89 d1             	mov    %rdx,%rcx
  804a5e:	48 89 c2             	mov    %rax,%rdx
  804a61:	be 01 00 00 00       	mov    $0x1,%esi
  804a66:	bf 09 00 00 00       	mov    $0x9,%edi
  804a6b:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804a72:	00 00 00 
  804a75:	ff d0                	callq  *%rax
}
  804a77:	c9                   	leaveq 
  804a78:	c3                   	retq   

0000000000804a79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804a79:	55                   	push   %rbp
  804a7a:	48 89 e5             	mov    %rsp,%rbp
  804a7d:	48 83 ec 20          	sub    $0x20,%rsp
  804a81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804a88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a8f:	48 98                	cltq   
  804a91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a98:	00 
  804a99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804aa5:	48 89 d1             	mov    %rdx,%rcx
  804aa8:	48 89 c2             	mov    %rax,%rdx
  804aab:	be 01 00 00 00       	mov    $0x1,%esi
  804ab0:	bf 0a 00 00 00       	mov    $0xa,%edi
  804ab5:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804abc:	00 00 00 
  804abf:	ff d0                	callq  *%rax
}
  804ac1:	c9                   	leaveq 
  804ac2:	c3                   	retq   

0000000000804ac3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804ac3:	55                   	push   %rbp
  804ac4:	48 89 e5             	mov    %rsp,%rbp
  804ac7:	48 83 ec 20          	sub    $0x20,%rsp
  804acb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ace:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ad2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804ad6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804ad9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804adc:	48 63 f0             	movslq %eax,%rsi
  804adf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ae6:	48 98                	cltq   
  804ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804aec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804af3:	00 
  804af4:	49 89 f1             	mov    %rsi,%r9
  804af7:	49 89 c8             	mov    %rcx,%r8
  804afa:	48 89 d1             	mov    %rdx,%rcx
  804afd:	48 89 c2             	mov    %rax,%rdx
  804b00:	be 00 00 00 00       	mov    $0x0,%esi
  804b05:	bf 0c 00 00 00       	mov    $0xc,%edi
  804b0a:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804b11:	00 00 00 
  804b14:	ff d0                	callq  *%rax
}
  804b16:	c9                   	leaveq 
  804b17:	c3                   	retq   

0000000000804b18 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804b18:	55                   	push   %rbp
  804b19:	48 89 e5             	mov    %rsp,%rbp
  804b1c:	48 83 ec 10          	sub    $0x10,%rsp
  804b20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b2f:	00 
  804b30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  804b41:	48 89 c2             	mov    %rax,%rdx
  804b44:	be 01 00 00 00       	mov    $0x1,%esi
  804b49:	bf 0d 00 00 00       	mov    $0xd,%edi
  804b4e:	48 b8 19 47 80 00 00 	movabs $0x804719,%rax
  804b55:	00 00 00 
  804b58:	ff d0                	callq  *%rax
}
  804b5a:	c9                   	leaveq 
  804b5b:	c3                   	retq   

0000000000804b5c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804b5c:	55                   	push   %rbp
  804b5d:	48 89 e5             	mov    %rsp,%rbp
  804b60:	48 83 ec 10          	sub    $0x10,%rsp
  804b64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804b68:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804b6f:	00 00 00 
  804b72:	48 8b 00             	mov    (%rax),%rax
  804b75:	48 85 c0             	test   %rax,%rax
  804b78:	75 49                	jne    804bc3 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  804b7a:	ba 07 00 00 00       	mov    $0x7,%edx
  804b7f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804b84:	bf 00 00 00 00       	mov    $0x0,%edi
  804b89:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  804b90:	00 00 00 
  804b93:	ff d0                	callq  *%rax
  804b95:	85 c0                	test   %eax,%eax
  804b97:	79 2a                	jns    804bc3 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  804b99:	48 ba 38 73 80 00 00 	movabs $0x807338,%rdx
  804ba0:	00 00 00 
  804ba3:	be 21 00 00 00       	mov    $0x21,%esi
  804ba8:	48 bf 63 73 80 00 00 	movabs $0x807363,%rdi
  804baf:	00 00 00 
  804bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  804bb7:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  804bbe:	00 00 00 
  804bc1:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804bc3:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804bca:	00 00 00 
  804bcd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804bd1:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  804bd4:	48 be 1f 4c 80 00 00 	movabs $0x804c1f,%rsi
  804bdb:	00 00 00 
  804bde:	bf 00 00 00 00       	mov    $0x0,%edi
  804be3:	48 b8 79 4a 80 00 00 	movabs $0x804a79,%rax
  804bea:	00 00 00 
  804bed:	ff d0                	callq  *%rax
  804bef:	85 c0                	test   %eax,%eax
  804bf1:	79 2a                	jns    804c1d <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  804bf3:	48 ba 78 73 80 00 00 	movabs $0x807378,%rdx
  804bfa:	00 00 00 
  804bfd:	be 27 00 00 00       	mov    $0x27,%esi
  804c02:	48 bf 63 73 80 00 00 	movabs $0x807363,%rdi
  804c09:	00 00 00 
  804c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  804c11:	48 b9 bf 31 80 00 00 	movabs $0x8031bf,%rcx
  804c18:	00 00 00 
  804c1b:	ff d1                	callq  *%rcx
}
  804c1d:	c9                   	leaveq 
  804c1e:	c3                   	retq   

0000000000804c1f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804c1f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804c22:	48 a1 20 20 81 00 00 	movabs 0x812020,%rax
  804c29:	00 00 00 
call *%rax
  804c2c:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  804c2e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804c35:	00 
    movq 152(%rsp), %rcx
  804c36:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804c3d:	00 
    subq $8, %rcx
  804c3e:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  804c42:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  804c45:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804c4c:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  804c4d:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804c51:	4c 8b 3c 24          	mov    (%rsp),%r15
  804c55:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804c5a:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804c5f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804c64:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804c69:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804c6e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804c73:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804c78:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804c7d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804c82:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804c87:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804c8c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804c91:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804c96:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804c9b:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  804c9f:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  804ca3:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  804ca4:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  804ca5:	c3                   	retq   

0000000000804ca6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804ca6:	55                   	push   %rbp
  804ca7:	48 89 e5             	mov    %rsp,%rbp
  804caa:	48 83 ec 30          	sub    $0x30,%rsp
  804cae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804cb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804cb6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  804cba:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804cbf:	75 0e                	jne    804ccf <ipc_recv+0x29>
        pg = (void *)UTOP;
  804cc1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804cc8:	00 00 00 
  804ccb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  804ccf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cd3:	48 89 c7             	mov    %rax,%rdi
  804cd6:	48 b8 18 4b 80 00 00 	movabs $0x804b18,%rax
  804cdd:	00 00 00 
  804ce0:	ff d0                	callq  *%rax
  804ce2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ce9:	79 27                	jns    804d12 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  804ceb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804cf0:	74 0a                	je     804cfc <ipc_recv+0x56>
            *from_env_store = 0;
  804cf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cf6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  804cfc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d01:	74 0a                	je     804d0d <ipc_recv+0x67>
            *perm_store = 0;
  804d03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d07:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  804d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d10:	eb 53                	jmp    804d65 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  804d12:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d17:	74 19                	je     804d32 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  804d19:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d20:	00 00 00 
  804d23:	48 8b 00             	mov    (%rax),%rax
  804d26:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804d2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d30:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  804d32:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d37:	74 19                	je     804d52 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  804d39:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d40:	00 00 00 
  804d43:	48 8b 00             	mov    (%rax),%rax
  804d46:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804d4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d50:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  804d52:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d59:	00 00 00 
  804d5c:	48 8b 00             	mov    (%rax),%rax
  804d5f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  804d65:	c9                   	leaveq 
  804d66:	c3                   	retq   

0000000000804d67 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d67:	55                   	push   %rbp
  804d68:	48 89 e5             	mov    %rsp,%rbp
  804d6b:	48 83 ec 30          	sub    $0x30,%rsp
  804d6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804d72:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804d75:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804d79:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  804d7c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d81:	75 0e                	jne    804d91 <ipc_send+0x2a>
        pg = (void *)UTOP;
  804d83:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d8a:	00 00 00 
  804d8d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  804d91:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804d94:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804d97:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804d9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d9e:	89 c7                	mov    %eax,%edi
  804da0:	48 b8 c3 4a 80 00 00 	movabs $0x804ac3,%rax
  804da7:	00 00 00 
  804daa:	ff d0                	callq  *%rax
  804dac:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  804daf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804db3:	79 36                	jns    804deb <ipc_send+0x84>
  804db5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804db9:	74 30                	je     804deb <ipc_send+0x84>
            panic("ipc_send: %e", r);
  804dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dbe:	89 c1                	mov    %eax,%ecx
  804dc0:	48 ba af 73 80 00 00 	movabs $0x8073af,%rdx
  804dc7:	00 00 00 
  804dca:	be 49 00 00 00       	mov    $0x49,%esi
  804dcf:	48 bf bc 73 80 00 00 	movabs $0x8073bc,%rdi
  804dd6:	00 00 00 
  804dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  804dde:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  804de5:	00 00 00 
  804de8:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  804deb:	48 b8 b1 48 80 00 00 	movabs $0x8048b1,%rax
  804df2:	00 00 00 
  804df5:	ff d0                	callq  *%rax
    } while(r != 0);
  804df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804dfb:	75 94                	jne    804d91 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  804dfd:	c9                   	leaveq 
  804dfe:	c3                   	retq   

0000000000804dff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804dff:	55                   	push   %rbp
  804e00:	48 89 e5             	mov    %rsp,%rbp
  804e03:	48 83 ec 14          	sub    $0x14,%rsp
  804e07:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804e0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e11:	eb 5e                	jmp    804e71 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804e13:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804e1a:	00 00 00 
  804e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e20:	48 63 d0             	movslq %eax,%rdx
  804e23:	48 89 d0             	mov    %rdx,%rax
  804e26:	48 c1 e0 03          	shl    $0x3,%rax
  804e2a:	48 01 d0             	add    %rdx,%rax
  804e2d:	48 c1 e0 05          	shl    $0x5,%rax
  804e31:	48 01 c8             	add    %rcx,%rax
  804e34:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804e3a:	8b 00                	mov    (%rax),%eax
  804e3c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e3f:	75 2c                	jne    804e6d <ipc_find_env+0x6e>
			return envs[i].env_id;
  804e41:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804e48:	00 00 00 
  804e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e4e:	48 63 d0             	movslq %eax,%rdx
  804e51:	48 89 d0             	mov    %rdx,%rax
  804e54:	48 c1 e0 03          	shl    $0x3,%rax
  804e58:	48 01 d0             	add    %rdx,%rax
  804e5b:	48 c1 e0 05          	shl    $0x5,%rax
  804e5f:	48 01 c8             	add    %rcx,%rax
  804e62:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804e68:	8b 40 08             	mov    0x8(%rax),%eax
  804e6b:	eb 12                	jmp    804e7f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804e6d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804e71:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804e78:	7e 99                	jle    804e13 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e7f:	c9                   	leaveq 
  804e80:	c3                   	retq   

0000000000804e81 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  804e81:	55                   	push   %rbp
  804e82:	48 89 e5             	mov    %rsp,%rbp
  804e85:	48 83 ec 08          	sub    $0x8,%rsp
  804e89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  804e8d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804e91:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  804e98:	ff ff ff 
  804e9b:	48 01 d0             	add    %rdx,%rax
  804e9e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  804ea2:	c9                   	leaveq 
  804ea3:	c3                   	retq   

0000000000804ea4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  804ea4:	55                   	push   %rbp
  804ea5:	48 89 e5             	mov    %rsp,%rbp
  804ea8:	48 83 ec 08          	sub    $0x8,%rsp
  804eac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  804eb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804eb4:	48 89 c7             	mov    %rax,%rdi
  804eb7:	48 b8 81 4e 80 00 00 	movabs $0x804e81,%rax
  804ebe:	00 00 00 
  804ec1:	ff d0                	callq  *%rax
  804ec3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  804ec9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  804ecd:	c9                   	leaveq 
  804ece:	c3                   	retq   

0000000000804ecf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  804ecf:	55                   	push   %rbp
  804ed0:	48 89 e5             	mov    %rsp,%rbp
  804ed3:	48 83 ec 18          	sub    $0x18,%rsp
  804ed7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804edb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ee2:	eb 6b                	jmp    804f4f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  804ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ee7:	48 98                	cltq   
  804ee9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804eef:	48 c1 e0 0c          	shl    $0xc,%rax
  804ef3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  804ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804efb:	48 c1 e8 15          	shr    $0x15,%rax
  804eff:	48 89 c2             	mov    %rax,%rdx
  804f02:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804f09:	01 00 00 
  804f0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f10:	83 e0 01             	and    $0x1,%eax
  804f13:	48 85 c0             	test   %rax,%rax
  804f16:	74 21                	je     804f39 <fd_alloc+0x6a>
  804f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f1c:	48 c1 e8 0c          	shr    $0xc,%rax
  804f20:	48 89 c2             	mov    %rax,%rdx
  804f23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f2a:	01 00 00 
  804f2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f31:	83 e0 01             	and    $0x1,%eax
  804f34:	48 85 c0             	test   %rax,%rax
  804f37:	75 12                	jne    804f4b <fd_alloc+0x7c>
			*fd_store = fd;
  804f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f41:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  804f44:	b8 00 00 00 00       	mov    $0x0,%eax
  804f49:	eb 1a                	jmp    804f65 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804f4b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f4f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  804f53:	7e 8f                	jle    804ee4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  804f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f59:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  804f60:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  804f65:	c9                   	leaveq 
  804f66:	c3                   	retq   

0000000000804f67 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  804f67:	55                   	push   %rbp
  804f68:	48 89 e5             	mov    %rsp,%rbp
  804f6b:	48 83 ec 20          	sub    $0x20,%rsp
  804f6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804f72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  804f76:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f7a:	78 06                	js     804f82 <fd_lookup+0x1b>
  804f7c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  804f80:	7e 07                	jle    804f89 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804f82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804f87:	eb 6c                	jmp    804ff5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  804f89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f8c:	48 98                	cltq   
  804f8e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804f94:	48 c1 e0 0c          	shl    $0xc,%rax
  804f98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  804f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fa0:	48 c1 e8 15          	shr    $0x15,%rax
  804fa4:	48 89 c2             	mov    %rax,%rdx
  804fa7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804fae:	01 00 00 
  804fb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fb5:	83 e0 01             	and    $0x1,%eax
  804fb8:	48 85 c0             	test   %rax,%rax
  804fbb:	74 21                	je     804fde <fd_lookup+0x77>
  804fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fc1:	48 c1 e8 0c          	shr    $0xc,%rax
  804fc5:	48 89 c2             	mov    %rax,%rdx
  804fc8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804fcf:	01 00 00 
  804fd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fd6:	83 e0 01             	and    $0x1,%eax
  804fd9:	48 85 c0             	test   %rax,%rax
  804fdc:	75 07                	jne    804fe5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804fde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804fe3:	eb 10                	jmp    804ff5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  804fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804fe9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804fed:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  804ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ff5:	c9                   	leaveq 
  804ff6:	c3                   	retq   

0000000000804ff7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  804ff7:	55                   	push   %rbp
  804ff8:	48 89 e5             	mov    %rsp,%rbp
  804ffb:	48 83 ec 30          	sub    $0x30,%rsp
  804fff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805003:	89 f0                	mov    %esi,%eax
  805005:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  805008:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80500c:	48 89 c7             	mov    %rax,%rdi
  80500f:	48 b8 81 4e 80 00 00 	movabs $0x804e81,%rax
  805016:	00 00 00 
  805019:	ff d0                	callq  *%rax
  80501b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80501f:	48 89 d6             	mov    %rdx,%rsi
  805022:	89 c7                	mov    %eax,%edi
  805024:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  80502b:	00 00 00 
  80502e:	ff d0                	callq  *%rax
  805030:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805033:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805037:	78 0a                	js     805043 <fd_close+0x4c>
	    || fd != fd2)
  805039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80503d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  805041:	74 12                	je     805055 <fd_close+0x5e>
		return (must_exist ? r : 0);
  805043:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  805047:	74 05                	je     80504e <fd_close+0x57>
  805049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80504c:	eb 05                	jmp    805053 <fd_close+0x5c>
  80504e:	b8 00 00 00 00       	mov    $0x0,%eax
  805053:	eb 69                	jmp    8050be <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  805055:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805059:	8b 00                	mov    (%rax),%eax
  80505b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80505f:	48 89 d6             	mov    %rdx,%rsi
  805062:	89 c7                	mov    %eax,%edi
  805064:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80506b:	00 00 00 
  80506e:	ff d0                	callq  *%rax
  805070:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805073:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805077:	78 2a                	js     8050a3 <fd_close+0xac>
		if (dev->dev_close)
  805079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80507d:	48 8b 40 20          	mov    0x20(%rax),%rax
  805081:	48 85 c0             	test   %rax,%rax
  805084:	74 16                	je     80509c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  805086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80508a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80508e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805092:	48 89 d7             	mov    %rdx,%rdi
  805095:	ff d0                	callq  *%rax
  805097:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80509a:	eb 07                	jmp    8050a3 <fd_close+0xac>
		else
			r = 0;
  80509c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8050a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050a7:	48 89 c6             	mov    %rax,%rsi
  8050aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8050af:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  8050b6:	00 00 00 
  8050b9:	ff d0                	callq  *%rax
	return r;
  8050bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8050be:	c9                   	leaveq 
  8050bf:	c3                   	retq   

00000000008050c0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8050c0:	55                   	push   %rbp
  8050c1:	48 89 e5             	mov    %rsp,%rbp
  8050c4:	48 83 ec 20          	sub    $0x20,%rsp
  8050c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8050cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8050cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8050d6:	eb 41                	jmp    805119 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8050d8:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8050df:	00 00 00 
  8050e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8050e5:	48 63 d2             	movslq %edx,%rdx
  8050e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050ec:	8b 00                	mov    (%rax),%eax
  8050ee:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8050f1:	75 22                	jne    805115 <dev_lookup+0x55>
			*dev = devtab[i];
  8050f3:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8050fa:	00 00 00 
  8050fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805100:	48 63 d2             	movslq %edx,%rdx
  805103:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  805107:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80510b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80510e:	b8 00 00 00 00       	mov    $0x0,%eax
  805113:	eb 60                	jmp    805175 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  805115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805119:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  805120:	00 00 00 
  805123:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805126:	48 63 d2             	movslq %edx,%rdx
  805129:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80512d:	48 85 c0             	test   %rax,%rax
  805130:	75 a6                	jne    8050d8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  805132:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805139:	00 00 00 
  80513c:	48 8b 00             	mov    (%rax),%rax
  80513f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805145:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805148:	89 c6                	mov    %eax,%esi
  80514a:	48 bf c8 73 80 00 00 	movabs $0x8073c8,%rdi
  805151:	00 00 00 
  805154:	b8 00 00 00 00       	mov    $0x0,%eax
  805159:	48 b9 f8 33 80 00 00 	movabs $0x8033f8,%rcx
  805160:	00 00 00 
  805163:	ff d1                	callq  *%rcx
	*dev = 0;
  805165:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805169:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  805170:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805175:	c9                   	leaveq 
  805176:	c3                   	retq   

0000000000805177 <close>:

int
close(int fdnum)
{
  805177:	55                   	push   %rbp
  805178:	48 89 e5             	mov    %rsp,%rbp
  80517b:	48 83 ec 20          	sub    $0x20,%rsp
  80517f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805182:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805186:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805189:	48 89 d6             	mov    %rdx,%rsi
  80518c:	89 c7                	mov    %eax,%edi
  80518e:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  805195:	00 00 00 
  805198:	ff d0                	callq  *%rax
  80519a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80519d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051a1:	79 05                	jns    8051a8 <close+0x31>
		return r;
  8051a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051a6:	eb 18                	jmp    8051c0 <close+0x49>
	else
		return fd_close(fd, 1);
  8051a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051ac:	be 01 00 00 00       	mov    $0x1,%esi
  8051b1:	48 89 c7             	mov    %rax,%rdi
  8051b4:	48 b8 f7 4f 80 00 00 	movabs $0x804ff7,%rax
  8051bb:	00 00 00 
  8051be:	ff d0                	callq  *%rax
}
  8051c0:	c9                   	leaveq 
  8051c1:	c3                   	retq   

00000000008051c2 <close_all>:

void
close_all(void)
{
  8051c2:	55                   	push   %rbp
  8051c3:	48 89 e5             	mov    %rsp,%rbp
  8051c6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8051ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8051d1:	eb 15                	jmp    8051e8 <close_all+0x26>
		close(i);
  8051d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051d6:	89 c7                	mov    %eax,%edi
  8051d8:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  8051df:	00 00 00 
  8051e2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8051e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8051e8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8051ec:	7e e5                	jle    8051d3 <close_all+0x11>
		close(i);
}
  8051ee:	c9                   	leaveq 
  8051ef:	c3                   	retq   

00000000008051f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8051f0:	55                   	push   %rbp
  8051f1:	48 89 e5             	mov    %rsp,%rbp
  8051f4:	48 83 ec 40          	sub    $0x40,%rsp
  8051f8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8051fb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8051fe:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  805202:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805205:	48 89 d6             	mov    %rdx,%rsi
  805208:	89 c7                	mov    %eax,%edi
  80520a:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  805211:	00 00 00 
  805214:	ff d0                	callq  *%rax
  805216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80521d:	79 08                	jns    805227 <dup+0x37>
		return r;
  80521f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805222:	e9 70 01 00 00       	jmpq   805397 <dup+0x1a7>
	close(newfdnum);
  805227:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80522a:	89 c7                	mov    %eax,%edi
  80522c:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805233:	00 00 00 
  805236:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805238:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80523b:	48 98                	cltq   
  80523d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805243:	48 c1 e0 0c          	shl    $0xc,%rax
  805247:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80524b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80524f:	48 89 c7             	mov    %rax,%rdi
  805252:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  805259:	00 00 00 
  80525c:	ff d0                	callq  *%rax
  80525e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  805262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805266:	48 89 c7             	mov    %rax,%rdi
  805269:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  805270:	00 00 00 
  805273:	ff d0                	callq  *%rax
  805275:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80527d:	48 c1 e8 15          	shr    $0x15,%rax
  805281:	48 89 c2             	mov    %rax,%rdx
  805284:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80528b:	01 00 00 
  80528e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805292:	83 e0 01             	and    $0x1,%eax
  805295:	48 85 c0             	test   %rax,%rax
  805298:	74 73                	je     80530d <dup+0x11d>
  80529a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80529e:	48 c1 e8 0c          	shr    $0xc,%rax
  8052a2:	48 89 c2             	mov    %rax,%rdx
  8052a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052ac:	01 00 00 
  8052af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052b3:	83 e0 01             	and    $0x1,%eax
  8052b6:	48 85 c0             	test   %rax,%rax
  8052b9:	74 52                	je     80530d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8052bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8052c3:	48 89 c2             	mov    %rax,%rdx
  8052c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052cd:	01 00 00 
  8052d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8052d9:	89 c1                	mov    %eax,%ecx
  8052db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8052df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052e3:	41 89 c8             	mov    %ecx,%r8d
  8052e6:	48 89 d1             	mov    %rdx,%rcx
  8052e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8052ee:	48 89 c6             	mov    %rax,%rsi
  8052f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8052f6:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  8052fd:	00 00 00 
  805300:	ff d0                	callq  *%rax
  805302:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805305:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805309:	79 02                	jns    80530d <dup+0x11d>
			goto err;
  80530b:	eb 57                	jmp    805364 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80530d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805311:	48 c1 e8 0c          	shr    $0xc,%rax
  805315:	48 89 c2             	mov    %rax,%rdx
  805318:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80531f:	01 00 00 
  805322:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805326:	25 07 0e 00 00       	and    $0xe07,%eax
  80532b:	89 c1                	mov    %eax,%ecx
  80532d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805331:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805335:	41 89 c8             	mov    %ecx,%r8d
  805338:	48 89 d1             	mov    %rdx,%rcx
  80533b:	ba 00 00 00 00       	mov    $0x0,%edx
  805340:	48 89 c6             	mov    %rax,%rsi
  805343:	bf 00 00 00 00       	mov    $0x0,%edi
  805348:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  80534f:	00 00 00 
  805352:	ff d0                	callq  *%rax
  805354:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805357:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80535b:	79 02                	jns    80535f <dup+0x16f>
		goto err;
  80535d:	eb 05                	jmp    805364 <dup+0x174>

	return newfdnum;
  80535f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805362:	eb 33                	jmp    805397 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  805364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805368:	48 89 c6             	mov    %rax,%rsi
  80536b:	bf 00 00 00 00       	mov    $0x0,%edi
  805370:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  805377:	00 00 00 
  80537a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80537c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805380:	48 89 c6             	mov    %rax,%rsi
  805383:	bf 00 00 00 00       	mov    $0x0,%edi
  805388:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  80538f:	00 00 00 
  805392:	ff d0                	callq  *%rax
	return r;
  805394:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805397:	c9                   	leaveq 
  805398:	c3                   	retq   

0000000000805399 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  805399:	55                   	push   %rbp
  80539a:	48 89 e5             	mov    %rsp,%rbp
  80539d:	48 83 ec 40          	sub    $0x40,%rsp
  8053a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8053a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8053a8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8053ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8053b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8053b3:	48 89 d6             	mov    %rdx,%rsi
  8053b6:	89 c7                	mov    %eax,%edi
  8053b8:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  8053bf:	00 00 00 
  8053c2:	ff d0                	callq  *%rax
  8053c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053cb:	78 24                	js     8053f1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8053cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053d1:	8b 00                	mov    (%rax),%eax
  8053d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8053d7:	48 89 d6             	mov    %rdx,%rsi
  8053da:	89 c7                	mov    %eax,%edi
  8053dc:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8053e3:	00 00 00 
  8053e6:	ff d0                	callq  *%rax
  8053e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053ef:	79 05                	jns    8053f6 <read+0x5d>
		return r;
  8053f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053f4:	eb 76                	jmp    80546c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8053f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053fa:	8b 40 08             	mov    0x8(%rax),%eax
  8053fd:	83 e0 03             	and    $0x3,%eax
  805400:	83 f8 01             	cmp    $0x1,%eax
  805403:	75 3a                	jne    80543f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805405:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80540c:	00 00 00 
  80540f:	48 8b 00             	mov    (%rax),%rax
  805412:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805418:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80541b:	89 c6                	mov    %eax,%esi
  80541d:	48 bf e7 73 80 00 00 	movabs $0x8073e7,%rdi
  805424:	00 00 00 
  805427:	b8 00 00 00 00       	mov    $0x0,%eax
  80542c:	48 b9 f8 33 80 00 00 	movabs $0x8033f8,%rcx
  805433:	00 00 00 
  805436:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80543d:	eb 2d                	jmp    80546c <read+0xd3>
	}
	if (!dev->dev_read)
  80543f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805443:	48 8b 40 10          	mov    0x10(%rax),%rax
  805447:	48 85 c0             	test   %rax,%rax
  80544a:	75 07                	jne    805453 <read+0xba>
		return -E_NOT_SUPP;
  80544c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805451:	eb 19                	jmp    80546c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805457:	48 8b 40 10          	mov    0x10(%rax),%rax
  80545b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80545f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805463:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805467:	48 89 cf             	mov    %rcx,%rdi
  80546a:	ff d0                	callq  *%rax
}
  80546c:	c9                   	leaveq 
  80546d:	c3                   	retq   

000000000080546e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80546e:	55                   	push   %rbp
  80546f:	48 89 e5             	mov    %rsp,%rbp
  805472:	48 83 ec 30          	sub    $0x30,%rsp
  805476:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805479:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80547d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805488:	eb 49                	jmp    8054d3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80548a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80548d:	48 98                	cltq   
  80548f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805493:	48 29 c2             	sub    %rax,%rdx
  805496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805499:	48 63 c8             	movslq %eax,%rcx
  80549c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8054a0:	48 01 c1             	add    %rax,%rcx
  8054a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8054a6:	48 89 ce             	mov    %rcx,%rsi
  8054a9:	89 c7                	mov    %eax,%edi
  8054ab:	48 b8 99 53 80 00 00 	movabs $0x805399,%rax
  8054b2:	00 00 00 
  8054b5:	ff d0                	callq  *%rax
  8054b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8054ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8054be:	79 05                	jns    8054c5 <readn+0x57>
			return m;
  8054c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8054c3:	eb 1c                	jmp    8054e1 <readn+0x73>
		if (m == 0)
  8054c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8054c9:	75 02                	jne    8054cd <readn+0x5f>
			break;
  8054cb:	eb 11                	jmp    8054de <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8054cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8054d0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8054d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054d6:	48 98                	cltq   
  8054d8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8054dc:	72 ac                	jb     80548a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8054de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8054e1:	c9                   	leaveq 
  8054e2:	c3                   	retq   

00000000008054e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8054e3:	55                   	push   %rbp
  8054e4:	48 89 e5             	mov    %rsp,%rbp
  8054e7:	48 83 ec 40          	sub    $0x40,%rsp
  8054eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8054ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8054f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8054f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8054fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8054fd:	48 89 d6             	mov    %rdx,%rsi
  805500:	89 c7                	mov    %eax,%edi
  805502:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  805509:	00 00 00 
  80550c:	ff d0                	callq  *%rax
  80550e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805515:	78 24                	js     80553b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80551b:	8b 00                	mov    (%rax),%eax
  80551d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805521:	48 89 d6             	mov    %rdx,%rsi
  805524:	89 c7                	mov    %eax,%edi
  805526:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80552d:	00 00 00 
  805530:	ff d0                	callq  *%rax
  805532:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805535:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805539:	79 05                	jns    805540 <write+0x5d>
		return r;
  80553b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80553e:	eb 75                	jmp    8055b5 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805544:	8b 40 08             	mov    0x8(%rax),%eax
  805547:	83 e0 03             	and    $0x3,%eax
  80554a:	85 c0                	test   %eax,%eax
  80554c:	75 3a                	jne    805588 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80554e:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805555:	00 00 00 
  805558:	48 8b 00             	mov    (%rax),%rax
  80555b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805561:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805564:	89 c6                	mov    %eax,%esi
  805566:	48 bf 03 74 80 00 00 	movabs $0x807403,%rdi
  80556d:	00 00 00 
  805570:	b8 00 00 00 00       	mov    $0x0,%eax
  805575:	48 b9 f8 33 80 00 00 	movabs $0x8033f8,%rcx
  80557c:	00 00 00 
  80557f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805581:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805586:	eb 2d                	jmp    8055b5 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80558c:	48 8b 40 18          	mov    0x18(%rax),%rax
  805590:	48 85 c0             	test   %rax,%rax
  805593:	75 07                	jne    80559c <write+0xb9>
		return -E_NOT_SUPP;
  805595:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80559a:	eb 19                	jmp    8055b5 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80559c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055a0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8055a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8055a8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8055ac:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8055b0:	48 89 cf             	mov    %rcx,%rdi
  8055b3:	ff d0                	callq  *%rax
}
  8055b5:	c9                   	leaveq 
  8055b6:	c3                   	retq   

00000000008055b7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8055b7:	55                   	push   %rbp
  8055b8:	48 89 e5             	mov    %rsp,%rbp
  8055bb:	48 83 ec 18          	sub    $0x18,%rsp
  8055bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055c2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8055c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8055c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055cc:	48 89 d6             	mov    %rdx,%rsi
  8055cf:	89 c7                	mov    %eax,%edi
  8055d1:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  8055d8:	00 00 00 
  8055db:	ff d0                	callq  *%rax
  8055dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055e4:	79 05                	jns    8055eb <seek+0x34>
		return r;
  8055e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055e9:	eb 0f                	jmp    8055fa <seek+0x43>
	fd->fd_offset = offset;
  8055eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055ef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8055f2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8055f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8055fa:	c9                   	leaveq 
  8055fb:	c3                   	retq   

00000000008055fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8055fc:	55                   	push   %rbp
  8055fd:	48 89 e5             	mov    %rsp,%rbp
  805600:	48 83 ec 30          	sub    $0x30,%rsp
  805604:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805607:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80560a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80560e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805611:	48 89 d6             	mov    %rdx,%rsi
  805614:	89 c7                	mov    %eax,%edi
  805616:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  80561d:	00 00 00 
  805620:	ff d0                	callq  *%rax
  805622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805629:	78 24                	js     80564f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80562b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80562f:	8b 00                	mov    (%rax),%eax
  805631:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805635:	48 89 d6             	mov    %rdx,%rsi
  805638:	89 c7                	mov    %eax,%edi
  80563a:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  805641:	00 00 00 
  805644:	ff d0                	callq  *%rax
  805646:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805649:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80564d:	79 05                	jns    805654 <ftruncate+0x58>
		return r;
  80564f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805652:	eb 72                	jmp    8056c6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805658:	8b 40 08             	mov    0x8(%rax),%eax
  80565b:	83 e0 03             	and    $0x3,%eax
  80565e:	85 c0                	test   %eax,%eax
  805660:	75 3a                	jne    80569c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805662:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805669:	00 00 00 
  80566c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80566f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805675:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805678:	89 c6                	mov    %eax,%esi
  80567a:	48 bf 20 74 80 00 00 	movabs $0x807420,%rdi
  805681:	00 00 00 
  805684:	b8 00 00 00 00       	mov    $0x0,%eax
  805689:	48 b9 f8 33 80 00 00 	movabs $0x8033f8,%rcx
  805690:	00 00 00 
  805693:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805695:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80569a:	eb 2a                	jmp    8056c6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80569c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056a0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8056a4:	48 85 c0             	test   %rax,%rax
  8056a7:	75 07                	jne    8056b0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8056a9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8056ae:	eb 16                	jmp    8056c6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8056b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056b4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8056b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8056bc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8056bf:	89 ce                	mov    %ecx,%esi
  8056c1:	48 89 d7             	mov    %rdx,%rdi
  8056c4:	ff d0                	callq  *%rax
}
  8056c6:	c9                   	leaveq 
  8056c7:	c3                   	retq   

00000000008056c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8056c8:	55                   	push   %rbp
  8056c9:	48 89 e5             	mov    %rsp,%rbp
  8056cc:	48 83 ec 30          	sub    $0x30,%rsp
  8056d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8056d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8056d7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8056db:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8056de:	48 89 d6             	mov    %rdx,%rsi
  8056e1:	89 c7                	mov    %eax,%edi
  8056e3:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  8056ea:	00 00 00 
  8056ed:	ff d0                	callq  *%rax
  8056ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056f6:	78 24                	js     80571c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8056f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056fc:	8b 00                	mov    (%rax),%eax
  8056fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805702:	48 89 d6             	mov    %rdx,%rsi
  805705:	89 c7                	mov    %eax,%edi
  805707:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80570e:	00 00 00 
  805711:	ff d0                	callq  *%rax
  805713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80571a:	79 05                	jns    805721 <fstat+0x59>
		return r;
  80571c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80571f:	eb 5e                	jmp    80577f <fstat+0xb7>
	if (!dev->dev_stat)
  805721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805725:	48 8b 40 28          	mov    0x28(%rax),%rax
  805729:	48 85 c0             	test   %rax,%rax
  80572c:	75 07                	jne    805735 <fstat+0x6d>
		return -E_NOT_SUPP;
  80572e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805733:	eb 4a                	jmp    80577f <fstat+0xb7>
	stat->st_name[0] = 0;
  805735:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805739:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80573c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805740:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805747:	00 00 00 
	stat->st_isdir = 0;
  80574a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80574e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805755:	00 00 00 
	stat->st_dev = dev;
  805758:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80575c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805760:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80576b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80576f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805773:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805777:	48 89 ce             	mov    %rcx,%rsi
  80577a:	48 89 d7             	mov    %rdx,%rdi
  80577d:	ff d0                	callq  *%rax
}
  80577f:	c9                   	leaveq 
  805780:	c3                   	retq   

0000000000805781 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805781:	55                   	push   %rbp
  805782:	48 89 e5             	mov    %rsp,%rbp
  805785:	48 83 ec 20          	sub    $0x20,%rsp
  805789:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80578d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805795:	be 00 00 00 00       	mov    $0x0,%esi
  80579a:	48 89 c7             	mov    %rax,%rdi
  80579d:	48 b8 6f 58 80 00 00 	movabs $0x80586f,%rax
  8057a4:	00 00 00 
  8057a7:	ff d0                	callq  *%rax
  8057a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057b0:	79 05                	jns    8057b7 <stat+0x36>
		return fd;
  8057b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057b5:	eb 2f                	jmp    8057e6 <stat+0x65>
	r = fstat(fd, stat);
  8057b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8057bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057be:	48 89 d6             	mov    %rdx,%rsi
  8057c1:	89 c7                	mov    %eax,%edi
  8057c3:	48 b8 c8 56 80 00 00 	movabs $0x8056c8,%rax
  8057ca:	00 00 00 
  8057cd:	ff d0                	callq  *%rax
  8057cf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8057d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057d5:	89 c7                	mov    %eax,%edi
  8057d7:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  8057de:	00 00 00 
  8057e1:	ff d0                	callq  *%rax
	return r;
  8057e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8057e6:	c9                   	leaveq 
  8057e7:	c3                   	retq   

00000000008057e8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8057e8:	55                   	push   %rbp
  8057e9:	48 89 e5             	mov    %rsp,%rbp
  8057ec:	48 83 ec 10          	sub    $0x10,%rsp
  8057f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8057f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8057f7:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  8057fe:	00 00 00 
  805801:	8b 00                	mov    (%rax),%eax
  805803:	85 c0                	test   %eax,%eax
  805805:	75 1d                	jne    805824 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805807:	bf 01 00 00 00       	mov    $0x1,%edi
  80580c:	48 b8 ff 4d 80 00 00 	movabs $0x804dff,%rax
  805813:	00 00 00 
  805816:	ff d0                	callq  *%rax
  805818:	48 ba 00 20 81 00 00 	movabs $0x812000,%rdx
  80581f:	00 00 00 
  805822:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805824:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  80582b:	00 00 00 
  80582e:	8b 00                	mov    (%rax),%eax
  805830:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805833:	b9 07 00 00 00       	mov    $0x7,%ecx
  805838:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  80583f:	00 00 00 
  805842:	89 c7                	mov    %eax,%edi
  805844:	48 b8 67 4d 80 00 00 	movabs $0x804d67,%rax
  80584b:	00 00 00 
  80584e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  805850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805854:	ba 00 00 00 00       	mov    $0x0,%edx
  805859:	48 89 c6             	mov    %rax,%rsi
  80585c:	bf 00 00 00 00       	mov    $0x0,%edi
  805861:	48 b8 a6 4c 80 00 00 	movabs $0x804ca6,%rax
  805868:	00 00 00 
  80586b:	ff d0                	callq  *%rax
}
  80586d:	c9                   	leaveq 
  80586e:	c3                   	retq   

000000000080586f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80586f:	55                   	push   %rbp
  805870:	48 89 e5             	mov    %rsp,%rbp
  805873:	48 83 ec 20          	sub    $0x20,%rsp
  805877:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80587b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80587e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805882:	48 89 c7             	mov    %rax,%rdi
  805885:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  80588c:	00 00 00 
  80588f:	ff d0                	callq  *%rax
  805891:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805896:	7e 0a                	jle    8058a2 <open+0x33>
		return -E_BAD_PATH;
  805898:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80589d:	e9 a5 00 00 00       	jmpq   805947 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8058a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8058a6:	48 89 c7             	mov    %rax,%rdi
  8058a9:	48 b8 cf 4e 80 00 00 	movabs $0x804ecf,%rax
  8058b0:	00 00 00 
  8058b3:	ff d0                	callq  *%rax
  8058b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058bc:	79 08                	jns    8058c6 <open+0x57>
		return r;
  8058be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058c1:	e9 81 00 00 00       	jmpq   805947 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8058c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058ca:	48 89 c6             	mov    %rax,%rsi
  8058cd:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  8058d4:	00 00 00 
  8058d7:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  8058de:	00 00 00 
  8058e1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8058e3:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8058ea:	00 00 00 
  8058ed:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8058f0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8058f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058fa:	48 89 c6             	mov    %rax,%rsi
  8058fd:	bf 01 00 00 00       	mov    $0x1,%edi
  805902:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805909:	00 00 00 
  80590c:	ff d0                	callq  *%rax
  80590e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805911:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805915:	79 1d                	jns    805934 <open+0xc5>
		fd_close(fd, 0);
  805917:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80591b:	be 00 00 00 00       	mov    $0x0,%esi
  805920:	48 89 c7             	mov    %rax,%rdi
  805923:	48 b8 f7 4f 80 00 00 	movabs $0x804ff7,%rax
  80592a:	00 00 00 
  80592d:	ff d0                	callq  *%rax
		return r;
  80592f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805932:	eb 13                	jmp    805947 <open+0xd8>
	}

	return fd2num(fd);
  805934:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805938:	48 89 c7             	mov    %rax,%rdi
  80593b:	48 b8 81 4e 80 00 00 	movabs $0x804e81,%rax
  805942:	00 00 00 
  805945:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  805947:	c9                   	leaveq 
  805948:	c3                   	retq   

0000000000805949 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805949:	55                   	push   %rbp
  80594a:	48 89 e5             	mov    %rsp,%rbp
  80594d:	48 83 ec 10          	sub    $0x10,%rsp
  805951:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805955:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805959:	8b 50 0c             	mov    0xc(%rax),%edx
  80595c:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805963:	00 00 00 
  805966:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805968:	be 00 00 00 00       	mov    $0x0,%esi
  80596d:	bf 06 00 00 00       	mov    $0x6,%edi
  805972:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805979:	00 00 00 
  80597c:	ff d0                	callq  *%rax
}
  80597e:	c9                   	leaveq 
  80597f:	c3                   	retq   

0000000000805980 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805980:	55                   	push   %rbp
  805981:	48 89 e5             	mov    %rsp,%rbp
  805984:	48 83 ec 30          	sub    $0x30,%rsp
  805988:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80598c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805990:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805998:	8b 50 0c             	mov    0xc(%rax),%edx
  80599b:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8059a2:	00 00 00 
  8059a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8059a7:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8059ae:	00 00 00 
  8059b1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8059b5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8059b9:	be 00 00 00 00       	mov    $0x0,%esi
  8059be:	bf 03 00 00 00       	mov    $0x3,%edi
  8059c3:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  8059ca:	00 00 00 
  8059cd:	ff d0                	callq  *%rax
  8059cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059d6:	79 08                	jns    8059e0 <devfile_read+0x60>
		return r;
  8059d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059db:	e9 a4 00 00 00       	jmpq   805a84 <devfile_read+0x104>
	assert(r <= n);
  8059e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059e3:	48 98                	cltq   
  8059e5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8059e9:	76 35                	jbe    805a20 <devfile_read+0xa0>
  8059eb:	48 b9 4d 74 80 00 00 	movabs $0x80744d,%rcx
  8059f2:	00 00 00 
  8059f5:	48 ba 54 74 80 00 00 	movabs $0x807454,%rdx
  8059fc:	00 00 00 
  8059ff:	be 84 00 00 00       	mov    $0x84,%esi
  805a04:	48 bf 69 74 80 00 00 	movabs $0x807469,%rdi
  805a0b:	00 00 00 
  805a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  805a13:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  805a1a:	00 00 00 
  805a1d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  805a20:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  805a27:	7e 35                	jle    805a5e <devfile_read+0xde>
  805a29:	48 b9 74 74 80 00 00 	movabs $0x807474,%rcx
  805a30:	00 00 00 
  805a33:	48 ba 54 74 80 00 00 	movabs $0x807454,%rdx
  805a3a:	00 00 00 
  805a3d:	be 85 00 00 00       	mov    $0x85,%esi
  805a42:	48 bf 69 74 80 00 00 	movabs $0x807469,%rdi
  805a49:	00 00 00 
  805a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  805a51:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  805a58:	00 00 00 
  805a5b:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  805a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a61:	48 63 d0             	movslq %eax,%rdx
  805a64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a68:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805a6f:	00 00 00 
  805a72:	48 89 c7             	mov    %rax,%rdi
  805a75:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  805a7c:	00 00 00 
  805a7f:	ff d0                	callq  *%rax
	return r;
  805a81:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  805a84:	c9                   	leaveq 
  805a85:	c3                   	retq   

0000000000805a86 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805a86:	55                   	push   %rbp
  805a87:	48 89 e5             	mov    %rsp,%rbp
  805a8a:	48 83 ec 30          	sub    $0x30,%rsp
  805a8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a96:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a9e:	8b 50 0c             	mov    0xc(%rax),%edx
  805aa1:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805aa8:	00 00 00 
  805aab:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  805aad:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805ab4:	00 00 00 
  805ab7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805abb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  805abf:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  805ac6:	00 
  805ac7:	76 35                	jbe    805afe <devfile_write+0x78>
  805ac9:	48 b9 80 74 80 00 00 	movabs $0x807480,%rcx
  805ad0:	00 00 00 
  805ad3:	48 ba 54 74 80 00 00 	movabs $0x807454,%rdx
  805ada:	00 00 00 
  805add:	be 9e 00 00 00       	mov    $0x9e,%esi
  805ae2:	48 bf 69 74 80 00 00 	movabs $0x807469,%rdi
  805ae9:	00 00 00 
  805aec:	b8 00 00 00 00       	mov    $0x0,%eax
  805af1:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  805af8:	00 00 00 
  805afb:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  805afe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805b02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b06:	48 89 c6             	mov    %rax,%rsi
  805b09:	48 bf 10 30 81 00 00 	movabs $0x813010,%rdi
  805b10:	00 00 00 
  805b13:	48 b8 fb 43 80 00 00 	movabs $0x8043fb,%rax
  805b1a:	00 00 00 
  805b1d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  805b1f:	be 00 00 00 00       	mov    $0x0,%esi
  805b24:	bf 04 00 00 00       	mov    $0x4,%edi
  805b29:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805b30:	00 00 00 
  805b33:	ff d0                	callq  *%rax
  805b35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b3c:	79 05                	jns    805b43 <devfile_write+0xbd>
		return r;
  805b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b41:	eb 43                	jmp    805b86 <devfile_write+0x100>
	assert(r <= n);
  805b43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b46:	48 98                	cltq   
  805b48:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805b4c:	76 35                	jbe    805b83 <devfile_write+0xfd>
  805b4e:	48 b9 4d 74 80 00 00 	movabs $0x80744d,%rcx
  805b55:	00 00 00 
  805b58:	48 ba 54 74 80 00 00 	movabs $0x807454,%rdx
  805b5f:	00 00 00 
  805b62:	be a2 00 00 00       	mov    $0xa2,%esi
  805b67:	48 bf 69 74 80 00 00 	movabs $0x807469,%rdi
  805b6e:	00 00 00 
  805b71:	b8 00 00 00 00       	mov    $0x0,%eax
  805b76:	49 b8 bf 31 80 00 00 	movabs $0x8031bf,%r8
  805b7d:	00 00 00 
  805b80:	41 ff d0             	callq  *%r8
	return r;
  805b83:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  805b86:	c9                   	leaveq 
  805b87:	c3                   	retq   

0000000000805b88 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805b88:	55                   	push   %rbp
  805b89:	48 89 e5             	mov    %rsp,%rbp
  805b8c:	48 83 ec 20          	sub    $0x20,%rsp
  805b90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b9c:	8b 50 0c             	mov    0xc(%rax),%edx
  805b9f:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805ba6:	00 00 00 
  805ba9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805bab:	be 00 00 00 00       	mov    $0x0,%esi
  805bb0:	bf 05 00 00 00       	mov    $0x5,%edi
  805bb5:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805bbc:	00 00 00 
  805bbf:	ff d0                	callq  *%rax
  805bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bc8:	79 05                	jns    805bcf <devfile_stat+0x47>
		return r;
  805bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bcd:	eb 56                	jmp    805c25 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805bcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805bd3:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805bda:	00 00 00 
  805bdd:	48 89 c7             	mov    %rax,%rdi
  805be0:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  805be7:	00 00 00 
  805bea:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805bec:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805bf3:	00 00 00 
  805bf6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805bfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c00:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805c06:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c0d:	00 00 00 
  805c10:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805c16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c1a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c25:	c9                   	leaveq 
  805c26:	c3                   	retq   

0000000000805c27 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805c27:	55                   	push   %rbp
  805c28:	48 89 e5             	mov    %rsp,%rbp
  805c2b:	48 83 ec 10          	sub    $0x10,%rsp
  805c2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805c33:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805c36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c3a:	8b 50 0c             	mov    0xc(%rax),%edx
  805c3d:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c44:	00 00 00 
  805c47:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805c49:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c50:	00 00 00 
  805c53:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805c56:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805c59:	be 00 00 00 00       	mov    $0x0,%esi
  805c5e:	bf 02 00 00 00       	mov    $0x2,%edi
  805c63:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805c6a:	00 00 00 
  805c6d:	ff d0                	callq  *%rax
}
  805c6f:	c9                   	leaveq 
  805c70:	c3                   	retq   

0000000000805c71 <remove>:

// Delete a file
int
remove(const char *path)
{
  805c71:	55                   	push   %rbp
  805c72:	48 89 e5             	mov    %rsp,%rbp
  805c75:	48 83 ec 10          	sub    $0x10,%rsp
  805c79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805c7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c81:	48 89 c7             	mov    %rax,%rdi
  805c84:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  805c8b:	00 00 00 
  805c8e:	ff d0                	callq  *%rax
  805c90:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805c95:	7e 07                	jle    805c9e <remove+0x2d>
		return -E_BAD_PATH;
  805c97:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805c9c:	eb 33                	jmp    805cd1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805c9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ca2:	48 89 c6             	mov    %rax,%rsi
  805ca5:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805cac:	00 00 00 
  805caf:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  805cb6:	00 00 00 
  805cb9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805cbb:	be 00 00 00 00       	mov    $0x0,%esi
  805cc0:	bf 07 00 00 00       	mov    $0x7,%edi
  805cc5:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805ccc:	00 00 00 
  805ccf:	ff d0                	callq  *%rax
}
  805cd1:	c9                   	leaveq 
  805cd2:	c3                   	retq   

0000000000805cd3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805cd3:	55                   	push   %rbp
  805cd4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805cd7:	be 00 00 00 00       	mov    $0x0,%esi
  805cdc:	bf 08 00 00 00       	mov    $0x8,%edi
  805ce1:	48 b8 e8 57 80 00 00 	movabs $0x8057e8,%rax
  805ce8:	00 00 00 
  805ceb:	ff d0                	callq  *%rax
}
  805ced:	5d                   	pop    %rbp
  805cee:	c3                   	retq   

0000000000805cef <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  805cef:	55                   	push   %rbp
  805cf0:	48 89 e5             	mov    %rsp,%rbp
  805cf3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  805cfa:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  805d01:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  805d08:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  805d0f:	be 00 00 00 00       	mov    $0x0,%esi
  805d14:	48 89 c7             	mov    %rax,%rdi
  805d17:	48 b8 6f 58 80 00 00 	movabs $0x80586f,%rax
  805d1e:	00 00 00 
  805d21:	ff d0                	callq  *%rax
  805d23:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  805d26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d2a:	79 28                	jns    805d54 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  805d2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d2f:	89 c6                	mov    %eax,%esi
  805d31:	48 bf ad 74 80 00 00 	movabs $0x8074ad,%rdi
  805d38:	00 00 00 
  805d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  805d40:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  805d47:	00 00 00 
  805d4a:	ff d2                	callq  *%rdx
		return fd_src;
  805d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d4f:	e9 74 01 00 00       	jmpq   805ec8 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  805d54:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  805d5b:	be 01 01 00 00       	mov    $0x101,%esi
  805d60:	48 89 c7             	mov    %rax,%rdi
  805d63:	48 b8 6f 58 80 00 00 	movabs $0x80586f,%rax
  805d6a:	00 00 00 
  805d6d:	ff d0                	callq  *%rax
  805d6f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  805d72:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805d76:	79 39                	jns    805db1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  805d78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d7b:	89 c6                	mov    %eax,%esi
  805d7d:	48 bf c3 74 80 00 00 	movabs $0x8074c3,%rdi
  805d84:	00 00 00 
  805d87:	b8 00 00 00 00       	mov    $0x0,%eax
  805d8c:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  805d93:	00 00 00 
  805d96:	ff d2                	callq  *%rdx
		close(fd_src);
  805d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d9b:	89 c7                	mov    %eax,%edi
  805d9d:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805da4:	00 00 00 
  805da7:	ff d0                	callq  *%rax
		return fd_dest;
  805da9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805dac:	e9 17 01 00 00       	jmpq   805ec8 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805db1:	eb 74                	jmp    805e27 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  805db3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805db6:	48 63 d0             	movslq %eax,%rdx
  805db9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805dc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805dc3:	48 89 ce             	mov    %rcx,%rsi
  805dc6:	89 c7                	mov    %eax,%edi
  805dc8:	48 b8 e3 54 80 00 00 	movabs $0x8054e3,%rax
  805dcf:	00 00 00 
  805dd2:	ff d0                	callq  *%rax
  805dd4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  805dd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  805ddb:	79 4a                	jns    805e27 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  805ddd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805de0:	89 c6                	mov    %eax,%esi
  805de2:	48 bf dd 74 80 00 00 	movabs $0x8074dd,%rdi
  805de9:	00 00 00 
  805dec:	b8 00 00 00 00       	mov    $0x0,%eax
  805df1:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  805df8:	00 00 00 
  805dfb:	ff d2                	callq  *%rdx
			close(fd_src);
  805dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e00:	89 c7                	mov    %eax,%edi
  805e02:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805e09:	00 00 00 
  805e0c:	ff d0                	callq  *%rax
			close(fd_dest);
  805e0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805e11:	89 c7                	mov    %eax,%edi
  805e13:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805e1a:	00 00 00 
  805e1d:	ff d0                	callq  *%rax
			return write_size;
  805e1f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805e22:	e9 a1 00 00 00       	jmpq   805ec8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805e27:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e31:	ba 00 02 00 00       	mov    $0x200,%edx
  805e36:	48 89 ce             	mov    %rcx,%rsi
  805e39:	89 c7                	mov    %eax,%edi
  805e3b:	48 b8 99 53 80 00 00 	movabs $0x805399,%rax
  805e42:	00 00 00 
  805e45:	ff d0                	callq  *%rax
  805e47:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805e4e:	0f 8f 5f ff ff ff    	jg     805db3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  805e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805e58:	79 47                	jns    805ea1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  805e5a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805e5d:	89 c6                	mov    %eax,%esi
  805e5f:	48 bf f0 74 80 00 00 	movabs $0x8074f0,%rdi
  805e66:	00 00 00 
  805e69:	b8 00 00 00 00       	mov    $0x0,%eax
  805e6e:	48 ba f8 33 80 00 00 	movabs $0x8033f8,%rdx
  805e75:	00 00 00 
  805e78:	ff d2                	callq  *%rdx
		close(fd_src);
  805e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e7d:	89 c7                	mov    %eax,%edi
  805e7f:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805e86:	00 00 00 
  805e89:	ff d0                	callq  *%rax
		close(fd_dest);
  805e8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805e8e:	89 c7                	mov    %eax,%edi
  805e90:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805e97:	00 00 00 
  805e9a:	ff d0                	callq  *%rax
		return read_size;
  805e9c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805e9f:	eb 27                	jmp    805ec8 <copy+0x1d9>
	}
	close(fd_src);
  805ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ea4:	89 c7                	mov    %eax,%edi
  805ea6:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805ead:	00 00 00 
  805eb0:	ff d0                	callq  *%rax
	close(fd_dest);
  805eb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805eb5:	89 c7                	mov    %eax,%edi
  805eb7:	48 b8 77 51 80 00 00 	movabs $0x805177,%rax
  805ebe:	00 00 00 
  805ec1:	ff d0                	callq  *%rax
	return 0;
  805ec3:	b8 00 00 00 00       	mov    $0x0,%eax

}
  805ec8:	c9                   	leaveq 
  805ec9:	c3                   	retq   

0000000000805eca <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805eca:	55                   	push   %rbp
  805ecb:	48 89 e5             	mov    %rsp,%rbp
  805ece:	48 83 ec 18          	sub    $0x18,%rsp
  805ed2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805eda:	48 c1 e8 15          	shr    $0x15,%rax
  805ede:	48 89 c2             	mov    %rax,%rdx
  805ee1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805ee8:	01 00 00 
  805eeb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805eef:	83 e0 01             	and    $0x1,%eax
  805ef2:	48 85 c0             	test   %rax,%rax
  805ef5:	75 07                	jne    805efe <pageref+0x34>
		return 0;
  805ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  805efc:	eb 53                	jmp    805f51 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805f02:	48 c1 e8 0c          	shr    $0xc,%rax
  805f06:	48 89 c2             	mov    %rax,%rdx
  805f09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805f10:	01 00 00 
  805f13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805f17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f1f:	83 e0 01             	and    $0x1,%eax
  805f22:	48 85 c0             	test   %rax,%rax
  805f25:	75 07                	jne    805f2e <pageref+0x64>
		return 0;
  805f27:	b8 00 00 00 00       	mov    $0x0,%eax
  805f2c:	eb 23                	jmp    805f51 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f32:	48 c1 e8 0c          	shr    $0xc,%rax
  805f36:	48 89 c2             	mov    %rax,%rdx
  805f39:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805f40:	00 00 00 
  805f43:	48 c1 e2 04          	shl    $0x4,%rdx
  805f47:	48 01 d0             	add    %rdx,%rax
  805f4a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805f4e:	0f b7 c0             	movzwl %ax,%eax
}
  805f51:	c9                   	leaveq 
  805f52:	c3                   	retq   

0000000000805f53 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805f53:	55                   	push   %rbp
  805f54:	48 89 e5             	mov    %rsp,%rbp
  805f57:	53                   	push   %rbx
  805f58:	48 83 ec 38          	sub    $0x38,%rsp
  805f5c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805f60:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805f64:	48 89 c7             	mov    %rax,%rdi
  805f67:	48 b8 cf 4e 80 00 00 	movabs $0x804ecf,%rax
  805f6e:	00 00 00 
  805f71:	ff d0                	callq  *%rax
  805f73:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f76:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f7a:	0f 88 bf 01 00 00    	js     80613f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805f80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f84:	ba 07 04 00 00       	mov    $0x407,%edx
  805f89:	48 89 c6             	mov    %rax,%rsi
  805f8c:	bf 00 00 00 00       	mov    $0x0,%edi
  805f91:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  805f98:	00 00 00 
  805f9b:	ff d0                	callq  *%rax
  805f9d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805fa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805fa4:	0f 88 95 01 00 00    	js     80613f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805faa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805fae:	48 89 c7             	mov    %rax,%rdi
  805fb1:	48 b8 cf 4e 80 00 00 	movabs $0x804ecf,%rax
  805fb8:	00 00 00 
  805fbb:	ff d0                	callq  *%rax
  805fbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805fc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805fc4:	0f 88 5d 01 00 00    	js     806127 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805fca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fce:	ba 07 04 00 00       	mov    $0x407,%edx
  805fd3:	48 89 c6             	mov    %rax,%rsi
  805fd6:	bf 00 00 00 00       	mov    $0x0,%edi
  805fdb:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  805fe2:	00 00 00 
  805fe5:	ff d0                	callq  *%rax
  805fe7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805fea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805fee:	0f 88 33 01 00 00    	js     806127 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805ff4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ff8:	48 89 c7             	mov    %rax,%rdi
  805ffb:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  806002:	00 00 00 
  806005:	ff d0                	callq  *%rax
  806007:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80600b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80600f:	ba 07 04 00 00       	mov    $0x407,%edx
  806014:	48 89 c6             	mov    %rax,%rsi
  806017:	bf 00 00 00 00       	mov    $0x0,%edi
  80601c:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  806023:	00 00 00 
  806026:	ff d0                	callq  *%rax
  806028:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80602b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80602f:	79 05                	jns    806036 <pipe+0xe3>
		goto err2;
  806031:	e9 d9 00 00 00       	jmpq   80610f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806036:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80603a:	48 89 c7             	mov    %rax,%rdi
  80603d:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  806044:	00 00 00 
  806047:	ff d0                	callq  *%rax
  806049:	48 89 c2             	mov    %rax,%rdx
  80604c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806050:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806056:	48 89 d1             	mov    %rdx,%rcx
  806059:	ba 00 00 00 00       	mov    $0x0,%edx
  80605e:	48 89 c6             	mov    %rax,%rsi
  806061:	bf 00 00 00 00       	mov    $0x0,%edi
  806066:	48 b8 3f 49 80 00 00 	movabs $0x80493f,%rax
  80606d:	00 00 00 
  806070:	ff d0                	callq  *%rax
  806072:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806075:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806079:	79 1b                	jns    806096 <pipe+0x143>
		goto err3;
  80607b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80607c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806080:	48 89 c6             	mov    %rax,%rsi
  806083:	bf 00 00 00 00       	mov    $0x0,%edi
  806088:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  80608f:	00 00 00 
  806092:	ff d0                	callq  *%rax
  806094:	eb 79                	jmp    80610f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806096:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80609a:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  8060a1:	00 00 00 
  8060a4:	8b 12                	mov    (%rdx),%edx
  8060a6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8060a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8060b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060b7:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  8060be:	00 00 00 
  8060c1:	8b 12                	mov    (%rdx),%edx
  8060c3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8060c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060c9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8060d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060d4:	48 89 c7             	mov    %rax,%rdi
  8060d7:	48 b8 81 4e 80 00 00 	movabs $0x804e81,%rax
  8060de:	00 00 00 
  8060e1:	ff d0                	callq  *%rax
  8060e3:	89 c2                	mov    %eax,%edx
  8060e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8060e9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8060eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8060ef:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8060f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060f7:	48 89 c7             	mov    %rax,%rdi
  8060fa:	48 b8 81 4e 80 00 00 	movabs $0x804e81,%rax
  806101:	00 00 00 
  806104:	ff d0                	callq  *%rax
  806106:	89 03                	mov    %eax,(%rbx)
	return 0;
  806108:	b8 00 00 00 00       	mov    $0x0,%eax
  80610d:	eb 33                	jmp    806142 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80610f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806113:	48 89 c6             	mov    %rax,%rsi
  806116:	bf 00 00 00 00       	mov    $0x0,%edi
  80611b:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  806122:	00 00 00 
  806125:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80612b:	48 89 c6             	mov    %rax,%rsi
  80612e:	bf 00 00 00 00       	mov    $0x0,%edi
  806133:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  80613a:	00 00 00 
  80613d:	ff d0                	callq  *%rax
err:
	return r;
  80613f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806142:	48 83 c4 38          	add    $0x38,%rsp
  806146:	5b                   	pop    %rbx
  806147:	5d                   	pop    %rbp
  806148:	c3                   	retq   

0000000000806149 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  806149:	55                   	push   %rbp
  80614a:	48 89 e5             	mov    %rsp,%rbp
  80614d:	53                   	push   %rbx
  80614e:	48 83 ec 28          	sub    $0x28,%rsp
  806152:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806156:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80615a:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  806161:	00 00 00 
  806164:	48 8b 00             	mov    (%rax),%rax
  806167:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80616d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806170:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806174:	48 89 c7             	mov    %rax,%rdi
  806177:	48 b8 ca 5e 80 00 00 	movabs $0x805eca,%rax
  80617e:	00 00 00 
  806181:	ff d0                	callq  *%rax
  806183:	89 c3                	mov    %eax,%ebx
  806185:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806189:	48 89 c7             	mov    %rax,%rdi
  80618c:	48 b8 ca 5e 80 00 00 	movabs $0x805eca,%rax
  806193:	00 00 00 
  806196:	ff d0                	callq  *%rax
  806198:	39 c3                	cmp    %eax,%ebx
  80619a:	0f 94 c0             	sete   %al
  80619d:	0f b6 c0             	movzbl %al,%eax
  8061a0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8061a3:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8061aa:	00 00 00 
  8061ad:	48 8b 00             	mov    (%rax),%rax
  8061b0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8061b6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8061b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061bc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8061bf:	75 05                	jne    8061c6 <_pipeisclosed+0x7d>
			return ret;
  8061c1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8061c4:	eb 4f                	jmp    806215 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8061c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061c9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8061cc:	74 42                	je     806210 <_pipeisclosed+0xc7>
  8061ce:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8061d2:	75 3c                	jne    806210 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8061d4:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8061db:	00 00 00 
  8061de:	48 8b 00             	mov    (%rax),%rax
  8061e1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8061e7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8061ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061ed:	89 c6                	mov    %eax,%esi
  8061ef:	48 bf 0b 75 80 00 00 	movabs $0x80750b,%rdi
  8061f6:	00 00 00 
  8061f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8061fe:	49 b8 f8 33 80 00 00 	movabs $0x8033f8,%r8
  806205:	00 00 00 
  806208:	41 ff d0             	callq  *%r8
	}
  80620b:	e9 4a ff ff ff       	jmpq   80615a <_pipeisclosed+0x11>
  806210:	e9 45 ff ff ff       	jmpq   80615a <_pipeisclosed+0x11>
}
  806215:	48 83 c4 28          	add    $0x28,%rsp
  806219:	5b                   	pop    %rbx
  80621a:	5d                   	pop    %rbp
  80621b:	c3                   	retq   

000000000080621c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80621c:	55                   	push   %rbp
  80621d:	48 89 e5             	mov    %rsp,%rbp
  806220:	48 83 ec 30          	sub    $0x30,%rsp
  806224:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806227:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80622b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80622e:	48 89 d6             	mov    %rdx,%rsi
  806231:	89 c7                	mov    %eax,%edi
  806233:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  80623a:	00 00 00 
  80623d:	ff d0                	callq  *%rax
  80623f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806246:	79 05                	jns    80624d <pipeisclosed+0x31>
		return r;
  806248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80624b:	eb 31                	jmp    80627e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80624d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806251:	48 89 c7             	mov    %rax,%rdi
  806254:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  80625b:	00 00 00 
  80625e:	ff d0                	callq  *%rax
  806260:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  806264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80626c:	48 89 d6             	mov    %rdx,%rsi
  80626f:	48 89 c7             	mov    %rax,%rdi
  806272:	48 b8 49 61 80 00 00 	movabs $0x806149,%rax
  806279:	00 00 00 
  80627c:	ff d0                	callq  *%rax
}
  80627e:	c9                   	leaveq 
  80627f:	c3                   	retq   

0000000000806280 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  806280:	55                   	push   %rbp
  806281:	48 89 e5             	mov    %rsp,%rbp
  806284:	48 83 ec 40          	sub    $0x40,%rsp
  806288:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80628c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806290:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806294:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806298:	48 89 c7             	mov    %rax,%rdi
  80629b:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  8062a2:	00 00 00 
  8062a5:	ff d0                	callq  *%rax
  8062a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8062ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8062af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8062b3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8062ba:	00 
  8062bb:	e9 92 00 00 00       	jmpq   806352 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8062c0:	eb 41                	jmp    806303 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8062c2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8062c7:	74 09                	je     8062d2 <devpipe_read+0x52>
				return i;
  8062c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062cd:	e9 92 00 00 00       	jmpq   806364 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8062d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8062d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8062da:	48 89 d6             	mov    %rdx,%rsi
  8062dd:	48 89 c7             	mov    %rax,%rdi
  8062e0:	48 b8 49 61 80 00 00 	movabs $0x806149,%rax
  8062e7:	00 00 00 
  8062ea:	ff d0                	callq  *%rax
  8062ec:	85 c0                	test   %eax,%eax
  8062ee:	74 07                	je     8062f7 <devpipe_read+0x77>
				return 0;
  8062f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8062f5:	eb 6d                	jmp    806364 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8062f7:	48 b8 b1 48 80 00 00 	movabs $0x8048b1,%rax
  8062fe:	00 00 00 
  806301:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806307:	8b 10                	mov    (%rax),%edx
  806309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80630d:	8b 40 04             	mov    0x4(%rax),%eax
  806310:	39 c2                	cmp    %eax,%edx
  806312:	74 ae                	je     8062c2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806318:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80631c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806324:	8b 00                	mov    (%rax),%eax
  806326:	99                   	cltd   
  806327:	c1 ea 1b             	shr    $0x1b,%edx
  80632a:	01 d0                	add    %edx,%eax
  80632c:	83 e0 1f             	and    $0x1f,%eax
  80632f:	29 d0                	sub    %edx,%eax
  806331:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806335:	48 98                	cltq   
  806337:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80633c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80633e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806342:	8b 00                	mov    (%rax),%eax
  806344:	8d 50 01             	lea    0x1(%rax),%edx
  806347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80634b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80634d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806356:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80635a:	0f 82 60 ff ff ff    	jb     8062c0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806364:	c9                   	leaveq 
  806365:	c3                   	retq   

0000000000806366 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806366:	55                   	push   %rbp
  806367:	48 89 e5             	mov    %rsp,%rbp
  80636a:	48 83 ec 40          	sub    $0x40,%rsp
  80636e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806372:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806376:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80637a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80637e:	48 89 c7             	mov    %rax,%rdi
  806381:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  806388:	00 00 00 
  80638b:	ff d0                	callq  *%rax
  80638d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806391:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806395:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806399:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8063a0:	00 
  8063a1:	e9 8e 00 00 00       	jmpq   806434 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8063a6:	eb 31                	jmp    8063d9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8063a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8063ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8063b0:	48 89 d6             	mov    %rdx,%rsi
  8063b3:	48 89 c7             	mov    %rax,%rdi
  8063b6:	48 b8 49 61 80 00 00 	movabs $0x806149,%rax
  8063bd:	00 00 00 
  8063c0:	ff d0                	callq  *%rax
  8063c2:	85 c0                	test   %eax,%eax
  8063c4:	74 07                	je     8063cd <devpipe_write+0x67>
				return 0;
  8063c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8063cb:	eb 79                	jmp    806446 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8063cd:	48 b8 b1 48 80 00 00 	movabs $0x8048b1,%rax
  8063d4:	00 00 00 
  8063d7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8063d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063dd:	8b 40 04             	mov    0x4(%rax),%eax
  8063e0:	48 63 d0             	movslq %eax,%rdx
  8063e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063e7:	8b 00                	mov    (%rax),%eax
  8063e9:	48 98                	cltq   
  8063eb:	48 83 c0 20          	add    $0x20,%rax
  8063ef:	48 39 c2             	cmp    %rax,%rdx
  8063f2:	73 b4                	jae    8063a8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8063f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063f8:	8b 40 04             	mov    0x4(%rax),%eax
  8063fb:	99                   	cltd   
  8063fc:	c1 ea 1b             	shr    $0x1b,%edx
  8063ff:	01 d0                	add    %edx,%eax
  806401:	83 e0 1f             	and    $0x1f,%eax
  806404:	29 d0                	sub    %edx,%eax
  806406:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80640a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80640e:	48 01 ca             	add    %rcx,%rdx
  806411:	0f b6 0a             	movzbl (%rdx),%ecx
  806414:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806418:	48 98                	cltq   
  80641a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80641e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806422:	8b 40 04             	mov    0x4(%rax),%eax
  806425:	8d 50 01             	lea    0x1(%rax),%edx
  806428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80642c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80642f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806438:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80643c:	0f 82 64 ff ff ff    	jb     8063a6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806446:	c9                   	leaveq 
  806447:	c3                   	retq   

0000000000806448 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  806448:	55                   	push   %rbp
  806449:	48 89 e5             	mov    %rsp,%rbp
  80644c:	48 83 ec 20          	sub    $0x20,%rsp
  806450:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806454:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  806458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80645c:	48 89 c7             	mov    %rax,%rdi
  80645f:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  806466:	00 00 00 
  806469:	ff d0                	callq  *%rax
  80646b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80646f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806473:	48 be 1e 75 80 00 00 	movabs $0x80751e,%rsi
  80647a:	00 00 00 
  80647d:	48 89 c7             	mov    %rax,%rdi
  806480:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  806487:	00 00 00 
  80648a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80648c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806490:	8b 50 04             	mov    0x4(%rax),%edx
  806493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806497:	8b 00                	mov    (%rax),%eax
  806499:	29 c2                	sub    %eax,%edx
  80649b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80649f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8064a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8064a9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8064b0:	00 00 00 
	stat->st_dev = &devpipe;
  8064b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8064b7:	48 b9 00 11 81 00 00 	movabs $0x811100,%rcx
  8064be:	00 00 00 
  8064c1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8064c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8064cd:	c9                   	leaveq 
  8064ce:	c3                   	retq   

00000000008064cf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8064cf:	55                   	push   %rbp
  8064d0:	48 89 e5             	mov    %rsp,%rbp
  8064d3:	48 83 ec 10          	sub    $0x10,%rsp
  8064d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8064db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064df:	48 89 c6             	mov    %rax,%rsi
  8064e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8064e7:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  8064ee:	00 00 00 
  8064f1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8064f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064f7:	48 89 c7             	mov    %rax,%rdi
  8064fa:	48 b8 a4 4e 80 00 00 	movabs $0x804ea4,%rax
  806501:	00 00 00 
  806504:	ff d0                	callq  *%rax
  806506:	48 89 c6             	mov    %rax,%rsi
  806509:	bf 00 00 00 00       	mov    $0x0,%edi
  80650e:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  806515:	00 00 00 
  806518:	ff d0                	callq  *%rax
}
  80651a:	c9                   	leaveq 
  80651b:	c3                   	retq   

000000000080651c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80651c:	55                   	push   %rbp
  80651d:	48 89 e5             	mov    %rsp,%rbp
  806520:	48 83 ec 20          	sub    $0x20,%rsp
  806524:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  806527:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80652a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80652d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806531:	be 01 00 00 00       	mov    $0x1,%esi
  806536:	48 89 c7             	mov    %rax,%rdi
  806539:	48 b8 a7 47 80 00 00 	movabs $0x8047a7,%rax
  806540:	00 00 00 
  806543:	ff d0                	callq  *%rax
}
  806545:	c9                   	leaveq 
  806546:	c3                   	retq   

0000000000806547 <getchar>:

int
getchar(void)
{
  806547:	55                   	push   %rbp
  806548:	48 89 e5             	mov    %rsp,%rbp
  80654b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80654f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806553:	ba 01 00 00 00       	mov    $0x1,%edx
  806558:	48 89 c6             	mov    %rax,%rsi
  80655b:	bf 00 00 00 00       	mov    $0x0,%edi
  806560:	48 b8 99 53 80 00 00 	movabs $0x805399,%rax
  806567:	00 00 00 
  80656a:	ff d0                	callq  *%rax
  80656c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80656f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806573:	79 05                	jns    80657a <getchar+0x33>
		return r;
  806575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806578:	eb 14                	jmp    80658e <getchar+0x47>
	if (r < 1)
  80657a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80657e:	7f 07                	jg     806587 <getchar+0x40>
		return -E_EOF;
  806580:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  806585:	eb 07                	jmp    80658e <getchar+0x47>
	return c;
  806587:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80658b:	0f b6 c0             	movzbl %al,%eax
}
  80658e:	c9                   	leaveq 
  80658f:	c3                   	retq   

0000000000806590 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  806590:	55                   	push   %rbp
  806591:	48 89 e5             	mov    %rsp,%rbp
  806594:	48 83 ec 20          	sub    $0x20,%rsp
  806598:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80659b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80659f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8065a2:	48 89 d6             	mov    %rdx,%rsi
  8065a5:	89 c7                	mov    %eax,%edi
  8065a7:	48 b8 67 4f 80 00 00 	movabs $0x804f67,%rax
  8065ae:	00 00 00 
  8065b1:	ff d0                	callq  *%rax
  8065b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065ba:	79 05                	jns    8065c1 <iscons+0x31>
		return r;
  8065bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8065bf:	eb 1a                	jmp    8065db <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8065c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065c5:	8b 10                	mov    (%rax),%edx
  8065c7:	48 b8 40 11 81 00 00 	movabs $0x811140,%rax
  8065ce:	00 00 00 
  8065d1:	8b 00                	mov    (%rax),%eax
  8065d3:	39 c2                	cmp    %eax,%edx
  8065d5:	0f 94 c0             	sete   %al
  8065d8:	0f b6 c0             	movzbl %al,%eax
}
  8065db:	c9                   	leaveq 
  8065dc:	c3                   	retq   

00000000008065dd <opencons>:

int
opencons(void)
{
  8065dd:	55                   	push   %rbp
  8065de:	48 89 e5             	mov    %rsp,%rbp
  8065e1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8065e5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8065e9:	48 89 c7             	mov    %rax,%rdi
  8065ec:	48 b8 cf 4e 80 00 00 	movabs $0x804ecf,%rax
  8065f3:	00 00 00 
  8065f6:	ff d0                	callq  *%rax
  8065f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065ff:	79 05                	jns    806606 <opencons+0x29>
		return r;
  806601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806604:	eb 5b                	jmp    806661 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80660a:	ba 07 04 00 00       	mov    $0x407,%edx
  80660f:	48 89 c6             	mov    %rax,%rsi
  806612:	bf 00 00 00 00       	mov    $0x0,%edi
  806617:	48 b8 ef 48 80 00 00 	movabs $0x8048ef,%rax
  80661e:	00 00 00 
  806621:	ff d0                	callq  *%rax
  806623:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806626:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80662a:	79 05                	jns    806631 <opencons+0x54>
		return r;
  80662c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80662f:	eb 30                	jmp    806661 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  806631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806635:	48 ba 40 11 81 00 00 	movabs $0x811140,%rdx
  80663c:	00 00 00 
  80663f:	8b 12                	mov    (%rdx),%edx
  806641:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  806643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806647:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80664e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806652:	48 89 c7             	mov    %rax,%rdi
  806655:	48 b8 81 4e 80 00 00 	movabs $0x804e81,%rax
  80665c:	00 00 00 
  80665f:	ff d0                	callq  *%rax
}
  806661:	c9                   	leaveq 
  806662:	c3                   	retq   

0000000000806663 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  806663:	55                   	push   %rbp
  806664:	48 89 e5             	mov    %rsp,%rbp
  806667:	48 83 ec 30          	sub    $0x30,%rsp
  80666b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80666f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806673:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  806677:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80667c:	75 07                	jne    806685 <devcons_read+0x22>
		return 0;
  80667e:	b8 00 00 00 00       	mov    $0x0,%eax
  806683:	eb 4b                	jmp    8066d0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  806685:	eb 0c                	jmp    806693 <devcons_read+0x30>
		sys_yield();
  806687:	48 b8 b1 48 80 00 00 	movabs $0x8048b1,%rax
  80668e:	00 00 00 
  806691:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  806693:	48 b8 f1 47 80 00 00 	movabs $0x8047f1,%rax
  80669a:	00 00 00 
  80669d:	ff d0                	callq  *%rax
  80669f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066a6:	74 df                	je     806687 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8066a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066ac:	79 05                	jns    8066b3 <devcons_read+0x50>
		return c;
  8066ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066b1:	eb 1d                	jmp    8066d0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8066b3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8066b7:	75 07                	jne    8066c0 <devcons_read+0x5d>
		return 0;
  8066b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8066be:	eb 10                	jmp    8066d0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8066c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066c3:	89 c2                	mov    %eax,%edx
  8066c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8066c9:	88 10                	mov    %dl,(%rax)
	return 1;
  8066cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8066d0:	c9                   	leaveq 
  8066d1:	c3                   	retq   

00000000008066d2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8066d2:	55                   	push   %rbp
  8066d3:	48 89 e5             	mov    %rsp,%rbp
  8066d6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8066dd:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8066e4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8066eb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8066f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8066f9:	eb 76                	jmp    806771 <devcons_write+0x9f>
		m = n - tot;
  8066fb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806702:	89 c2                	mov    %eax,%edx
  806704:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806707:	29 c2                	sub    %eax,%edx
  806709:	89 d0                	mov    %edx,%eax
  80670b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80670e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806711:	83 f8 7f             	cmp    $0x7f,%eax
  806714:	76 07                	jbe    80671d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  806716:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80671d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806720:	48 63 d0             	movslq %eax,%rdx
  806723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806726:	48 63 c8             	movslq %eax,%rcx
  806729:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  806730:	48 01 c1             	add    %rax,%rcx
  806733:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80673a:	48 89 ce             	mov    %rcx,%rsi
  80673d:	48 89 c7             	mov    %rax,%rdi
  806740:	48 b8 e4 42 80 00 00 	movabs $0x8042e4,%rax
  806747:	00 00 00 
  80674a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80674c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80674f:	48 63 d0             	movslq %eax,%rdx
  806752:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806759:	48 89 d6             	mov    %rdx,%rsi
  80675c:	48 89 c7             	mov    %rax,%rdi
  80675f:	48 b8 a7 47 80 00 00 	movabs $0x8047a7,%rax
  806766:	00 00 00 
  806769:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80676b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80676e:	01 45 fc             	add    %eax,-0x4(%rbp)
  806771:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806774:	48 98                	cltq   
  806776:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80677d:	0f 82 78 ff ff ff    	jb     8066fb <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  806783:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806786:	c9                   	leaveq 
  806787:	c3                   	retq   

0000000000806788 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  806788:	55                   	push   %rbp
  806789:	48 89 e5             	mov    %rsp,%rbp
  80678c:	48 83 ec 08          	sub    $0x8,%rsp
  806790:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  806794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806799:	c9                   	leaveq 
  80679a:	c3                   	retq   

000000000080679b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80679b:	55                   	push   %rbp
  80679c:	48 89 e5             	mov    %rsp,%rbp
  80679f:	48 83 ec 10          	sub    $0x10,%rsp
  8067a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8067a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8067ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067af:	48 be 2a 75 80 00 00 	movabs $0x80752a,%rsi
  8067b6:	00 00 00 
  8067b9:	48 89 c7             	mov    %rax,%rdi
  8067bc:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  8067c3:	00 00 00 
  8067c6:	ff d0                	callq  *%rax
	return 0;
  8067c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8067cd:	c9                   	leaveq 
  8067ce:	c3                   	retq   
