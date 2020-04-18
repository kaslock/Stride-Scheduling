
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 73 10 80       	push   $0x801073e0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 75 46 00 00       	call   801046d0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 73 10 80       	push   $0x801073e7
80100097:	50                   	push   %eax
80100098:	e8 03 45 00 00       	call   801045a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 27 47 00 00       	call   80104810 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 69 47 00 00       	call   801048d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 44 00 00       	call   801045e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 73 10 80       	push   $0x801073ee
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 cd 44 00 00       	call   80104680 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 73 10 80       	push   $0x801073ff
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 8c 44 00 00       	call   80104680 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 44 00 00       	call   80104640 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 00 46 00 00       	call   80104810 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 6f 46 00 00       	jmp    801048d0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 74 10 80       	push   $0x80107406
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 7f 45 00 00       	call   80104810 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002a7:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002c5:	e8 16 3f 00 00       	call   801041e0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 38 00 00       	call   80103ba0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 dc 45 00 00       	call   801048d0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 7e 45 00 00       	call   801048d0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 25 00 00       	call   801028d0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 74 10 80       	push   $0x8010740d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 5b 7d 10 80 	movl   $0x80107d5b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 43 00 00       	call   801046f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 74 10 80       	push   $0x80107421
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 b1 5b 00 00       	call   80105ff0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ff 5a 00 00       	call   80105ff0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 f3 5a 00 00       	call   80105ff0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 e7 5a 00 00       	call   80105ff0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 a7 44 00 00       	call   801049d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 da 43 00 00       	call   80104920 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 74 10 80       	push   $0x80107425
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 50 74 10 80 	movzbl -0x7fef8bb0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 f0 41 00 00       	call   80104810 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 84 42 00 00       	call   801048d0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 ac 41 00 00       	call   801048d0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 38 74 10 80       	mov    $0x80107438,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 1b 40 00 00       	call   80104810 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 74 10 80       	push   $0x8010743f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 e8 3f 00 00       	call   80104810 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100856:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 43 40 00 00       	call   801048d0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100911:	68 c0 ff 10 80       	push   $0x8010ffc0
80100916:	e8 b5 3a 00 00       	call   801043d0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010093d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100964:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 44 3b 00 00       	jmp    801044e0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 48 74 10 80       	push   $0x80107448
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 fb 3c 00 00       	call   801046d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 7f 31 00 00       	call   80103ba0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 14 23 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 3c 23 00 00       	call   80102db0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 a7 66 00 00       	call   80107140 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 65 64 00 00       	call   80106f60 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 73 63 00 00       	call   80106ea0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 49 65 00 00       	call   801070c0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 11 22 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 b1 63 00 00       	call   80106f60 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 fa 64 00 00       	call   801070c0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 21 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 61 74 10 80       	push   $0x80107461
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 d5 65 00 00       	call   801071e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 02 3f 00 00       	call   80104b40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 3e 00 00       	call   80104b40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 de 66 00 00       	call   80107340 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 74 66 00 00       	call   80107340 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 f1 3d 00 00       	call   80104b00 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 d7 5f 00 00       	call   80106d10 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 7f 63 00 00       	call   801070c0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 6d 74 10 80       	push   $0x8010746d
80100d6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d70:	e8 5b 39 00 00       	call   801046d0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 7a 3a 00 00       	call   80104810 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc1:	e8 0a 3b 00 00       	call   801048d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dda:	e8 f1 3a 00 00       	call   801048d0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dff:	e8 0c 3a 00 00       	call   80104810 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e1c:	e8 af 3a 00 00       	call   801048d0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 74 74 10 80       	push   $0x80107474
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e51:	e8 ba 39 00 00       	call   80104810 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 4f 3a 00 00       	jmp    801048d0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 23 3a 00 00       	call   801048d0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 1a 26 00 00       	call   801034f0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 5b 1e 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 b1 1e 00 00       	jmp    80102db0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 7c 74 10 80       	push   $0x8010747c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 26 00 00       	jmp    801036a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 86 74 10 80       	push   $0x80107486
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 62 1d 00 00       	call   80102db0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 c5 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 fe 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 9e 24 00 00       	jmp    80103590 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 8f 74 10 80       	push   $0x8010748f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 95 74 10 80       	push   $0x80107495
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 9f 74 10 80       	push   $0x8010749f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 3e 1d 00 00       	call   80102f10 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 26 37 00 00       	call   80104920 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 00 0a 11 80       	push   $0x80110a00
8010123a:	e8 d1 35 00 00       	call   80104810 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 2c 36 00 00       	call   801048d0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 fe 35 00 00       	call   801048d0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 b5 74 10 80       	push   $0x801074b5
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 ad 1b 00 00       	call   80102f10 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 c5 74 10 80       	push   $0x801074c5
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 da 35 00 00       	call   801049d0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 e0 09 11 80       	push   $0x801109e0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 a1 1a 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 d8 74 10 80       	push   $0x801074d8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 eb 74 10 80       	push   $0x801074eb
801014a1:	68 00 0a 11 80       	push   $0x80110a00
801014a6:	e8 25 32 00 00       	call   801046d0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 f2 74 10 80       	push   $0x801074f2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 dc 30 00 00       	call   801045a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 e0 09 11 80       	push   $0x801109e0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014e5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014eb:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014f1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014f7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014fd:	ff 35 e4 09 11 80    	pushl  0x801109e4
80101503:	ff 35 e0 09 11 80    	pushl  0x801109e0
80101509:	68 58 75 10 80       	push   $0x80107558
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 7d 33 00 00       	call   80104920 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 5b 19 00 00       	call   80102f10 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 f8 74 10 80       	push   $0x801074f8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 8a 33 00 00       	call   801049d0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 c2 18 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 00 0a 11 80       	push   $0x80110a00
8010166f:	e8 9c 31 00 00       	call   80104810 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010167f:	e8 4c 32 00 00       	call   801048d0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 29 2f 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 a3 32 00 00       	call   801049d0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 10 75 10 80       	push   $0x80107510
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 0a 75 10 80       	push   $0x8010750a
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 f8 2e 00 00       	call   80104680 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 9c 2e 00 00       	jmp    80104640 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 1f 75 10 80       	push   $0x8010751f
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 0b 2e 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 51 2e 00 00       	call   80104640 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017f6:	e8 15 30 00 00       	call   80104810 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 bb 30 00 00       	jmp    801048d0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 0a 11 80       	push   $0x80110a00
80101820:	e8 eb 2f 00 00       	call   80104810 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010182f:	e8 9c 30 00 00       	call   801048d0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 b4 2f 00 00       	call   801049d0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 b8 2e 00 00       	call   801049d0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 f0 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 8d 2e 00 00       	call   80104a40 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 2e 2e 00 00       	call   80104a40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 39 75 10 80       	push   $0x80107539
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 27 75 10 80       	push   $0x80107527
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 12 1f 00 00       	call   80103ba0 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 0a 11 80       	push   $0x80110a00
80101c99:	e8 72 2b 00 00       	call   80104810 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca9:	e8 22 2c 00 00       	call   801048d0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 c6 2c 00 00       	call   801049d0 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 33 2c 00 00       	call   801049d0 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 0e 2c 00 00       	call   80104aa0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 48 75 10 80       	push   $0x80107548
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 42 7b 10 80       	push   $0x80107b42
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 b4 75 10 80       	push   $0x801075b4
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 ab 75 10 80       	push   $0x801075ab
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 c6 75 10 80       	push   $0x801075c6
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 ab 26 00 00       	call   801046d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 40 2d 11 80       	mov    0x80112d40,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 a5 10 80       	push   $0x8010a580
8010209e:	e8 6d 27 00 00       	call   80104810 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 ca 22 00 00       	call   801043d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 a5 10 80       	push   $0x8010a580
8010211f:	e8 ac 27 00 00       	call   801048d0 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 3d 25 00 00       	call   80104680 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	e8 93 26 00 00       	call   80104810 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	53                   	push   %ebx
801021c9:	e8 12 20 00 00       	call   801041e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 e5 26 00 00       	jmp    801048d0 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 e0 75 10 80       	push   $0x801075e0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 ca 75 10 80       	push   $0x801075ca
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 f5 75 10 80       	push   $0x801075f5
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 54 26 11 80       	mov    0x80112654,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 14 76 10 80       	push   $0x80107614
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb a8 36 11 80    	cmp    $0x801136a8,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 c9 25 00 00       	call   80104920 <memset>

  if (kmem.use_lock)
80102357:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
80102364:	a1 98 26 11 80       	mov    0x80112698,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if (kmem.use_lock)
8010236b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102370:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if (kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 40 25 00 00       	jmp    801048d0 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 60 26 11 80       	push   $0x80112660
80102398:	e8 73 24 00 00       	call   80104810 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 46 76 10 80       	push   $0x80107646
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char *)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 4c 76 10 80       	push   $0x8010764c
80102410:	68 60 26 11 80       	push   $0x80112660
80102415:	e8 b6 22 00 00       	call   801046d0 <initlock>
  p = (char *)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102427:	00 00 00 
  p = (char *)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char *)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char *)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char *
kalloc(void)
{
  struct run *r;

  if (kmem.use_lock)
801024d0:	a1 94 26 11 80       	mov    0x80112694,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 98 26 11 80    	mov    %edx,0x80112698
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (kmem.use_lock)
    release(&kmem.lock);
  return (char *)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 60 26 11 80       	push   $0x80112660
80102503:	e8 08 23 00 00       	call   80104810 <acquire>
  r = kmem.freelist;
80102508:	a1 98 26 11 80       	mov    0x80112698,%eax
  if (r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if (kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 60 26 11 80       	push   $0x80112660
80102531:	e8 9a 23 00 00       	call   801048d0 <release>
  return (char *)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <k_free>:
Header *base_p;
char *sbrk_addr;
static Header *freep;

void k_free(void *ap)
{
80102540:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header *)ap - 1;
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
80102541:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
{
80102546:	89 e5                	mov    %esp,%ebp
80102548:	57                   	push   %edi
80102549:	56                   	push   %esi
8010254a:	53                   	push   %ebx
8010254b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header *)ap - 1;
8010254e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
80102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
80102558:	39 c8                	cmp    %ecx,%eax
8010255a:	8b 10                	mov    (%eax),%edx
8010255c:	73 32                	jae    80102590 <k_free+0x50>
8010255e:	39 d1                	cmp    %edx,%ecx
80102560:	72 04                	jb     80102566 <k_free+0x26>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
80102562:	39 d0                	cmp    %edx,%eax
80102564:	72 32                	jb     80102598 <k_free+0x58>
      break;
  if (bp + bp->s.size == p->s.ptr)
80102566:	8b 73 fc             	mov    -0x4(%ebx),%esi
80102569:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
8010256c:	39 fa                	cmp    %edi,%edx
8010256e:	74 30                	je     801025a0 <k_free+0x60>
  {
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  }
  else
    bp->s.ptr = p->s.ptr;
80102570:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if (p + p->s.size == bp)
80102573:	8b 50 04             	mov    0x4(%eax),%edx
80102576:	8d 34 d0             	lea    (%eax,%edx,8),%esi
80102579:	39 f1                	cmp    %esi,%ecx
8010257b:	74 3a                	je     801025b7 <k_free+0x77>
  {
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  }
  else
    p->s.ptr = bp;
8010257d:	89 08                	mov    %ecx,(%eax)
  freep = p;
8010257f:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
}
80102584:	5b                   	pop    %ebx
80102585:	5e                   	pop    %esi
80102586:	5f                   	pop    %edi
80102587:	5d                   	pop    %ebp
80102588:	c3                   	ret    
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
80102590:	39 d0                	cmp    %edx,%eax
80102592:	72 04                	jb     80102598 <k_free+0x58>
80102594:	39 d1                	cmp    %edx,%ecx
80102596:	72 ce                	jb     80102566 <k_free+0x26>
{
80102598:	89 d0                	mov    %edx,%eax
8010259a:	eb bc                	jmp    80102558 <k_free+0x18>
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
801025a0:	03 72 04             	add    0x4(%edx),%esi
801025a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
801025a6:	8b 10                	mov    (%eax),%edx
801025a8:	8b 12                	mov    (%edx),%edx
801025aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if (p + p->s.size == bp)
801025ad:	8b 50 04             	mov    0x4(%eax),%edx
801025b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
801025b3:	39 f1                	cmp    %esi,%ecx
801025b5:	75 c6                	jne    8010257d <k_free+0x3d>
    p->s.size += bp->s.size;
801025b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
801025ba:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    p->s.size += bp->s.size;
801025bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
801025c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
801025c5:	89 10                	mov    %edx,(%eax)
}
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5f                   	pop    %edi
801025ca:	5d                   	pop    %ebp
801025cb:	c3                   	ret    
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025d0 <k_malloc>:
  }
}

void *
k_malloc(uint nbytes)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
801025d4:	53                   	push   %ebx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
801025d5:	8b 45 08             	mov    0x8(%ebp),%eax
801025d8:	8d 70 07             	lea    0x7(%eax),%esi
  if ((prevp = freep) == 0)
801025db:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
801025e0:	c1 ee 03             	shr    $0x3,%esi
801025e3:	83 c6 01             	add    $0x1,%esi
  if ((prevp = freep) == 0)
801025e6:	85 c0                	test   %eax,%eax
801025e8:	0f 84 92 00 00 00    	je     80102680 <k_malloc+0xb0>
        base_p = (Header *)temp_p;
    }
    base_p->s.ptr = freep = prevp = base_p;
    base_p->s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
801025ee:	8b 10                	mov    (%eax),%edx
801025f0:	bb 00 10 00 00       	mov    $0x1000,%ebx
  {
    if (p->s.size >= nunits)
801025f5:	8b 4a 04             	mov    0x4(%edx),%ecx
801025f8:	39 ce                	cmp    %ecx,%esi
801025fa:	77 0d                	ja     80102609 <k_malloc+0x39>
801025fc:	eb 62                	jmp    80102660 <k_malloc+0x90>
801025fe:	66 90                	xchg   %ax,%ax
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
80102600:	8b 10                	mov    (%eax),%edx
    if (p->s.size >= nunits)
80102602:	8b 4a 04             	mov    0x4(%edx),%ecx
80102605:	39 f1                	cmp    %esi,%ecx
80102607:	73 57                	jae    80102660 <k_malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
80102609:	39 15 b4 a5 10 80    	cmp    %edx,0x8010a5b4
8010260f:	89 d0                	mov    %edx,%eax
80102611:	75 ed                	jne    80102600 <k_malloc+0x30>
  if (first)
80102613:	a1 00 80 10 80       	mov    0x80108000,%eax
80102618:	85 c0                	test   %eax,%eax
8010261a:	74 3a                	je     80102656 <k_malloc+0x86>
    p = sbrk_addr;
8010261c:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102621:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80102627:	89 da                	mov    %ebx,%edx
80102629:	0f 43 d6             	cmovae %esi,%edx
    first = 0;
8010262c:	c7 05 00 80 10 80 00 	movl   $0x0,0x80108000
80102633:	00 00 00 
    if (p == (char *)-1)
80102636:	83 f8 ff             	cmp    $0xffffffff,%eax
80102639:	74 1b                	je     80102656 <k_malloc+0x86>
    hp->s.size = nu;
8010263b:	89 50 04             	mov    %edx,0x4(%eax)
    k_free((void *)(hp + 1));
8010263e:	83 ec 0c             	sub    $0xc,%esp
80102641:	83 c0 08             	add    $0x8,%eax
80102644:	50                   	push   %eax
80102645:	e8 f6 fe ff ff       	call   80102540 <k_free>
    return freep;
8010264a:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
      if ((p = kmorecore(nunits)) == 0)
8010264f:	83 c4 10             	add    $0x10,%esp
80102652:	85 c0                	test   %eax,%eax
80102654:	75 aa                	jne    80102600 <k_malloc+0x30>
        return 0;
  }
}
80102656:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 0;
80102659:	31 c0                	xor    %eax,%eax
}
8010265b:	5b                   	pop    %ebx
8010265c:	5e                   	pop    %esi
8010265d:	5d                   	pop    %ebp
8010265e:	c3                   	ret    
8010265f:	90                   	nop
      if (p->s.size == nunits)
80102660:	39 f1                	cmp    %esi,%ecx
80102662:	74 44                	je     801026a8 <k_malloc+0xd8>
        p->s.size -= nunits;
80102664:	29 f1                	sub    %esi,%ecx
80102666:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
80102669:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
8010266c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
8010266f:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
}
80102674:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return (void *)(p + 1);
80102677:	8d 42 08             	lea    0x8(%edx),%eax
}
8010267a:	5b                   	pop    %ebx
8010267b:	5e                   	pop    %esi
8010267c:	5d                   	pop    %ebp
8010267d:	c3                   	ret    
8010267e:	66 90                	xchg   %ax,%ax
80102680:	31 db                	xor    %ebx,%ebx
80102682:	eb 0c                	jmp    80102690 <k_malloc+0xc0>
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (i == 8)
80102688:	83 fb 08             	cmp    $0x8,%ebx
8010268b:	74 21                	je     801026ae <k_malloc+0xde>
8010268d:	83 c3 01             	add    $0x1,%ebx
      char *temp_p = kalloc();
80102690:	e8 3b fe ff ff       	call   801024d0 <kalloc>
      if (i == 7)
80102695:	83 fb 07             	cmp    $0x7,%ebx
80102698:	75 ee                	jne    80102688 <k_malloc+0xb8>
        sbrk_addr = temp_p;
8010269a:	a3 a0 26 11 80       	mov    %eax,0x801126a0
8010269f:	eb ec                	jmp    8010268d <k_malloc+0xbd>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
801026a8:	8b 0a                	mov    (%edx),%ecx
801026aa:	89 08                	mov    %ecx,(%eax)
801026ac:	eb c1                	jmp    8010266f <k_malloc+0x9f>
        base_p = (Header *)temp_p;
801026ae:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    base_p->s.ptr = freep = prevp = base_p;
801026b3:	89 00                	mov    %eax,(%eax)
    base_p->s.size = 0;
801026b5:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
    base_p->s.ptr = freep = prevp = base_p;
801026bb:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    base_p->s.size = 0;
801026c0:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
801026c7:	e9 22 ff ff ff       	jmp    801025ee <k_malloc+0x1e>
801026cc:	66 90                	xchg   %ax,%ax
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d0:	ba 64 00 00 00       	mov    $0x64,%edx
801026d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026d6:	a8 01                	test   $0x1,%al
801026d8:	0f 84 c2 00 00 00    	je     801027a0 <kbdgetc+0xd0>
801026de:	ba 60 00 00 00       	mov    $0x60,%edx
801026e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026e4:	0f b6 d0             	movzbl %al,%edx
801026e7:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx

  if(data == 0xE0){
801026ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026f3:	0f 84 7f 00 00 00    	je     80102778 <kbdgetc+0xa8>
{
801026f9:	55                   	push   %ebp
801026fa:	89 e5                	mov    %esp,%ebp
801026fc:	53                   	push   %ebx
801026fd:	89 cb                	mov    %ecx,%ebx
801026ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102702:	84 c0                	test   %al,%al
80102704:	78 4a                	js     80102750 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102706:	85 db                	test   %ebx,%ebx
80102708:	74 09                	je     80102713 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010270a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010270d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102710:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102713:	0f b6 82 80 77 10 80 	movzbl -0x7fef8880(%edx),%eax
8010271a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010271c:	0f b6 82 80 76 10 80 	movzbl -0x7fef8980(%edx),%eax
80102723:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102725:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102727:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102730:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102733:	8b 04 85 60 76 10 80 	mov    -0x7fef89a0(,%eax,4),%eax
8010273a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010273e:	74 31                	je     80102771 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102740:	8d 50 9f             	lea    -0x61(%eax),%edx
80102743:	83 fa 19             	cmp    $0x19,%edx
80102746:	77 40                	ja     80102788 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102748:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102750:	83 e0 7f             	and    $0x7f,%eax
80102753:	85 db                	test   %ebx,%ebx
80102755:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102758:	0f b6 82 80 77 10 80 	movzbl -0x7fef8880(%edx),%eax
8010275f:	83 c8 40             	or     $0x40,%eax
80102762:	0f b6 c0             	movzbl %al,%eax
80102765:	f7 d0                	not    %eax
80102767:	21 c1                	and    %eax,%ecx
    return 0;
80102769:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010276b:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
}
80102771:	5b                   	pop    %ebx
80102772:	5d                   	pop    %ebp
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102778:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010277b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010277d:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
    return 0;
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102788:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010278b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010278e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010278f:	83 f9 1a             	cmp    $0x1a,%ecx
80102792:	0f 42 c2             	cmovb  %edx,%eax
}
80102795:	5d                   	pop    %ebp
80102796:	c3                   	ret    
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027a5:	c3                   	ret    
801027a6:	8d 76 00             	lea    0x0(%esi),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <kbdintr>:

void
kbdintr(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027b6:	68 d0 26 10 80       	push   $0x801026d0
801027bb:	e8 50 e0 ff ff       	call   80100810 <consoleintr>
}
801027c0:	83 c4 10             	add    $0x10,%esp
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	66 90                	xchg   %ax,%ax
801027c7:	66 90                	xchg   %ax,%ax
801027c9:	66 90                	xchg   %ax,%ax
801027cb:	66 90                	xchg   %ax,%ax
801027cd:	66 90                	xchg   %ax,%ax
801027cf:	90                   	nop

801027d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027d0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	0f 84 c8 00 00 00    	je     801028a8 <lapicinit+0xd8>
  lapic[index] = value;
801027e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102801:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010280e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010281b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010282e:	8b 50 30             	mov    0x30(%eax),%edx
80102831:	c1 ea 10             	shr    $0x10,%edx
80102834:	80 fa 03             	cmp    $0x3,%dl
80102837:	77 77                	ja     801028b0 <lapicinit+0xe0>
  lapic[index] = value;
80102839:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102840:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102843:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102846:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102881:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
80102887:	89 f6                	mov    %esi,%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102890:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102896:	80 e6 10             	and    $0x10,%dh
80102899:	75 f5                	jne    80102890 <lapicinit+0xc0>
  lapic[index] = value;
8010289b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801028b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
801028bd:	e9 77 ff ff ff       	jmp    80102839 <lapicinit+0x69>
801028c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	8b 15 a4 26 11 80    	mov    0x801126a4,%edx
{
801028d6:	55                   	push   %ebp
801028d7:	31 c0                	xor    %eax,%eax
801028d9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028db:	85 d2                	test   %edx,%edx
801028dd:	74 06                	je     801028e5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801028df:	8b 42 20             	mov    0x20(%edx),%eax
801028e2:	c1 e8 18             	shr    $0x18,%eax
}
801028e5:	5d                   	pop    %ebp
801028e6:	c3                   	ret    
801028e7:	89 f6                	mov    %esi,%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 a4 26 11 80       	mov    0x801126a4,%eax
{
801028f5:	55                   	push   %ebp
801028f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028f8:	85 c0                	test   %eax,%eax
801028fa:	74 0d                	je     80102909 <lapiceoi+0x19>
  lapic[index] = value;
801028fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102903:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102906:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102909:	5d                   	pop    %ebp
8010290a:	c3                   	ret    
8010290b:	90                   	nop
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
}
80102913:	5d                   	pop    %ebp
80102914:	c3                   	ret    
80102915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102950:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102953:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	5b                   	pop    %ebx
801029ab:	5d                   	pop    %ebp
801029ac:	c3                   	ret    
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 da                	mov    %ebx,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 da                	mov    %ebx,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 da                	mov    %ebx,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 da                	mov    %ebx,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 da                	mov    %ebx,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	89 ca                	mov    %ecx,%edx
80102a36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a37:	84 c0                	test   %al,%al
80102a39:	78 9d                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a3f:	89 fa                	mov    %edi,%edx
80102a41:	0f b6 fa             	movzbl %dl,%edi
80102a44:	89 f2                	mov    %esi,%edx
80102a46:	0f b6 f2             	movzbl %dl,%esi
80102a49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a69:	31 c0                	xor    %eax,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al
80102a6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a72:	89 da                	mov    %ebx,%edx
80102a74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a77:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7d:	89 ca                	mov    %ecx,%edx
80102a7f:	ec                   	in     (%dx),%al
80102a80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a83:	89 da                	mov    %ebx,%edx
80102a85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a99:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9f:	89 ca                	mov    %ecx,%edx
80102aa1:	ec                   	in     (%dx),%al
80102aa2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa5:	89 da                	mov    %ebx,%edx
80102aa7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aaa:	b8 08 00 00 00       	mov    $0x8,%eax
80102aaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	89 ca                	mov    %ecx,%edx
80102ab2:	ec                   	in     (%dx),%al
80102ab3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab6:	89 da                	mov    %ebx,%edx
80102ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102abb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac1:	89 ca                	mov    %ecx,%edx
80102ac3:	ec                   	in     (%dx),%al
80102ac4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102acd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ad0:	6a 18                	push   $0x18
80102ad2:	50                   	push   %eax
80102ad3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad6:	50                   	push   %eax
80102ad7:	e8 94 1e 00 00       	call   80104970 <memcmp>
80102adc:	83 c4 10             	add    $0x10,%esp
80102adf:	85 c0                	test   %eax,%eax
80102ae1:	0f 85 f1 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102aeb:	75 78                	jne    80102b65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102aed:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	83 e0 0f             	and    $0xf,%eax
80102af5:	c1 ea 04             	shr    $0x4,%edx
80102af8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b04:	89 c2                	mov    %eax,%edx
80102b06:	83 e0 0f             	and    $0xf,%eax
80102b09:	c1 ea 04             	shr    $0x4,%edx
80102b0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b18:	89 c2                	mov    %eax,%edx
80102b1a:	83 e0 0f             	and    $0xf,%eax
80102b1d:	c1 ea 04             	shr    $0x4,%edx
80102b20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	83 e0 0f             	and    $0xf,%eax
80102b31:	c1 ea 04             	shr    $0x4,%edx
80102b34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b65:	8b 75 08             	mov    0x8(%ebp),%esi
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 06                	mov    %eax,(%esi)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 46 04             	mov    %eax,0x4(%esi)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 46 08             	mov    %eax,0x8(%esi)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 46 10             	mov    %eax,0x10(%esi)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret    
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
80102bb2:	56                   	push   %esi
80102bb3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb4:	31 db                	xor    %ebx,%ebx
{
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 d8                	add    %ebx,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 04 27 11 80    	pushl  0x80112704
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 9d 0c 27 11 80 	pushl  -0x7feed8f4(,%ebx,4)
80102be4:	ff 35 04 27 11 80    	pushl  0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
80102bf2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bf7:	83 c4 0c             	add    $0xc,%esp
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 c7 1d 00 00       	call   801049d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 34 24             	mov    %esi,(%esp)
80102c0c:	e8 8f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c11:	89 3c 24             	mov    %edi,(%esp)
80102c14:	e8 c7 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c19:	89 34 24             	mov    %esi,(%esp)
80102c1c:	e8 bf d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 1d 08 27 11 80    	cmp    %ebx,0x80112708
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	f3 c3                	repz ret 
80102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	56                   	push   %esi
80102c44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	ff 35 f4 26 11 80    	pushl  0x801126f4
80102c4e:	ff 35 04 27 11 80    	pushl  0x80112704
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c59:	8b 1d 08 27 11 80    	mov    0x80112708,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c69:	7e 16                	jle    80102c81 <write_head+0x41>
80102c6b:	c1 e3 02             	shl    $0x2,%ebx
80102c6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c70:	8b 8a 0c 27 11 80    	mov    -0x7feed8f4(%edx),%ecx
80102c76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c7d:	39 da                	cmp    %ebx,%edx
80102c7f:	75 ef                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c81:	83 ec 0c             	sub    $0xc,%esp
80102c84:	56                   	push   %esi
80102c85:	e8 16 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c8a:	89 34 24             	mov    %esi,(%esp)
80102c8d:	e8 4e d5 ff ff       	call   801001e0 <brelse>
}
80102c92:	83 c4 10             	add    $0x10,%esp
80102c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c98:	5b                   	pop    %ebx
80102c99:	5e                   	pop    %esi
80102c9a:	5d                   	pop    %ebp
80102c9b:	c3                   	ret    
80102c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 80 78 10 80       	push   $0x80107880
80102caf:	68 c0 26 11 80       	push   $0x801126c0
80102cb4:	e8 17 1a 00 00       	call   801046d0 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 0b e7 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102cc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	59                   	pop    %ecx
  log.dev = dev;
80102ccc:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102cd2:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  log.start = sb.logstart;
80102cd8:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ce5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
80102ceb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ced:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102cf3:	7e 1c                	jle    80102d11 <initlog+0x71>
80102cf5:	c1 e3 02             	shl    $0x2,%ebx
80102cf8:	31 d2                	xor    %edx,%edx
80102cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d04:	83 c2 04             	add    $0x4,%edx
80102d07:	89 8a 08 27 11 80    	mov    %ecx,-0x7feed8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d0d:	39 d3                	cmp    %edx,%ebx
80102d0f:	75 ef                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d11:	83 ec 0c             	sub    $0xc,%esp
80102d14:	50                   	push   %eax
80102d15:	e8 c6 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1a:	e8 81 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d1f:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102d26:	00 00 00 
  write_head(); // clear the log
80102d29:	e8 12 ff ff ff       	call   80102c40 <write_head>
}
80102d2e:	83 c4 10             	add    $0x10,%esp
80102d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d34:	c9                   	leave  
80102d35:	c3                   	ret    
80102d36:	8d 76 00             	lea    0x0(%esi),%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 c0 26 11 80       	push   $0x801126c0
80102d4b:	e8 c0 1a 00 00       	call   80104810 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 c0 26 11 80       	push   $0x801126c0
80102d60:	68 c0 26 11 80       	push   $0x801126c0
80102d65:	e8 76 14 00 00       	call   801041e0 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102d7b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102d97:	68 c0 26 11 80       	push   $0x801126c0
80102d9c:	e8 2f 1b 00 00       	call   801048d0 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave  
80102da5:	c3                   	ret    
80102da6:	8d 76 00             	lea    0x0(%esi),%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 c0 26 11 80       	push   $0x801126c0
80102dbe:	e8 4d 1a 00 00       	call   80104810 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102dc8:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102dd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102dd6:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102ddc:	0f 85 1a 01 00 00    	jne    80102efc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 ee 00 00 00    	jne    80102ed8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102dea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ded:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102df4:	00 00 00 
  release(&log.lock);
80102df7:	68 c0 26 11 80       	push   $0x801126c0
80102dfc:	e8 cf 1a 00 00       	call   801048d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	0f 8e 85 00 00 00    	jle    80102e97 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e12:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102e17:	83 ec 08             	sub    $0x8,%esp
80102e1a:	01 d8                	add    %ebx,%eax
80102e1c:	83 c0 01             	add    $0x1,%eax
80102e1f:	50                   	push   %eax
80102e20:	ff 35 04 27 11 80    	pushl  0x80112704
80102e26:	e8 a5 d2 ff ff       	call   801000d0 <bread>
80102e2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e2d:	58                   	pop    %eax
80102e2e:	5a                   	pop    %edx
80102e2f:	ff 34 9d 0c 27 11 80 	pushl  -0x7feed8f4(,%ebx,4)
80102e36:	ff 35 04 27 11 80    	pushl  0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102e3c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e3f:	e8 8c d2 ff ff       	call   801000d0 <bread>
80102e44:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e46:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e49:	83 c4 0c             	add    $0xc,%esp
80102e4c:	68 00 02 00 00       	push   $0x200
80102e51:	50                   	push   %eax
80102e52:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e55:	50                   	push   %eax
80102e56:	e8 75 1b 00 00       	call   801049d0 <memmove>
    bwrite(to);  // write the log
80102e5b:	89 34 24             	mov    %esi,(%esp)
80102e5e:	e8 3d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e63:	89 3c 24             	mov    %edi,(%esp)
80102e66:	e8 75 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e6b:	89 34 24             	mov    %esi,(%esp)
80102e6e:	e8 6d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e73:	83 c4 10             	add    $0x10,%esp
80102e76:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
80102e7c:	7c 94                	jl     80102e12 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e7e:	e8 bd fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102e83:	e8 18 fd ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102e88:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102e8f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e92:	e8 a9 fd ff ff       	call   80102c40 <write_head>
    acquire(&log.lock);
80102e97:	83 ec 0c             	sub    $0xc,%esp
80102e9a:	68 c0 26 11 80       	push   $0x801126c0
80102e9f:	e8 6c 19 00 00       	call   80104810 <acquire>
    wakeup(&log);
80102ea4:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80102eab:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80102eb2:	00 00 00 
    wakeup(&log);
80102eb5:	e8 16 15 00 00       	call   801043d0 <wakeup>
    release(&log.lock);
80102eba:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102ec1:	e8 0a 1a 00 00       	call   801048d0 <release>
80102ec6:	83 c4 10             	add    $0x10,%esp
}
80102ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ecc:	5b                   	pop    %ebx
80102ecd:	5e                   	pop    %esi
80102ece:	5f                   	pop    %edi
80102ecf:	5d                   	pop    %ebp
80102ed0:	c3                   	ret    
80102ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102ed8:	83 ec 0c             	sub    $0xc,%esp
80102edb:	68 c0 26 11 80       	push   $0x801126c0
80102ee0:	e8 eb 14 00 00       	call   801043d0 <wakeup>
  release(&log.lock);
80102ee5:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102eec:	e8 df 19 00 00       	call   801048d0 <release>
80102ef1:	83 c4 10             	add    $0x10,%esp
}
80102ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef7:	5b                   	pop    %ebx
80102ef8:	5e                   	pop    %esi
80102ef9:	5f                   	pop    %edi
80102efa:	5d                   	pop    %ebp
80102efb:	c3                   	ret    
    panic("log.committing");
80102efc:	83 ec 0c             	sub    $0xc,%esp
80102eff:	68 84 78 10 80       	push   $0x80107884
80102f04:	e8 87 d4 ff ff       	call   80100390 <panic>
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f17:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
80102f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f20:	83 fa 1d             	cmp    $0x1d,%edx
80102f23:	0f 8f 9d 00 00 00    	jg     80102fc6 <log_write+0xb6>
80102f29:	a1 f8 26 11 80       	mov    0x801126f8,%eax
80102f2e:	83 e8 01             	sub    $0x1,%eax
80102f31:	39 c2                	cmp    %eax,%edx
80102f33:	0f 8d 8d 00 00 00    	jge    80102fc6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f39:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102f3e:	85 c0                	test   %eax,%eax
80102f40:	0f 8e 8d 00 00 00    	jle    80102fd3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f46:	83 ec 0c             	sub    $0xc,%esp
80102f49:	68 c0 26 11 80       	push   $0x801126c0
80102f4e:	e8 bd 18 00 00       	call   80104810 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f53:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102f59:	83 c4 10             	add    $0x10,%esp
80102f5c:	83 f9 00             	cmp    $0x0,%ecx
80102f5f:	7e 57                	jle    80102fb8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f61:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f64:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f66:	3b 15 0c 27 11 80    	cmp    0x8011270c,%edx
80102f6c:	75 0b                	jne    80102f79 <log_write+0x69>
80102f6e:	eb 38                	jmp    80102fa8 <log_write+0x98>
80102f70:	39 14 85 0c 27 11 80 	cmp    %edx,-0x7feed8f4(,%eax,4)
80102f77:	74 2f                	je     80102fa8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f79:	83 c0 01             	add    $0x1,%eax
80102f7c:	39 c1                	cmp    %eax,%ecx
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 14 85 0c 27 11 80 	mov    %edx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f87:	83 c0 01             	add    $0x1,%eax
80102f8a:	a3 08 27 11 80       	mov    %eax,0x80112708
  b->flags |= B_DIRTY; // prevent eviction
80102f8f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f92:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80102f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f9c:	c9                   	leave  
  release(&log.lock);
80102f9d:	e9 2e 19 00 00       	jmp    801048d0 <release>
80102fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa8:	89 14 85 0c 27 11 80 	mov    %edx,-0x7feed8f4(,%eax,4)
80102faf:	eb de                	jmp    80102f8f <log_write+0x7f>
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fb8:	8b 43 08             	mov    0x8(%ebx),%eax
80102fbb:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
80102fc0:	75 cd                	jne    80102f8f <log_write+0x7f>
80102fc2:	31 c0                	xor    %eax,%eax
80102fc4:	eb c1                	jmp    80102f87 <log_write+0x77>
    panic("too big a transaction");
80102fc6:	83 ec 0c             	sub    $0xc,%esp
80102fc9:	68 93 78 10 80       	push   $0x80107893
80102fce:	e8 bd d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fd3:	83 ec 0c             	sub    $0xc,%esp
80102fd6:	68 a9 78 10 80       	push   $0x801078a9
80102fdb:	e8 b0 d3 ff ff       	call   80100390 <panic>

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 94 0b 00 00       	call   80103b80 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 8d 0b 00 00       	call   80103b80 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 c4 78 10 80       	push   $0x801078c4
80102ffd:	e8 5e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103002:	e8 f9 2b 00 00       	call   80105c00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 f4 0a 00 00       	call   80103b00 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 71 0e 00 00       	call   80103e90 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103026:	e8 c5 3c 00 00       	call   80106cf0 <switchkvm>
  seginit();
8010302b:	e8 30 3c 00 00       	call   80106c60 <seginit>
  lapicinit();
80103030:	e8 9b f7 ff ff       	call   801027d0 <lapicinit>
  mpmain();
80103035:	e8 a6 ff ff ff       	call   80102fe0 <mpmain>
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103044:	83 e4 f0             	and    $0xfffffff0,%esp
80103047:	ff 71 fc             	pushl  -0x4(%ecx)
8010304a:	55                   	push   %ebp
8010304b:	89 e5                	mov    %esp,%ebp
8010304d:	53                   	push   %ebx
8010304e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010304f:	83 ec 08             	sub    $0x8,%esp
80103052:	68 00 00 40 80       	push   $0x80400000
80103057:	68 a8 36 11 80       	push   $0x801136a8
8010305c:	e8 9f f3 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80103061:	e8 5a 41 00 00       	call   801071c0 <kvmalloc>
  mpinit();        // detect other processors
80103066:	e8 75 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010306b:	e8 60 f7 ff ff       	call   801027d0 <lapicinit>
  seginit();       // segment descriptors
80103070:	e8 eb 3b 00 00       	call   80106c60 <seginit>
  picinit();       // disable pic
80103075:	e8 46 03 00 00       	call   801033c0 <picinit>
  ioapicinit();    // another interrupt controller
8010307a:	e8 b1 f1 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
8010307f:	e8 3c d9 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103084:	e8 a7 2e 00 00       	call   80105f30 <uartinit>
  pinit();         // process table
80103089:	e8 42 0a 00 00       	call   80103ad0 <pinit>
  tvinit();        // trap vectors
8010308e:	e8 ed 2a 00 00       	call   80105b80 <tvinit>
  binit();         // buffer cache
80103093:	e8 a8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103098:	e8 c3 dc ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010309d:	e8 6e ef ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a2:	83 c4 0c             	add    $0xc,%esp
801030a5:	68 8a 00 00 00       	push   $0x8a
801030aa:	68 8c a4 10 80       	push   $0x8010a48c
801030af:	68 00 70 00 80       	push   $0x80007000
801030b4:	e8 17 19 00 00       	call   801049d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030b9:	69 05 40 2d 11 80 b0 	imul   $0xb0,0x80112d40,%eax
801030c0:	00 00 00 
801030c3:	83 c4 10             	add    $0x10,%esp
801030c6:	05 c0 27 11 80       	add    $0x801127c0,%eax
801030cb:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
801030d0:	76 71                	jbe    80103143 <main+0x103>
801030d2:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
801030d7:	89 f6                	mov    %esi,%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801030e0:	e8 1b 0a 00 00       	call   80103b00 <mycpu>
801030e5:	39 d8                	cmp    %ebx,%eax
801030e7:	74 41                	je     8010312a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030e9:	e8 e2 f3 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801030f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
801030fa:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030fd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103104:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103107:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010310c:	0f b6 03             	movzbl (%ebx),%eax
8010310f:	83 ec 08             	sub    $0x8,%esp
80103112:	68 00 70 00 00       	push   $0x7000
80103117:	50                   	push   %eax
80103118:	e8 03 f8 ff ff       	call   80102920 <lapicstartap>
8010311d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103120:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103126:	85 c0                	test   %eax,%eax
80103128:	74 f6                	je     80103120 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010312a:	69 05 40 2d 11 80 b0 	imul   $0xb0,0x80112d40,%eax
80103131:	00 00 00 
80103134:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010313a:	05 c0 27 11 80       	add    $0x801127c0,%eax
8010313f:	39 c3                	cmp    %eax,%ebx
80103141:	72 9d                	jb     801030e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103143:	83 ec 08             	sub    $0x8,%esp
80103146:	68 00 00 00 8e       	push   $0x8e000000
8010314b:	68 00 00 40 80       	push   $0x80400000
80103150:	e8 1b f3 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80103155:	e8 76 0a 00 00       	call   80103bd0 <userinit>
  mpmain();        // finish this processor's setup
8010315a:	e8 81 fe ff ff       	call   80102fe0 <mpmain>
8010315f:	90                   	nop

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	90                   	nop
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	39 fb                	cmp    %edi,%ebx
80103182:	89 fe                	mov    %edi,%esi
80103184:	76 42                	jbe    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 d8 78 10 80       	push   $0x801078d8
80103193:	56                   	push   %esi
80103194:	e8 d7 17 00 00       	call   80104970 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f1                	mov    %esi,%ecx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 11             	movzbl (%ecx),%edx
801031ab:	83 c1 01             	add    $0x1,%ecx
801031ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031b0:	39 f9                	cmp    %edi,%ecx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret    
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	89 f0                	mov    %esi,%eax
801031cf:	5b                   	pop    %ebx
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	85 c0                	test   %eax,%eax
80103201:	75 1b                	jne    8010321e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103203:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010320a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103211:	c1 e0 08             	shl    $0x8,%eax
80103214:	09 d0                	or     %edx,%eax
80103216:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103219:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321e:	ba 00 04 00 00       	mov    $0x400,%edx
80103223:	e8 38 ff ff ff       	call   80103160 <mpsearch1>
80103228:	85 c0                	test   %eax,%eax
8010322a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010322d:	0f 84 3d 01 00 00    	je     80103370 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103236:	8b 58 04             	mov    0x4(%eax),%ebx
80103239:	85 db                	test   %ebx,%ebx
8010323b:	0f 84 4f 01 00 00    	je     80103390 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103241:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	83 ec 04             	sub    $0x4,%esp
8010324a:	6a 04                	push   $0x4
8010324c:	68 f5 78 10 80       	push   $0x801078f5
80103251:	56                   	push   %esi
80103252:	e8 19 17 00 00       	call   80104970 <memcmp>
80103257:	83 c4 10             	add    $0x10,%esp
8010325a:	85 c0                	test   %eax,%eax
8010325c:	0f 85 2e 01 00 00    	jne    80103390 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103262:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103269:	3c 01                	cmp    $0x1,%al
8010326b:	0f 95 c2             	setne  %dl
8010326e:	3c 04                	cmp    $0x4,%al
80103270:	0f 95 c0             	setne  %al
80103273:	20 c2                	and    %al,%dl
80103275:	0f 85 15 01 00 00    	jne    80103390 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010327b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103282:	66 85 ff             	test   %di,%di
80103285:	74 1a                	je     801032a1 <mpinit+0xc1>
80103287:	89 f0                	mov    %esi,%eax
80103289:	01 f7                	add    %esi,%edi
  sum = 0;
8010328b:	31 d2                	xor    %edx,%edx
8010328d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103290:	0f b6 08             	movzbl (%eax),%ecx
80103293:	83 c0 01             	add    $0x1,%eax
80103296:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103298:	39 c7                	cmp    %eax,%edi
8010329a:	75 f4                	jne    80103290 <mpinit+0xb0>
8010329c:	84 d2                	test   %dl,%dl
8010329e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032a1:	85 f6                	test   %esi,%esi
801032a3:	0f 84 e7 00 00 00    	je     80103390 <mpinit+0x1b0>
801032a9:	84 d2                	test   %dl,%dl
801032ab:	0f 85 df 00 00 00    	jne    80103390 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032b7:	a3 a4 26 11 80       	mov    %eax,0x801126a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ce:	01 d6                	add    %edx,%esi
801032d0:	39 c6                	cmp    %eax,%esi
801032d2:	76 23                	jbe    801032f7 <mpinit+0x117>
    switch(*p){
801032d4:	0f b6 10             	movzbl (%eax),%edx
801032d7:	80 fa 04             	cmp    $0x4,%dl
801032da:	0f 87 ca 00 00 00    	ja     801033aa <mpinit+0x1ca>
801032e0:	ff 24 95 1c 79 10 80 	jmp    *-0x7fef86e4(,%edx,4)
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f3:	39 c6                	cmp    %eax,%esi
801032f5:	77 dd                	ja     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032f7:	85 db                	test   %ebx,%ebx
801032f9:	0f 84 9e 00 00 00    	je     8010339d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103302:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103306:	74 15                	je     8010331d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103308:	b8 70 00 00 00       	mov    $0x70,%eax
8010330d:	ba 22 00 00 00       	mov    $0x22,%edx
80103312:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103313:	ba 23 00 00 00       	mov    $0x23,%edx
80103318:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103319:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331c:	ee                   	out    %al,(%dx)
  }
}
8010331d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103320:	5b                   	pop    %ebx
80103321:	5e                   	pop    %esi
80103322:	5f                   	pop    %edi
80103323:	5d                   	pop    %ebp
80103324:	c3                   	ret    
80103325:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103328:	8b 0d 40 2d 11 80    	mov    0x80112d40,%ecx
8010332e:	83 f9 07             	cmp    $0x7,%ecx
80103331:	7f 19                	jg     8010334c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103333:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103337:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010333d:	83 c1 01             	add    $0x1,%ecx
80103340:	89 0d 40 2d 11 80    	mov    %ecx,0x80112d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103346:	88 97 c0 27 11 80    	mov    %dl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
8010334c:	83 c0 14             	add    $0x14,%eax
      continue;
8010334f:	e9 7c ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 15 a0 27 11 80    	mov    %dl,0x801127a0
      continue;
80103365:	e9 66 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103370:	ba 00 00 01 00       	mov    $0x10000,%edx
80103375:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010337a:	e8 e1 fd ff ff       	call   80103160 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010337f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103384:	0f 85 a9 fe ff ff    	jne    80103233 <mpinit+0x53>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 dd 78 10 80       	push   $0x801078dd
80103398:	e8 f3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010339d:	83 ec 0c             	sub    $0xc,%esp
801033a0:	68 fc 78 10 80       	push   $0x801078fc
801033a5:	e8 e6 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033aa:	31 db                	xor    %ebx,%ebx
801033ac:	e9 26 ff ff ff       	jmp    801032d7 <mpinit+0xf7>
801033b1:	66 90                	xchg   %ax,%ax
801033b3:	66 90                	xchg   %ax,%ax
801033b5:	66 90                	xchg   %ax,%ax
801033b7:	66 90                	xchg   %ax,%ax
801033b9:	66 90                	xchg   %ax,%ax
801033bb:	66 90                	xchg   %ax,%ax
801033bd:	66 90                	xchg   %ax,%ax
801033bf:	90                   	nop

801033c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033c6:	ba 21 00 00 00       	mov    $0x21,%edx
801033cb:	89 e5                	mov    %esp,%ebp
801033cd:	ee                   	out    %al,(%dx)
801033ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801033d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033d4:	5d                   	pop    %ebp
801033d5:	c3                   	ret    
801033d6:	66 90                	xchg   %ax,%ax
801033d8:	66 90                	xchg   %ax,%ax
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033fb:	e8 80 d9 ff ff       	call   80100d80 <filealloc>
80103400:	85 c0                	test   %eax,%eax
80103402:	89 03                	mov    %eax,(%ebx)
80103404:	74 22                	je     80103428 <pipealloc+0x48>
80103406:	e8 75 d9 ff ff       	call   80100d80 <filealloc>
8010340b:	85 c0                	test   %eax,%eax
8010340d:	89 06                	mov    %eax,(%esi)
8010340f:	74 3f                	je     80103450 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103411:	e8 ba f0 ff ff       	call   801024d0 <kalloc>
80103416:	85 c0                	test   %eax,%eax
80103418:	89 c7                	mov    %eax,%edi
8010341a:	75 54                	jne    80103470 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010341c:	8b 03                	mov    (%ebx),%eax
8010341e:	85 c0                	test   %eax,%eax
80103420:	75 34                	jne    80103456 <pipealloc+0x76>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103428:	8b 06                	mov    (%esi),%eax
8010342a:	85 c0                	test   %eax,%eax
8010342c:	74 0c                	je     8010343a <pipealloc+0x5a>
    fileclose(*f1);
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	50                   	push   %eax
80103432:	e8 09 da ff ff       	call   80100e40 <fileclose>
80103437:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010343a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010343d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103442:	5b                   	pop    %ebx
80103443:	5e                   	pop    %esi
80103444:	5f                   	pop    %edi
80103445:	5d                   	pop    %ebp
80103446:	c3                   	ret    
80103447:	89 f6                	mov    %esi,%esi
80103449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103450:	8b 03                	mov    (%ebx),%eax
80103452:	85 c0                	test   %eax,%eax
80103454:	74 e4                	je     8010343a <pipealloc+0x5a>
    fileclose(*f0);
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	50                   	push   %eax
8010345a:	e8 e1 d9 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010345f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103461:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103464:	85 c0                	test   %eax,%eax
80103466:	75 c6                	jne    8010342e <pipealloc+0x4e>
80103468:	eb d0                	jmp    8010343a <pipealloc+0x5a>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103470:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103473:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347a:	00 00 00 
  p->writeopen = 1;
8010347d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103484:	00 00 00 
  p->nwrite = 0;
80103487:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010348e:	00 00 00 
  p->nread = 0;
80103491:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103498:	00 00 00 
  initlock(&p->lock, "pipe");
8010349b:	68 30 79 10 80       	push   $0x80107930
801034a0:	50                   	push   %eax
801034a1:	e8 2a 12 00 00       	call   801046d0 <initlock>
  (*f0)->type = FD_PIPE;
801034a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b1:	8b 03                	mov    (%ebx),%eax
801034b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034b7:	8b 03                	mov    (%ebx),%eax
801034b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034bd:	8b 03                	mov    (%ebx),%eax
801034bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034c2:	8b 06                	mov    (%esi),%eax
801034c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d0:	8b 06                	mov    (%esi),%eax
801034d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034d6:	8b 06                	mov    (%esi),%eax
801034d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034de:	31 c0                	xor    %eax,%eax
}
801034e0:	5b                   	pop    %ebx
801034e1:	5e                   	pop    %esi
801034e2:	5f                   	pop    %edi
801034e3:	5d                   	pop    %ebp
801034e4:	c3                   	ret    
801034e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
801034f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034fb:	83 ec 0c             	sub    $0xc,%esp
801034fe:	53                   	push   %ebx
801034ff:	e8 0c 13 00 00       	call   80104810 <acquire>
  if(writable){
80103504:	83 c4 10             	add    $0x10,%esp
80103507:	85 f6                	test   %esi,%esi
80103509:	74 45                	je     80103550 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010350b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103511:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103514:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010351b:	00 00 00 
    wakeup(&p->nread);
8010351e:	50                   	push   %eax
8010351f:	e8 ac 0e 00 00       	call   801043d0 <wakeup>
80103524:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103527:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010352d:	85 d2                	test   %edx,%edx
8010352f:	75 0a                	jne    8010353b <pipeclose+0x4b>
80103531:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103537:	85 c0                	test   %eax,%eax
80103539:	74 35                	je     80103570 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010353b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103541:	5b                   	pop    %ebx
80103542:	5e                   	pop    %esi
80103543:	5d                   	pop    %ebp
    release(&p->lock);
80103544:	e9 87 13 00 00       	jmp    801048d0 <release>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103550:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103556:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103559:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103560:	00 00 00 
    wakeup(&p->nwrite);
80103563:	50                   	push   %eax
80103564:	e8 67 0e 00 00       	call   801043d0 <wakeup>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	eb b9                	jmp    80103527 <pipeclose+0x37>
8010356e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	53                   	push   %ebx
80103574:	e8 57 13 00 00       	call   801048d0 <release>
    kfree((char*)p);
80103579:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010357c:	83 c4 10             	add    $0x10,%esp
}
8010357f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103582:	5b                   	pop    %ebx
80103583:	5e                   	pop    %esi
80103584:	5d                   	pop    %ebp
    kfree((char*)p);
80103585:	e9 96 ed ff ff       	jmp    80102320 <kfree>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103590 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 28             	sub    $0x28,%esp
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010359c:	53                   	push   %ebx
8010359d:	e8 6e 12 00 00       	call   80104810 <acquire>
  for(i = 0; i < n; i++){
801035a2:	8b 45 10             	mov    0x10(%ebp),%eax
801035a5:	83 c4 10             	add    $0x10,%esp
801035a8:	85 c0                	test   %eax,%eax
801035aa:	0f 8e c9 00 00 00    	jle    80103679 <pipewrite+0xe9>
801035b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035c2:	03 4d 10             	add    0x10(%ebp),%ecx
801035c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035d4:	39 d0                	cmp    %edx,%eax
801035d6:	75 71                	jne    80103649 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 4e                	je     80103630 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035e8:	eb 3a                	jmp    80103624 <pipewrite+0x94>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	57                   	push   %edi
801035f4:	e8 d7 0d 00 00       	call   801043d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f9:	5a                   	pop    %edx
801035fa:	59                   	pop    %ecx
801035fb:	53                   	push   %ebx
801035fc:	56                   	push   %esi
801035fd:	e8 de 0b 00 00       	call   801041e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103602:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103608:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010360e:	83 c4 10             	add    $0x10,%esp
80103611:	05 00 02 00 00       	add    $0x200,%eax
80103616:	39 c2                	cmp    %eax,%edx
80103618:	75 36                	jne    80103650 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010361a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103620:	85 c0                	test   %eax,%eax
80103622:	74 0c                	je     80103630 <pipewrite+0xa0>
80103624:	e8 77 05 00 00       	call   80103ba0 <myproc>
80103629:	8b 40 24             	mov    0x24(%eax),%eax
8010362c:	85 c0                	test   %eax,%eax
8010362e:	74 c0                	je     801035f0 <pipewrite+0x60>
        release(&p->lock);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	53                   	push   %ebx
80103634:	e8 97 12 00 00       	call   801048d0 <release>
        return -1;
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103644:	5b                   	pop    %ebx
80103645:	5e                   	pop    %esi
80103646:	5f                   	pop    %edi
80103647:	5d                   	pop    %ebp
80103648:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103649:	89 c2                	mov    %eax,%edx
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103650:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103653:	8d 42 01             	lea    0x1(%edx),%eax
80103656:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010365c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103662:	83 c6 01             	add    $0x1,%esi
80103665:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103669:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010366c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103673:	0f 85 4f ff ff ff    	jne    801035c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103679:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010367f:	83 ec 0c             	sub    $0xc,%esp
80103682:	50                   	push   %eax
80103683:	e8 48 0d 00 00       	call   801043d0 <wakeup>
  release(&p->lock);
80103688:	89 1c 24             	mov    %ebx,(%esp)
8010368b:	e8 40 12 00 00       	call   801048d0 <release>
  return n;
80103690:	83 c4 10             	add    $0x10,%esp
80103693:	8b 45 10             	mov    0x10(%ebp),%eax
80103696:	eb a9                	jmp    80103641 <pipewrite+0xb1>
80103698:	90                   	nop
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 18             	sub    $0x18,%esp
801036a9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036af:	56                   	push   %esi
801036b0:	e8 5b 11 00 00       	call   80104810 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036c4:	75 6a                	jne    80103730 <piperead+0x90>
801036c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036cc:	85 db                	test   %ebx,%ebx
801036ce:	0f 84 c4 00 00 00    	je     80103798 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036da:	eb 2d                	jmp    80103709 <piperead+0x69>
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e0:	83 ec 08             	sub    $0x8,%esp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	e8 f6 0a 00 00       	call   801041e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036f9:	75 35                	jne    80103730 <piperead+0x90>
801036fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103701:	85 d2                	test   %edx,%edx
80103703:	0f 84 8f 00 00 00    	je     80103798 <piperead+0xf8>
    if(myproc()->killed){
80103709:	e8 92 04 00 00       	call   80103ba0 <myproc>
8010370e:	8b 48 24             	mov    0x24(%eax),%ecx
80103711:	85 c9                	test   %ecx,%ecx
80103713:	74 cb                	je     801036e0 <piperead+0x40>
      release(&p->lock);
80103715:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103718:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010371d:	56                   	push   %esi
8010371e:	e8 ad 11 00 00       	call   801048d0 <release>
      return -1;
80103723:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103726:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103729:	89 d8                	mov    %ebx,%eax
8010372b:	5b                   	pop    %ebx
8010372c:	5e                   	pop    %esi
8010372d:	5f                   	pop    %edi
8010372e:	5d                   	pop    %ebp
8010372f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103730:	8b 45 10             	mov    0x10(%ebp),%eax
80103733:	85 c0                	test   %eax,%eax
80103735:	7e 61                	jle    80103798 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103737:	31 db                	xor    %ebx,%ebx
80103739:	eb 13                	jmp    8010374e <piperead+0xae>
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103740:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103746:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010374c:	74 1f                	je     8010376d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010374e:	8d 41 01             	lea    0x1(%ecx),%eax
80103751:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103757:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010375d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103762:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103765:	83 c3 01             	add    $0x1,%ebx
80103768:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376b:	75 d3                	jne    80103740 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103773:	83 ec 0c             	sub    $0xc,%esp
80103776:	50                   	push   %eax
80103777:	e8 54 0c 00 00       	call   801043d0 <wakeup>
  release(&p->lock);
8010377c:	89 34 24             	mov    %esi,(%esp)
8010377f:	e8 4c 11 00 00       	call   801048d0 <release>
  return i;
80103784:	83 c4 10             	add    $0x10,%esp
}
80103787:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378a:	89 d8                	mov    %ebx,%eax
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	eb d1                	jmp    8010376d <piperead+0xcd>
8010379c:	66 90                	xchg   %ax,%ax
8010379e:	66 90                	xchg   %ax,%ax

801037a0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
801037a4:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801037a7:	68 00 2e 11 80       	push   $0x80112e00
801037ac:	e8 5f 10 00 00       	call   80104810 <acquire>

  p = (struct proc *)k_malloc(sizeof(struct proc));
801037b1:	c7 04 24 94 00 00 00 	movl   $0x94,(%esp)
801037b8:	e8 13 ee ff ff       	call   801025d0 <k_malloc>

  if (p != NULL)
801037bd:	83 c4 10             	add    $0x10,%esp
801037c0:	85 c0                	test   %eax,%eax
  p = (struct proc *)k_malloc(sizeof(struct proc));
801037c2:	89 c3                	mov    %eax,%ebx
  if (p != NULL)
801037c4:	0f 84 d6 00 00 00    	je     801038a0 <allocproc+0x100>
  {
    memset(p, 0, sizeof(struct proc));
801037ca:	83 ec 04             	sub    $0x4,%esp
801037cd:	68 94 00 00 00       	push   $0x94
801037d2:	6a 00                	push   $0x0
801037d4:	50                   	push   %eax
801037d5:	e8 46 11 00 00       	call   80104920 <memset>
 * Insert a new entry before the specified head.
 * This is useful for implementing queues.
 */
static inline void list_add_tail(struct list_head *new, struct list_head *head)
{
	__list_add(new, head->prev, head);
801037da:	a1 38 2e 11 80       	mov    0x80112e38,%eax
  {
    release(&ptable.lock);
    return 0;
  }

  INIT_LIST_HEAD(&p->queue_elem);
801037df:	8d 53 7c             	lea    0x7c(%ebx),%edx
	new->next = next;
801037e2:	c7 43 7c 34 2e 11 80 	movl   $0x80112e34,0x7c(%ebx)
	next->prev = new;
801037e9:	89 15 38 2e 11 80    	mov    %edx,0x80112e38
	new->prev = prev;
801037ef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	prev->next = new;
801037f5:	89 10                	mov    %edx,(%eax)

  /* stride scheduling */
  initialize_stride_info(p);

  p->state = EMBRYO;
  p->pid = nextpid++;
801037f7:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  proc->stride_info.tickets = 100;
801037fc:	c7 83 88 00 00 00 64 	movl   $0x64,0x88(%ebx)
80103803:	00 00 00 
  proc->stride_info.stride = STRIDE_LARGE_NUMBER / proc->stride_info.tickets;
80103806:	c7 83 84 00 00 00 64 	movl   $0x64,0x84(%ebx)
8010380d:	00 00 00 
  proc->stride_info.pass_value = 0;
80103810:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103817:	00 00 00 
8010381a:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103821:	00 00 00 
  p->state = EMBRYO;
80103824:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010382b:	8d 50 01             	lea    0x1(%eax),%edx
8010382e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103831:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
  p->pid = nextpid++;
80103838:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010383e:	e8 8d 10 00 00       	call   801048d0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103843:	e8 88 ec ff ff       	call   801024d0 <kalloc>
80103848:	83 c4 10             	add    $0x10,%esp
8010384b:	85 c0                	test   %eax,%eax
8010384d:	89 43 08             	mov    %eax,0x8(%ebx)
80103850:	74 3e                	je     80103890 <allocproc+0xf0>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103852:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103858:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010385b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103860:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103863:	c7 40 14 67 5b 10 80 	movl   $0x80105b67,0x14(%eax)
  p->context = (struct context *)sp;
8010386a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010386d:	6a 14                	push   $0x14
8010386f:	6a 00                	push   $0x0
80103871:	50                   	push   %eax
80103872:	e8 a9 10 00 00       	call   80104920 <memset>
  p->context->eip = (uint)forkret;
80103877:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010387a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010387d:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103884:	89 d8                	mov    %ebx,%eax
80103886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103889:	c9                   	leave  
8010388a:	c3                   	ret    
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->state = UNUSED;
80103890:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103897:	31 db                	xor    %ebx,%ebx
80103899:	eb e9                	jmp    80103884 <allocproc+0xe4>
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	68 00 2e 11 80       	push   $0x80112e00
801038a8:	e8 23 10 00 00       	call   801048d0 <release>
    return 0;
801038ad:	83 c4 10             	add    $0x10,%esp
801038b0:	eb d2                	jmp    80103884 <allocproc+0xe4>
801038b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038c0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038c6:	68 00 2e 11 80       	push   $0x80112e00
801038cb:	e8 00 10 00 00       	call   801048d0 <release>

  if (first)
801038d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	75 04                	jne    801038e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801038e0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801038e3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038ea:	00 00 00 
    iinit(ROOTDEV);
801038ed:	6a 01                	push   $0x1
801038ef:	e8 9c db ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 a0 f3 ff ff       	call   80102ca0 <initlog>
80103900:	83 c4 10             	add    $0x10,%esp
}
80103903:	c9                   	leave  
80103904:	c3                   	ret    
80103905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103910 <remove_min>:
{
80103910:	55                   	push   %ebp
  struct proc* min_pass_proc = NULL;
80103911:	31 c0                	xor    %eax,%eax
{
80103913:	89 e5                	mov    %esp,%ebp
80103915:	57                   	push   %edi
80103916:	56                   	push   %esi
80103917:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010391a:	53                   	push   %ebx
  list_for_each(iter, head)
8010391b:	8b 11                	mov    (%ecx),%edx
8010391d:	39 d1                	cmp    %edx,%ecx
8010391f:	74 53                	je     80103974 <remove_min+0x64>
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE)
80103928:	83 7a 90 03          	cmpl   $0x3,-0x70(%edx)
    p = list_entry(iter, struct proc, queue_elem);
8010392c:	8d 5a 84             	lea    -0x7c(%edx),%ebx
    if (p->state != RUNNABLE)
8010392f:	75 1f                	jne    80103950 <remove_min+0x40>
    if (min_pass_proc == NULL)
80103931:	85 c0                	test   %eax,%eax
80103933:	74 4b                	je     80103980 <remove_min+0x70>
    else if (p->stride_info.pass_value < min_pass_proc->stride_info.pass_value)
80103935:	8b b8 90 00 00 00    	mov    0x90(%eax),%edi
8010393b:	39 7a 14             	cmp    %edi,0x14(%edx)
8010393e:	8b 72 10             	mov    0x10(%edx),%esi
80103941:	7f 0d                	jg     80103950 <remove_min+0x40>
80103943:	7c 3b                	jl     80103980 <remove_min+0x70>
80103945:	3b b0 8c 00 00 00    	cmp    0x8c(%eax),%esi
8010394b:	72 33                	jb     80103980 <remove_min+0x70>
8010394d:	8d 76 00             	lea    0x0(%esi),%esi
  list_for_each(iter, head)
80103950:	8b 12                	mov    (%edx),%edx
80103952:	39 d1                	cmp    %edx,%ecx
80103954:	75 d2                	jne    80103928 <remove_min+0x18>
  if (min_pass_proc != NULL)
80103956:	85 c0                	test   %eax,%eax
80103958:	74 1a                	je     80103974 <remove_min+0x64>
 * Note: list_empty() on entry does not return true after this, the entry is
 * in an undefined state.
 */
static inline void __list_del_entry(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
8010395a:	8b 58 7c             	mov    0x7c(%eax),%ebx
8010395d:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
    list_del_init(&min_pass_proc->queue_elem);
80103963:	8d 50 7c             	lea    0x7c(%eax),%edx
	next->prev = prev;
80103966:	89 4b 04             	mov    %ecx,0x4(%ebx)
	prev->next = next;
80103969:	89 19                	mov    %ebx,(%ecx)
	list->next = list;
8010396b:	89 50 7c             	mov    %edx,0x7c(%eax)
	list->prev = list;
8010396e:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
}
80103974:	5b                   	pop    %ebx
80103975:	5e                   	pop    %esi
80103976:	5f                   	pop    %edi
80103977:	5d                   	pop    %ebp
80103978:	c3                   	ret    
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  list_for_each(iter, head)
80103980:	8b 12                	mov    (%edx),%edx
      min_pass_proc = p;
80103982:	89 d8                	mov    %ebx,%eax
  list_for_each(iter, head)
80103984:	39 d1                	cmp    %edx,%ecx
80103986:	75 a0                	jne    80103928 <remove_min+0x18>
80103988:	eb cc                	jmp    80103956 <remove_min+0x46>
8010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103990 <update_pass_value>:
{
80103990:	55                   	push   %ebp
  proc->stride_info.pass_value += STRIDE_LARGE_NUMBER / proc->stride_info.tickets;
80103991:	b8 10 27 00 00       	mov    $0x2710,%eax
80103996:	99                   	cltd   
{
80103997:	89 e5                	mov    %esp,%ebp
80103999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  proc->stride_info.pass_value += STRIDE_LARGE_NUMBER / proc->stride_info.tickets;
8010399c:	f7 b9 88 00 00 00    	idivl  0x88(%ecx)
801039a2:	99                   	cltd   
801039a3:	01 81 8c 00 00 00    	add    %eax,0x8c(%ecx)
801039a9:	11 91 90 00 00 00    	adc    %edx,0x90(%ecx)
}
801039af:	5d                   	pop    %ebp
801039b0:	c3                   	ret    
801039b1:	eb 0d                	jmp    801039c0 <update_min_pass_value>
801039b3:	90                   	nop
801039b4:	90                   	nop
801039b5:	90                   	nop
801039b6:	90                   	nop
801039b7:	90                   	nop
801039b8:	90                   	nop
801039b9:	90                   	nop
801039ba:	90                   	nop
801039bb:	90                   	nop
801039bc:	90                   	nop
801039bd:	90                   	nop
801039be:	90                   	nop
801039bf:	90                   	nop

801039c0 <update_min_pass_value>:
  list_for_each(iter, head)
801039c0:	a1 34 2e 11 80       	mov    0x80112e34,%eax
801039c5:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
801039ca:	74 74                	je     80103a40 <update_min_pass_value+0x80>
{
801039cc:	55                   	push   %ebp
  struct proc* min_pass_proc = NULL;
801039cd:	31 d2                	xor    %edx,%edx
{
801039cf:	89 e5                	mov    %esp,%ebp
801039d1:	56                   	push   %esi
801039d2:	53                   	push   %ebx
801039d3:	90                   	nop
801039d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE)
801039d8:	83 78 90 03          	cmpl   $0x3,-0x70(%eax)
    p = list_entry(iter, struct proc, queue_elem);
801039dc:	8d 48 84             	lea    -0x7c(%eax),%ecx
    if (p->state != RUNNABLE)
801039df:	75 1f                	jne    80103a00 <update_min_pass_value+0x40>
    if (min_pass_proc == NULL)
801039e1:	85 d2                	test   %edx,%edx
801039e3:	74 4b                	je     80103a30 <update_min_pass_value+0x70>
    else if (p->stride_info.pass_value < min_pass_proc->stride_info.pass_value)
801039e5:	8b b2 90 00 00 00    	mov    0x90(%edx),%esi
801039eb:	39 70 14             	cmp    %esi,0x14(%eax)
801039ee:	8b 58 10             	mov    0x10(%eax),%ebx
801039f1:	7f 0d                	jg     80103a00 <update_min_pass_value+0x40>
801039f3:	7c 3b                	jl     80103a30 <update_min_pass_value+0x70>
801039f5:	3b 9a 8c 00 00 00    	cmp    0x8c(%edx),%ebx
801039fb:	72 33                	jb     80103a30 <update_min_pass_value+0x70>
801039fd:	8d 76 00             	lea    0x0(%esi),%esi
  list_for_each(iter, head)
80103a00:	8b 00                	mov    (%eax),%eax
80103a02:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
80103a07:	75 cf                	jne    801039d8 <update_min_pass_value+0x18>
  if (min_pass_proc != NULL)
80103a09:	85 d2                	test   %edx,%edx
80103a0b:	74 17                	je     80103a24 <update_min_pass_value+0x64>
	ptable.min_pass_value = min_pass_proc->stride_info.pass_value;
80103a0d:	8b 82 8c 00 00 00    	mov    0x8c(%edx),%eax
80103a13:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
80103a19:	a3 40 2e 11 80       	mov    %eax,0x80112e40
80103a1e:	89 15 44 2e 11 80    	mov    %edx,0x80112e44
}
80103a24:	5b                   	pop    %ebx
80103a25:	5e                   	pop    %esi
80103a26:	5d                   	pop    %ebp
80103a27:	c3                   	ret    
80103a28:	90                   	nop
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  list_for_each(iter, head)
80103a30:	8b 00                	mov    (%eax),%eax
      min_pass_proc = p;
80103a32:	89 ca                	mov    %ecx,%edx
  list_for_each(iter, head)
80103a34:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
80103a39:	75 9d                	jne    801039d8 <update_min_pass_value+0x18>
80103a3b:	eb cc                	jmp    80103a09 <update_min_pass_value+0x49>
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
80103a40:	f3 c3                	repz ret 
80103a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <insert>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	8b 55 08             	mov    0x8(%ebp),%edx
80103a57:	8b 45 0c             	mov    0xc(%ebp),%eax
	__list_add(new, head->prev, head);
80103a5a:	8b 4a 04             	mov    0x4(%edx),%ecx
  list_add_tail(&current->queue_elem, head);
80103a5d:	8d 58 7c             	lea    0x7c(%eax),%ebx
	next->prev = new;
80103a60:	89 5a 04             	mov    %ebx,0x4(%edx)
	new->next = next;
80103a63:	89 50 7c             	mov    %edx,0x7c(%eax)
	new->prev = prev;
80103a66:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
	prev->next = new;
80103a6c:	89 19                	mov    %ebx,(%ecx)
}
80103a6e:	5b                   	pop    %ebx
80103a6f:	5d                   	pop    %ebp
80103a70:	c3                   	ret    
80103a71:	eb 0d                	jmp    80103a80 <assign_min_pass_value>
80103a73:	90                   	nop
80103a74:	90                   	nop
80103a75:	90                   	nop
80103a76:	90                   	nop
80103a77:	90                   	nop
80103a78:	90                   	nop
80103a79:	90                   	nop
80103a7a:	90                   	nop
80103a7b:	90                   	nop
80103a7c:	90                   	nop
80103a7d:	90                   	nop
80103a7e:	90                   	nop
80103a7f:	90                   	nop

80103a80 <assign_min_pass_value>:
{
80103a80:	55                   	push   %ebp
  proc->stride_info.pass_value = ptable.min_pass_value;
80103a81:	a1 40 2e 11 80       	mov    0x80112e40,%eax
80103a86:	8b 15 44 2e 11 80    	mov    0x80112e44,%edx
{
80103a8c:	89 e5                	mov    %esp,%ebp
  proc->stride_info.pass_value = ptable.min_pass_value;
80103a8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a91:	89 81 8c 00 00 00    	mov    %eax,0x8c(%ecx)
80103a97:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
}
80103a9d:	5d                   	pop    %ebp
80103a9e:	c3                   	ret    
80103a9f:	90                   	nop

80103aa0 <initialize_stride_info>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  proc->stride_info.tickets = 100;
80103aa6:	c7 80 88 00 00 00 64 	movl   $0x64,0x88(%eax)
80103aad:	00 00 00 
  proc->stride_info.stride = STRIDE_LARGE_NUMBER / proc->stride_info.tickets;
80103ab0:	c7 80 84 00 00 00 64 	movl   $0x64,0x84(%eax)
80103ab7:	00 00 00 
  proc->stride_info.pass_value = 0;
80103aba:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80103ac1:	00 00 00 
80103ac4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80103acb:	00 00 00 
}
80103ace:	5d                   	pop    %ebp
80103acf:	c3                   	ret    

80103ad0 <pinit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ad6:	68 35 79 10 80       	push   $0x80107935
80103adb:	68 00 2e 11 80       	push   $0x80112e00
80103ae0:	e8 eb 0b 00 00       	call   801046d0 <initlock>
  ptable.large_number = STRIDE_LARGE_NUMBER;
80103ae5:	c7 05 3c 2e 11 80 10 	movl   $0x2710,0x80112e3c
80103aec:	27 00 00 
}
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	c9                   	leave  
80103af3:	c3                   	ret    
80103af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b00 <mycpu>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b05:	9c                   	pushf  
80103b06:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103b07:	f6 c4 02             	test   $0x2,%ah
80103b0a:	75 5e                	jne    80103b6a <mycpu+0x6a>
  apicid = lapicid();
80103b0c:	e8 bf ed ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103b11:	8b 35 40 2d 11 80    	mov    0x80112d40,%esi
80103b17:	85 f6                	test   %esi,%esi
80103b19:	7e 42                	jle    80103b5d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b1b:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
80103b22:	39 d0                	cmp    %edx,%eax
80103b24:	74 30                	je     80103b56 <mycpu+0x56>
80103b26:	b9 70 28 11 80       	mov    $0x80112870,%ecx
  for (i = 0; i < ncpu; ++i)
80103b2b:	31 d2                	xor    %edx,%edx
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
80103b30:	83 c2 01             	add    $0x1,%edx
80103b33:	39 f2                	cmp    %esi,%edx
80103b35:	74 26                	je     80103b5d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b37:	0f b6 19             	movzbl (%ecx),%ebx
80103b3a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b40:	39 c3                	cmp    %eax,%ebx
80103b42:	75 ec                	jne    80103b30 <mycpu+0x30>
80103b44:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b4a:	05 c0 27 11 80       	add    $0x801127c0,%eax
}
80103b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b52:	5b                   	pop    %ebx
80103b53:	5e                   	pop    %esi
80103b54:	5d                   	pop    %ebp
80103b55:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b56:	b8 c0 27 11 80       	mov    $0x801127c0,%eax
      return &cpus[i];
80103b5b:	eb f2                	jmp    80103b4f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b5d:	83 ec 0c             	sub    $0xc,%esp
80103b60:	68 3c 79 10 80       	push   $0x8010793c
80103b65:	e8 26 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	68 18 7a 10 80       	push   $0x80107a18
80103b72:	e8 19 c8 ff ff       	call   80100390 <panic>
80103b77:	89 f6                	mov    %esi,%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <cpuid>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103b86:	e8 75 ff ff ff       	call   80103b00 <mycpu>
80103b8b:	2d c0 27 11 80       	sub    $0x801127c0,%eax
}
80103b90:	c9                   	leave  
  return mycpu() - cpus;
80103b91:	c1 f8 04             	sar    $0x4,%eax
80103b94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b9a:	c3                   	ret    
80103b9b:	90                   	nop
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <myproc>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ba7:	e8 94 0b 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103bac:	e8 4f ff ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103bb1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb7:	e8 c4 0b 00 00       	call   80104780 <popcli>
}
80103bbc:	83 c4 04             	add    $0x4,%esp
80103bbf:	89 d8                	mov    %ebx,%eax
80103bc1:	5b                   	pop    %ebx
80103bc2:	5d                   	pop    %ebp
80103bc3:	c3                   	ret    
80103bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bd0 <userinit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 04             	sub    $0x4,%esp
	list->next = list;
80103bd7:	c7 05 34 2e 11 80 34 	movl   $0x80112e34,0x80112e34
80103bde:	2e 11 80 
	list->prev = list;
80103be1:	c7 05 38 2e 11 80 34 	movl   $0x80112e34,0x80112e38
80103be8:	2e 11 80 
  p = allocproc();
80103beb:	e8 b0 fb ff ff       	call   801037a0 <allocproc>
80103bf0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bf2:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if ((p->pgdir = setupkvm()) == 0)
80103bf7:	e8 44 35 00 00       	call   80107140 <setupkvm>
80103bfc:	85 c0                	test   %eax,%eax
80103bfe:	89 43 04             	mov    %eax,0x4(%ebx)
80103c01:	0f 84 bd 00 00 00    	je     80103cc4 <userinit+0xf4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c07:	83 ec 04             	sub    $0x4,%esp
80103c0a:	68 2c 00 00 00       	push   $0x2c
80103c0f:	68 60 a4 10 80       	push   $0x8010a460
80103c14:	50                   	push   %eax
80103c15:	e8 06 32 00 00       	call   80106e20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c23:	6a 4c                	push   $0x4c
80103c25:	6a 00                	push   $0x0
80103c27:	ff 73 18             	pushl  0x18(%ebx)
80103c2a:	e8 f1 0c 00 00       	call   80104920 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c37:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c3c:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c43:	8b 43 18             	mov    0x18(%ebx),%eax
80103c46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c55:	8b 43 18             	mov    0x18(%ebx),%eax
80103c58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c60:	8b 43 18             	mov    0x18(%ebx),%eax
80103c63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103c74:	8b 43 18             	mov    0x18(%ebx),%eax
80103c77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c81:	6a 10                	push   $0x10
80103c83:	68 65 79 10 80       	push   $0x80107965
80103c88:	50                   	push   %eax
80103c89:	e8 72 0e 00 00       	call   80104b00 <safestrcpy>
  p->cwd = namei("/");
80103c8e:	c7 04 24 6e 79 10 80 	movl   $0x8010796e,(%esp)
80103c95:	e8 56 e2 ff ff       	call   80101ef0 <namei>
80103c9a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c9d:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103ca4:	e8 67 0b 00 00       	call   80104810 <acquire>
  p->state = RUNNABLE;
80103ca9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cb0:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103cb7:	e8 14 0c 00 00       	call   801048d0 <release>
}
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cc2:	c9                   	leave  
80103cc3:	c3                   	ret    
    panic("userinit: out of memory?");
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 4c 79 10 80       	push   $0x8010794c
80103ccc:	e8 bf c6 ff ff       	call   80100390 <panic>
80103cd1:	eb 0d                	jmp    80103ce0 <growproc>
80103cd3:	90                   	nop
80103cd4:	90                   	nop
80103cd5:	90                   	nop
80103cd6:	90                   	nop
80103cd7:	90                   	nop
80103cd8:	90                   	nop
80103cd9:	90                   	nop
80103cda:	90                   	nop
80103cdb:	90                   	nop
80103cdc:	90                   	nop
80103cdd:	90                   	nop
80103cde:	90                   	nop
80103cdf:	90                   	nop

80103ce0 <growproc>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ce8:	e8 53 0a 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103ced:	e8 0e fe ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103cf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf8:	e8 83 0a 00 00       	call   80104780 <popcli>
  if (n > 0)
80103cfd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d00:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103d02:	7f 1c                	jg     80103d20 <growproc+0x40>
  else if (n < 0)
80103d04:	75 3a                	jne    80103d40 <growproc+0x60>
  switchuvm(curproc);
80103d06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d0b:	53                   	push   %ebx
80103d0c:	e8 ff 2f 00 00       	call   80106d10 <switchuvm>
  return 0;
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	31 c0                	xor    %eax,%eax
}
80103d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d19:	5b                   	pop    %ebx
80103d1a:	5e                   	pop    %esi
80103d1b:	5d                   	pop    %ebp
80103d1c:	c3                   	ret    
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	pushl  0x4(%ebx)
80103d2a:	e8 31 32 00 00       	call   80106f60 <allocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 d0                	jne    80103d06 <growproc+0x26>
      return -1;
80103d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d3b:	eb d9                	jmp    80103d16 <growproc+0x36>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d40:	83 ec 04             	sub    $0x4,%esp
80103d43:	01 c6                	add    %eax,%esi
80103d45:	56                   	push   %esi
80103d46:	50                   	push   %eax
80103d47:	ff 73 04             	pushl  0x4(%ebx)
80103d4a:	e8 41 33 00 00       	call   80107090 <deallocuvm>
80103d4f:	83 c4 10             	add    $0x10,%esp
80103d52:	85 c0                	test   %eax,%eax
80103d54:	75 b0                	jne    80103d06 <growproc+0x26>
80103d56:	eb de                	jmp    80103d36 <growproc+0x56>
80103d58:	90                   	nop
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d60 <fork>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d69:	e8 d2 09 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103d6e:	e8 8d fd ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103d73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d79:	e8 02 0a 00 00       	call   80104780 <popcli>
  if ((np = allocproc()) == 0)
80103d7e:	e8 1d fa ff ff       	call   801037a0 <allocproc>
80103d83:	85 c0                	test   %eax,%eax
80103d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d88:	0f 84 cf 00 00 00    	je     80103e5d <fork+0xfd>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103d8e:	83 ec 08             	sub    $0x8,%esp
80103d91:	ff 33                	pushl  (%ebx)
80103d93:	ff 73 04             	pushl  0x4(%ebx)
80103d96:	89 c7                	mov    %eax,%edi
80103d98:	e8 73 34 00 00       	call   80107210 <copyuvm>
80103d9d:	83 c4 10             	add    $0x10,%esp
80103da0:	85 c0                	test   %eax,%eax
80103da2:	89 47 04             	mov    %eax,0x4(%edi)
80103da5:	0f 84 b9 00 00 00    	je     80103e64 <fork+0x104>
  np->sz = curproc->sz;
80103dab:	8b 03                	mov    (%ebx),%eax
80103dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103db0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103db2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103db5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103db7:	8b 79 18             	mov    0x18(%ecx),%edi
80103dba:	8b 73 18             	mov    0x18(%ebx),%esi
80103dbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103dc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103dc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103dc6:	8b 40 18             	mov    0x18(%eax),%eax
80103dc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103dd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dd4:	85 c0                	test   %eax,%eax
80103dd6:	74 13                	je     80103deb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	50                   	push   %eax
80103ddc:	e8 0f d0 ff ff       	call   80100df0 <filedup>
80103de1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103de4:	83 c4 10             	add    $0x10,%esp
80103de7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103deb:	83 c6 01             	add    $0x1,%esi
80103dee:	83 fe 10             	cmp    $0x10,%esi
80103df1:	75 dd                	jne    80103dd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103df3:	83 ec 0c             	sub    $0xc,%esp
80103df6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dfc:	e8 5f d8 ff ff       	call   80101660 <idup>
80103e01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e0d:	6a 10                	push   $0x10
80103e0f:	53                   	push   %ebx
80103e10:	50                   	push   %eax
80103e11:	e8 ea 0c 00 00       	call   80104b00 <safestrcpy>
  pid = np->pid;
80103e16:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103e19:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103e20:	e8 eb 09 00 00       	call   80104810 <acquire>
  np->state = RUNNABLE;
80103e25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  proc->stride_info.pass_value = ptable.min_pass_value;
80103e2c:	8b 0d 40 2e 11 80    	mov    0x80112e40,%ecx
80103e32:	8b 1d 44 2e 11 80    	mov    0x80112e44,%ebx
80103e38:	89 8f 8c 00 00 00    	mov    %ecx,0x8c(%edi)
80103e3e:	89 9f 90 00 00 00    	mov    %ebx,0x90(%edi)
  release(&ptable.lock);
80103e44:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103e4b:	e8 80 0a 00 00       	call   801048d0 <release>
  return pid;
80103e50:	83 c4 10             	add    $0x10,%esp
}
80103e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e56:	89 f0                	mov    %esi,%eax
80103e58:	5b                   	pop    %ebx
80103e59:	5e                   	pop    %esi
80103e5a:	5f                   	pop    %edi
80103e5b:	5d                   	pop    %ebp
80103e5c:	c3                   	ret    
    return -1;
80103e5d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103e62:	eb ef                	jmp    80103e53 <fork+0xf3>
    kfree(np->kstack);
80103e64:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e67:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103e6a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103e6f:	ff 73 08             	pushl  0x8(%ebx)
80103e72:	e8 a9 e4 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103e77:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103e7e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e85:	83 c4 10             	add    $0x10,%esp
80103e88:	eb c9                	jmp    80103e53 <fork+0xf3>
80103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e90 <scheduler>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e99:	e8 62 fc ff ff       	call   80103b00 <mycpu>
80103e9e:	8d 78 04             	lea    0x4(%eax),%edi
80103ea1:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103ea3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103eaa:	00 00 00 
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103eb0:	fb                   	sti    
    acquire(&ptable.lock);
80103eb1:	83 ec 0c             	sub    $0xc,%esp
80103eb4:	68 00 2e 11 80       	push   $0x80112e00
80103eb9:	e8 52 09 00 00       	call   80104810 <acquire>
    p = remove_min(head);
80103ebe:	c7 04 24 34 2e 11 80 	movl   $0x80112e34,(%esp)
80103ec5:	e8 46 fa ff ff       	call   80103910 <remove_min>
    if (p != NULL)
80103eca:	83 c4 10             	add    $0x10,%esp
80103ecd:	85 c0                	test   %eax,%eax
    p = remove_min(head);
80103ecf:	89 c6                	mov    %eax,%esi
    if (p != NULL)
80103ed1:	74 6e                	je     80103f41 <scheduler+0xb1>
      switchuvm(p);
80103ed3:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ed6:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
      switchuvm(p);
80103edc:	50                   	push   %eax
80103edd:	e8 2e 2e 00 00       	call   80106d10 <switchuvm>
      p->state = RUNNING;
80103ee2:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      swtch(&(c->scheduler), p->context);
80103ee9:	58                   	pop    %eax
80103eea:	5a                   	pop    %edx
80103eeb:	ff 76 1c             	pushl  0x1c(%esi)
80103eee:	57                   	push   %edi
80103eef:	e8 67 0c 00 00       	call   80104b5b <swtch>
      switchkvm();
80103ef4:	e8 f7 2d 00 00       	call   80106cf0 <switchkvm>
  proc->stride_info.pass_value += STRIDE_LARGE_NUMBER / proc->stride_info.tickets;
80103ef9:	b8 10 27 00 00       	mov    $0x2710,%eax
      c->proc = 0;
80103efe:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103f05:	00 00 00 
	new->next = next;
80103f08:	c7 46 7c 34 2e 11 80 	movl   $0x80112e34,0x7c(%esi)
  proc->stride_info.pass_value += STRIDE_LARGE_NUMBER / proc->stride_info.tickets;
80103f0f:	99                   	cltd   
80103f10:	f7 be 88 00 00 00    	idivl  0x88(%esi)
80103f16:	99                   	cltd   
80103f17:	01 86 8c 00 00 00    	add    %eax,0x8c(%esi)
	__list_add(new, head->prev, head);
80103f1d:	a1 38 2e 11 80       	mov    0x80112e38,%eax
80103f22:	11 96 90 00 00 00    	adc    %edx,0x90(%esi)
  list_add_tail(&current->queue_elem, head);
80103f28:	8d 56 7c             	lea    0x7c(%esi),%edx
	new->prev = prev;
80103f2b:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	next->prev = new;
80103f31:	89 15 38 2e 11 80    	mov    %edx,0x80112e38
	prev->next = new;
80103f37:	89 10                	mov    %edx,(%eax)
      update_min_pass_value();
80103f39:	e8 82 fa ff ff       	call   801039c0 <update_min_pass_value>
80103f3e:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 00 2e 11 80       	push   $0x80112e00
80103f49:	e8 82 09 00 00       	call   801048d0 <release>
    sti();
80103f4e:	83 c4 10             	add    $0x10,%esp
80103f51:	e9 5a ff ff ff       	jmp    80103eb0 <scheduler+0x20>
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <sched>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  pushcli();
80103f65:	e8 d6 07 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103f6a:	e8 91 fb ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103f6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f75:	e8 06 08 00 00       	call   80104780 <popcli>
  if (!holding(&ptable.lock))
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 00 2e 11 80       	push   $0x80112e00
80103f82:	e8 59 08 00 00       	call   801047e0 <holding>
80103f87:	83 c4 10             	add    $0x10,%esp
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 4f                	je     80103fdd <sched+0x7d>
  if (mycpu()->ncli != 1)
80103f8e:	e8 6d fb ff ff       	call   80103b00 <mycpu>
80103f93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f9a:	75 68                	jne    80104004 <sched+0xa4>
  if (p->state == RUNNING)
80103f9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fa0:	74 55                	je     80103ff7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa2:	9c                   	pushf  
80103fa3:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103fa4:	f6 c4 02             	test   $0x2,%ah
80103fa7:	75 41                	jne    80103fea <sched+0x8a>
  intena = mycpu()->intena;
80103fa9:	e8 52 fb ff ff       	call   80103b00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fb7:	e8 44 fb ff ff       	call   80103b00 <mycpu>
80103fbc:	83 ec 08             	sub    $0x8,%esp
80103fbf:	ff 70 04             	pushl  0x4(%eax)
80103fc2:	53                   	push   %ebx
80103fc3:	e8 93 0b 00 00       	call   80104b5b <swtch>
  mycpu()->intena = intena;
80103fc8:	e8 33 fb ff ff       	call   80103b00 <mycpu>
}
80103fcd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5e                   	pop    %esi
80103fdb:	5d                   	pop    %ebp
80103fdc:	c3                   	ret    
    panic("sched ptable.lock");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 70 79 10 80       	push   $0x80107970
80103fe5:	e8 a6 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 9c 79 10 80       	push   $0x8010799c
80103ff2:	e8 99 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 8e 79 10 80       	push   $0x8010798e
80103fff:	e8 8c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 82 79 10 80       	push   $0x80107982
8010400c:	e8 7f c3 ff ff       	call   80100390 <panic>
80104011:	eb 0d                	jmp    80104020 <exit>
80104013:	90                   	nop
80104014:	90                   	nop
80104015:	90                   	nop
80104016:	90                   	nop
80104017:	90                   	nop
80104018:	90                   	nop
80104019:	90                   	nop
8010401a:	90                   	nop
8010401b:	90                   	nop
8010401c:	90                   	nop
8010401d:	90                   	nop
8010401e:	90                   	nop
8010401f:	90                   	nop

80104020 <exit>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104029:	e8 12 07 00 00       	call   80104740 <pushcli>
  c = mycpu();
8010402e:	e8 cd fa ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80104033:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104039:	e8 42 07 00 00       	call   80104780 <popcli>
  if (curproc == initproc)
8010403e:	39 3d bc a5 10 80    	cmp    %edi,0x8010a5bc
80104044:	8d 5f 28             	lea    0x28(%edi),%ebx
80104047:	8d 77 68             	lea    0x68(%edi),%esi
8010404a:	0f 84 2f 01 00 00    	je     8010417f <exit+0x15f>
    if (curproc->ofile[fd])
80104050:	8b 03                	mov    (%ebx),%eax
80104052:	85 c0                	test   %eax,%eax
80104054:	74 12                	je     80104068 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	50                   	push   %eax
8010405a:	e8 e1 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010405f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	83 c3 04             	add    $0x4,%ebx
  for (fd = 0; fd < NOFILE; fd++)
8010406b:	39 de                	cmp    %ebx,%esi
8010406d:	75 e1                	jne    80104050 <exit+0x30>
  begin_op();
8010406f:	e8 cc ec ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	ff 77 68             	pushl  0x68(%edi)
8010407a:	e8 41 d7 ff ff       	call   801017c0 <iput>
  end_op();
8010407f:	e8 2c ed ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80104084:	c7 47 68 00 00 00 00 	movl   $0x0,0x68(%edi)
  acquire(&ptable.lock);
8010408b:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80104092:	e8 79 07 00 00       	call   80104810 <acquire>
{
  struct proc *p;
  struct list_head *head = &ptable.queue_head;
  struct list_head *iter;

  list_for_each(iter, head)
80104097:	8b 0d 34 2e 11 80    	mov    0x80112e34,%ecx
8010409d:	83 c4 10             	add    $0x10,%esp
  wakeup1(curproc->parent);
801040a0:	8b 5f 14             	mov    0x14(%edi),%ebx
  list_for_each(iter, head)
801040a3:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
801040a9:	75 0f                	jne    801040ba <exit+0x9a>
801040ab:	eb 33                	jmp    801040e0 <exit+0xc0>
801040ad:	8d 76 00             	lea    0x0(%esi),%esi
801040b0:	8b 09                	mov    (%ecx),%ecx
801040b2:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
801040b8:	74 46                	je     80104100 <exit+0xe0>
  {
    p = list_entry(iter, struct proc, queue_elem);
    if (p->state == SLEEPING && p->chan == chan)
801040ba:	83 79 90 02          	cmpl   $0x2,-0x70(%ecx)
801040be:	75 f0                	jne    801040b0 <exit+0x90>
801040c0:	3b 59 a4             	cmp    -0x5c(%ecx),%ebx
801040c3:	75 eb                	jne    801040b0 <exit+0x90>
    {
      p->state = RUNNABLE;
801040c5:	c7 41 90 03 00 00 00 	movl   $0x3,-0x70(%ecx)
  proc->stride_info.pass_value = ptable.min_pass_value;
801040cc:	a1 40 2e 11 80       	mov    0x80112e40,%eax
801040d1:	8b 15 44 2e 11 80    	mov    0x80112e44,%edx
801040d7:	89 41 10             	mov    %eax,0x10(%ecx)
801040da:	89 51 14             	mov    %edx,0x14(%ecx)
801040dd:	eb d1                	jmp    801040b0 <exit+0x90>
801040df:	90                   	nop
  curproc->state = ZOMBIE;
801040e0:	c7 47 0c 05 00 00 00 	movl   $0x5,0xc(%edi)
  sched();
801040e7:	e8 74 fe ff ff       	call   80103f60 <sched>
  panic("zombie exit");
801040ec:	83 ec 0c             	sub    $0xc,%esp
801040ef:	68 bd 79 10 80       	push   $0x801079bd
801040f4:	e8 97 c2 ff ff       	call   80100390 <panic>
801040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  list_for_each(iter, head)
80104100:	8b 0d 34 2e 11 80    	mov    0x80112e34,%ecx
80104106:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
8010410c:	74 d2                	je     801040e0 <exit+0xc0>
      p->parent = initproc;
8010410e:	8b 35 bc a5 10 80    	mov    0x8010a5bc,%esi
80104114:	eb 14                	jmp    8010412a <exit+0x10a>
80104116:	8d 76 00             	lea    0x0(%esi),%esi
80104119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  list_for_each(iter, head)
80104120:	8b 09                	mov    (%ecx),%ecx
80104122:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
80104128:	74 b6                	je     801040e0 <exit+0xc0>
    if (p->parent == curproc)
8010412a:	39 79 98             	cmp    %edi,-0x68(%ecx)
8010412d:	75 f1                	jne    80104120 <exit+0x100>
      if (p->state == ZOMBIE)
8010412f:	83 79 90 05          	cmpl   $0x5,-0x70(%ecx)
      p->parent = initproc;
80104133:	89 71 98             	mov    %esi,-0x68(%ecx)
      if (p->state == ZOMBIE)
80104136:	75 e8                	jne    80104120 <exit+0x100>
  list_for_each(iter, head)
80104138:	8b 1d 34 2e 11 80    	mov    0x80112e34,%ebx
8010413e:	81 fb 34 2e 11 80    	cmp    $0x80112e34,%ebx
80104144:	75 14                	jne    8010415a <exit+0x13a>
80104146:	eb d8                	jmp    80104120 <exit+0x100>
80104148:	90                   	nop
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104150:	8b 1b                	mov    (%ebx),%ebx
80104152:	81 fb 34 2e 11 80    	cmp    $0x80112e34,%ebx
80104158:	74 c6                	je     80104120 <exit+0x100>
    if (p->state == SLEEPING && p->chan == chan)
8010415a:	83 7b 90 02          	cmpl   $0x2,-0x70(%ebx)
8010415e:	75 f0                	jne    80104150 <exit+0x130>
80104160:	3b 73 a4             	cmp    -0x5c(%ebx),%esi
80104163:	75 eb                	jne    80104150 <exit+0x130>
      p->state = RUNNABLE;
80104165:	c7 43 90 03 00 00 00 	movl   $0x3,-0x70(%ebx)
  proc->stride_info.pass_value = ptable.min_pass_value;
8010416c:	a1 40 2e 11 80       	mov    0x80112e40,%eax
80104171:	8b 15 44 2e 11 80    	mov    0x80112e44,%edx
80104177:	89 43 10             	mov    %eax,0x10(%ebx)
8010417a:	89 53 14             	mov    %edx,0x14(%ebx)
8010417d:	eb d1                	jmp    80104150 <exit+0x130>
    panic("init exiting");
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	68 b0 79 10 80       	push   $0x801079b0
80104187:	e8 04 c2 ff ff       	call   80100390 <panic>
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <yield>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); //DOC: yieldlock
80104197:	68 00 2e 11 80       	push   $0x80112e00
8010419c:	e8 6f 06 00 00       	call   80104810 <acquire>
  pushcli();
801041a1:	e8 9a 05 00 00       	call   80104740 <pushcli>
  c = mycpu();
801041a6:	e8 55 f9 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801041ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b1:	e8 ca 05 00 00       	call   80104780 <popcli>
  myproc()->state = RUNNABLE;
801041b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041bd:	e8 9e fd ff ff       	call   80103f60 <sched>
  release(&ptable.lock);
801041c2:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
801041c9:	e8 02 07 00 00       	call   801048d0 <release>
}
801041ce:	83 c4 10             	add    $0x10,%esp
801041d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <sleep>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 0c             	sub    $0xc,%esp
801041e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041ef:	e8 4c 05 00 00       	call   80104740 <pushcli>
  c = mycpu();
801041f4:	e8 07 f9 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801041f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041ff:	e8 7c 05 00 00       	call   80104780 <popcli>
  if (p == 0)
80104204:	85 db                	test   %ebx,%ebx
80104206:	0f 84 87 00 00 00    	je     80104293 <sleep+0xb3>
  if (lk == 0)
8010420c:	85 f6                	test   %esi,%esi
8010420e:	74 76                	je     80104286 <sleep+0xa6>
  if (lk != &ptable.lock)
80104210:	81 fe 00 2e 11 80    	cmp    $0x80112e00,%esi
80104216:	74 50                	je     80104268 <sleep+0x88>
    acquire(&ptable.lock); //DOC: sleeplock1
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	68 00 2e 11 80       	push   $0x80112e00
80104220:	e8 eb 05 00 00       	call   80104810 <acquire>
    release(lk);
80104225:	89 34 24             	mov    %esi,(%esp)
80104228:	e8 a3 06 00 00       	call   801048d0 <release>
  p->chan = chan;
8010422d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104230:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104237:	e8 24 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
8010423c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104243:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
8010424a:	e8 81 06 00 00       	call   801048d0 <release>
    acquire(lk);
8010424f:	89 75 08             	mov    %esi,0x8(%ebp)
80104252:	83 c4 10             	add    $0x10,%esp
}
80104255:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104258:	5b                   	pop    %ebx
80104259:	5e                   	pop    %esi
8010425a:	5f                   	pop    %edi
8010425b:	5d                   	pop    %ebp
    acquire(lk);
8010425c:	e9 af 05 00 00       	jmp    80104810 <acquire>
80104261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104268:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010426b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104272:	e8 e9 fc ff ff       	call   80103f60 <sched>
  p->chan = 0;
80104277:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010427e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104281:	5b                   	pop    %ebx
80104282:	5e                   	pop    %esi
80104283:	5f                   	pop    %edi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
    panic("sleep without lk");
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	68 cf 79 10 80       	push   $0x801079cf
8010428e:	e8 fd c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104293:	83 ec 0c             	sub    $0xc,%esp
80104296:	68 c9 79 10 80       	push   $0x801079c9
8010429b:	e8 f0 c0 ff ff       	call   80100390 <panic>

801042a0 <wait>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
801042a4:	53                   	push   %ebx
  pushcli();
801042a5:	e8 96 04 00 00       	call   80104740 <pushcli>
  c = mycpu();
801042aa:	e8 51 f8 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801042af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042b5:	e8 c6 04 00 00       	call   80104780 <popcli>
  acquire(&ptable.lock);
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	68 00 2e 11 80       	push   $0x80112e00
801042c2:	e8 49 05 00 00       	call   80104810 <acquire>
801042c7:	83 c4 10             	add    $0x10,%esp
    list_for_each_safe(iter, n, head)
801042ca:	8b 1d 34 2e 11 80    	mov    0x80112e34,%ebx
801042d0:	81 fb 34 2e 11 80    	cmp    $0x80112e34,%ebx
801042d6:	8b 03                	mov    (%ebx),%eax
801042d8:	0f 84 d2 00 00 00    	je     801043b0 <wait+0x110>
    havekids = 0;
801042de:	31 c9                	xor    %ecx,%ecx
801042e0:	eb 13                	jmp    801042f5 <wait+0x55>
801042e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    list_for_each_safe(iter, n, head)
801042e8:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
801042ed:	8b 10                	mov    (%eax),%edx
801042ef:	89 c3                	mov    %eax,%ebx
801042f1:	74 1d                	je     80104310 <wait+0x70>
801042f3:	89 d0                	mov    %edx,%eax
      if (p->parent != curproc)
801042f5:	39 73 98             	cmp    %esi,-0x68(%ebx)
801042f8:	75 ee                	jne    801042e8 <wait+0x48>
      if (p->state == ZOMBIE)
801042fa:	83 7b 90 05          	cmpl   $0x5,-0x70(%ebx)
801042fe:	74 40                	je     80104340 <wait+0xa0>
    list_for_each_safe(iter, n, head)
80104300:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
      havekids = 1;
80104305:	b9 01 00 00 00       	mov    $0x1,%ecx
    list_for_each_safe(iter, n, head)
8010430a:	8b 10                	mov    (%eax),%edx
8010430c:	89 c3                	mov    %eax,%ebx
8010430e:	75 e3                	jne    801042f3 <wait+0x53>
    if (!havekids || curproc->killed)
80104310:	85 c9                	test   %ecx,%ecx
80104312:	0f 84 98 00 00 00    	je     801043b0 <wait+0x110>
80104318:	8b 46 24             	mov    0x24(%esi),%eax
8010431b:	85 c0                	test   %eax,%eax
8010431d:	0f 85 8d 00 00 00    	jne    801043b0 <wait+0x110>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104323:	83 ec 08             	sub    $0x8,%esp
80104326:	68 00 2e 11 80       	push   $0x80112e00
8010432b:	56                   	push   %esi
8010432c:	e8 af fe ff ff       	call   801041e0 <sleep>
    havekids = 0;
80104331:	83 c4 10             	add    $0x10,%esp
80104334:	eb 94                	jmp    801042ca <wait+0x2a>
80104336:	8d 76 00             	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        kfree(p->kstack);
80104340:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104343:	8b 73 94             	mov    -0x6c(%ebx),%esi
        kfree(p->kstack);
80104346:	ff 73 8c             	pushl  -0x74(%ebx)
80104349:	e8 d2 df ff ff       	call   80102320 <kfree>
        p->kstack = 0;
8010434e:	c7 43 8c 00 00 00 00 	movl   $0x0,-0x74(%ebx)
        freevm(p->pgdir);
80104355:	5a                   	pop    %edx
80104356:	ff 73 88             	pushl  -0x78(%ebx)
80104359:	e8 62 2d 00 00       	call   801070c0 <freevm>
	__list_del(entry->prev, entry->next);
8010435e:	8b 0b                	mov    (%ebx),%ecx
80104360:	8b 53 04             	mov    0x4(%ebx),%edx
        list_del_init(&p->queue_elem);
80104363:	8d 43 84             	lea    -0x7c(%ebx),%eax
        p->pid = 0;
80104366:	c7 43 94 00 00 00 00 	movl   $0x0,-0x6c(%ebx)
        p->parent = 0;
8010436d:	c7 43 98 00 00 00 00 	movl   $0x0,-0x68(%ebx)
        p->name[0] = 0;
80104374:	c6 43 f0 00          	movb   $0x0,-0x10(%ebx)
        p->killed = 0;
80104378:	c7 43 a8 00 00 00 00 	movl   $0x0,-0x58(%ebx)
        p->state = UNUSED;
8010437f:	c7 43 90 00 00 00 00 	movl   $0x0,-0x70(%ebx)
	next->prev = prev;
80104386:	89 51 04             	mov    %edx,0x4(%ecx)
	prev->next = next;
80104389:	89 0a                	mov    %ecx,(%edx)
	list->next = list;
8010438b:	89 1b                	mov    %ebx,(%ebx)
	list->prev = list;
8010438d:	89 5b 04             	mov    %ebx,0x4(%ebx)
        k_free(p);
80104390:	89 04 24             	mov    %eax,(%esp)
80104393:	e8 a8 e1 ff ff       	call   80102540 <k_free>
        release(&ptable.lock);
80104398:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
8010439f:	e8 2c 05 00 00       	call   801048d0 <release>
        return pid;
801043a4:	83 c4 10             	add    $0x10,%esp
}
801043a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043aa:	89 f0                	mov    %esi,%eax
801043ac:	5b                   	pop    %ebx
801043ad:	5e                   	pop    %esi
801043ae:	5d                   	pop    %ebp
801043af:	c3                   	ret    
      release(&ptable.lock);
801043b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801043b3:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801043b8:	68 00 2e 11 80       	push   $0x80112e00
801043bd:	e8 0e 05 00 00       	call   801048d0 <release>
      return -1;
801043c2:	83 c4 10             	add    $0x10,%esp
}
801043c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c8:	89 f0                	mov    %esi,%eax
801043ca:	5b                   	pop    %ebx
801043cb:	5e                   	pop    %esi
801043cc:	5d                   	pop    %ebp
801043cd:	c3                   	ret    
801043ce:	66 90                	xchg   %ax,%ax

801043d0 <wakeup>:
  }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 10             	sub    $0x10,%esp
801043d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043da:	68 00 2e 11 80       	push   $0x80112e00
801043df:	e8 2c 04 00 00       	call   80104810 <acquire>
  list_for_each(iter, head)
801043e4:	8b 0d 34 2e 11 80    	mov    0x80112e34,%ecx
801043ea:	83 c4 10             	add    $0x10,%esp
801043ed:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
801043f3:	75 15                	jne    8010440a <wakeup+0x3a>
801043f5:	eb 40                	jmp    80104437 <wakeup+0x67>
801043f7:	89 f6                	mov    %esi,%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104400:	8b 09                	mov    (%ecx),%ecx
80104402:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
80104408:	74 2d                	je     80104437 <wakeup+0x67>
    if (p->state == SLEEPING && p->chan == chan)
8010440a:	83 79 90 02          	cmpl   $0x2,-0x70(%ecx)
8010440e:	75 f0                	jne    80104400 <wakeup+0x30>
80104410:	3b 59 a4             	cmp    -0x5c(%ecx),%ebx
80104413:	75 eb                	jne    80104400 <wakeup+0x30>
      p->state = RUNNABLE;
80104415:	c7 41 90 03 00 00 00 	movl   $0x3,-0x70(%ecx)
  proc->stride_info.pass_value = ptable.min_pass_value;
8010441c:	a1 40 2e 11 80       	mov    0x80112e40,%eax
80104421:	8b 15 44 2e 11 80    	mov    0x80112e44,%edx
80104427:	89 41 10             	mov    %eax,0x10(%ecx)
8010442a:	89 51 14             	mov    %edx,0x14(%ecx)
  list_for_each(iter, head)
8010442d:	8b 09                	mov    (%ecx),%ecx
8010442f:	81 f9 34 2e 11 80    	cmp    $0x80112e34,%ecx
80104435:	75 d3                	jne    8010440a <wakeup+0x3a>
  wakeup1(chan);
  release(&ptable.lock);
80104437:	c7 45 08 00 2e 11 80 	movl   $0x80112e00,0x8(%ebp)
}
8010443e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104441:	c9                   	leave  
  release(&ptable.lock);
80104442:	e9 89 04 00 00       	jmp    801048d0 <release>
80104447:	89 f6                	mov    %esi,%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  struct list_head *head = &ptable.queue_head;
  struct list_head *iter;

  acquire(&ptable.lock);
8010445a:	68 00 2e 11 80       	push   $0x80112e00
8010445f:	e8 ac 03 00 00       	call   80104810 <acquire>
  list_for_each(iter, head)
80104464:	a1 34 2e 11 80       	mov    0x80112e34,%eax
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
80104471:	74 1b                	je     8010448e <kill+0x3e>
  {
    p = list_entry(iter, struct proc, queue_elem);

    if (p->pid == pid)
80104473:	3b 58 94             	cmp    -0x6c(%eax),%ebx
80104476:	75 0d                	jne    80104485 <kill+0x35>
80104478:	eb 36                	jmp    801044b0 <kill+0x60>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104480:	39 58 94             	cmp    %ebx,-0x6c(%eax)
80104483:	74 2b                	je     801044b0 <kill+0x60>
  list_for_each(iter, head)
80104485:	8b 00                	mov    (%eax),%eax
80104487:	3d 34 2e 11 80       	cmp    $0x80112e34,%eax
8010448c:	75 f2                	jne    80104480 <kill+0x30>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010448e:	83 ec 0c             	sub    $0xc,%esp
80104491:	68 00 2e 11 80       	push   $0x80112e00
80104496:	e8 35 04 00 00       	call   801048d0 <release>
  return -1;
8010449b:	83 c4 10             	add    $0x10,%esp
8010449e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a6:	c9                   	leave  
801044a7:	c3                   	ret    
801044a8:	90                   	nop
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (p->state == SLEEPING)
801044b0:	83 78 90 02          	cmpl   $0x2,-0x70(%eax)
      p->killed = 1;
801044b4:	c7 40 a8 01 00 00 00 	movl   $0x1,-0x58(%eax)
      if (p->state == SLEEPING)
801044bb:	75 07                	jne    801044c4 <kill+0x74>
        p->state = RUNNABLE;
801044bd:	c7 40 90 03 00 00 00 	movl   $0x3,-0x70(%eax)
      release(&ptable.lock);
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	68 00 2e 11 80       	push   $0x80112e00
801044cc:	e8 ff 03 00 00       	call   801048d0 <release>
      return 0;
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	31 c0                	xor    %eax,%eax
}
801044d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d9:	c9                   	leave  
801044da:	c3                   	ret    
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044e0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
801044e6:	83 ec 3c             	sub    $0x3c,%esp
  char *state;
  uint pc[10];
  struct list_head *head = &ptable.queue_head;
  struct list_head *iter;

  list_for_each(iter, head)
801044e9:	8b 1d 34 2e 11 80    	mov    0x80112e34,%ebx
801044ef:	81 fb 34 2e 11 80    	cmp    $0x80112e34,%ebx
801044f5:	74 60                	je     80104557 <procdump+0x77>
801044f7:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    p = list_entry(iter, struct proc, queue_elem);
    if (p->state == UNUSED)
80104500:	8b 43 90             	mov    -0x70(%ebx),%eax
80104503:	85 c0                	test   %eax,%eax
80104505:	74 46                	je     8010454d <procdump+0x6d>
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104507:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
8010450a:	ba e0 79 10 80       	mov    $0x801079e0,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010450f:	77 11                	ja     80104522 <procdump+0x42>
80104511:	8b 14 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%edx
      state = "???";
80104518:	b8 e0 79 10 80       	mov    $0x801079e0,%eax
8010451d:	85 d2                	test   %edx,%edx
8010451f:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104522:	8d 43 f0             	lea    -0x10(%ebx),%eax
80104525:	50                   	push   %eax
80104526:	52                   	push   %edx
80104527:	ff 73 94             	pushl  -0x6c(%ebx)
8010452a:	68 e4 79 10 80       	push   $0x801079e4
8010452f:	e8 2c c1 ff ff       	call   80100660 <cprintf>
    if (p->state == SLEEPING)
80104534:	83 c4 10             	add    $0x10,%esp
80104537:	83 7b 90 02          	cmpl   $0x2,-0x70(%ebx)
8010453b:	74 23                	je     80104560 <procdump+0x80>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010453d:	83 ec 0c             	sub    $0xc,%esp
80104540:	68 5b 7d 10 80       	push   $0x80107d5b
80104545:	e8 16 c1 ff ff       	call   80100660 <cprintf>
8010454a:	83 c4 10             	add    $0x10,%esp
  list_for_each(iter, head)
8010454d:	8b 1b                	mov    (%ebx),%ebx
8010454f:	81 fb 34 2e 11 80    	cmp    $0x80112e34,%ebx
80104555:	75 a9                	jne    80104500 <procdump+0x20>
  }
}
80104557:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010455a:	5b                   	pop    %ebx
8010455b:	5e                   	pop    %esi
8010455c:	5f                   	pop    %edi
8010455d:	5d                   	pop    %ebp
8010455e:	c3                   	ret    
8010455f:	90                   	nop
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104560:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104563:	83 ec 08             	sub    $0x8,%esp
80104566:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104569:	50                   	push   %eax
8010456a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010456d:	8b 40 0c             	mov    0xc(%eax),%eax
80104570:	83 c0 08             	add    $0x8,%eax
80104573:	50                   	push   %eax
80104574:	e8 77 01 00 00       	call   801046f0 <getcallerpcs>
80104579:	83 c4 10             	add    $0x10,%esp
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104580:	8b 07                	mov    (%edi),%eax
80104582:	85 c0                	test   %eax,%eax
80104584:	74 b7                	je     8010453d <procdump+0x5d>
        cprintf(" %p", pc[i]);
80104586:	83 ec 08             	sub    $0x8,%esp
80104589:	83 c7 04             	add    $0x4,%edi
8010458c:	50                   	push   %eax
8010458d:	68 21 74 10 80       	push   $0x80107421
80104592:	e8 c9 c0 ff ff       	call   80100660 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104597:	83 c4 10             	add    $0x10,%esp
8010459a:	39 f7                	cmp    %esi,%edi
8010459c:	75 e2                	jne    80104580 <procdump+0xa0>
8010459e:	eb 9d                	jmp    8010453d <procdump+0x5d>

801045a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 0c             	sub    $0xc,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045aa:	68 58 7a 10 80       	push   $0x80107a58
801045af:	8d 43 04             	lea    0x4(%ebx),%eax
801045b2:	50                   	push   %eax
801045b3:	e8 18 01 00 00       	call   801046d0 <initlock>
  lk->name = name;
801045b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave  
801045d2:	c3                   	ret    
801045d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045e8:	83 ec 0c             	sub    $0xc,%esp
801045eb:	8d 73 04             	lea    0x4(%ebx),%esi
801045ee:	56                   	push   %esi
801045ef:	e8 1c 02 00 00       	call   80104810 <acquire>
  while (lk->locked) {
801045f4:	8b 13                	mov    (%ebx),%edx
801045f6:	83 c4 10             	add    $0x10,%esp
801045f9:	85 d2                	test   %edx,%edx
801045fb:	74 16                	je     80104613 <acquiresleep+0x33>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104600:	83 ec 08             	sub    $0x8,%esp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	e8 d6 fb ff ff       	call   801041e0 <sleep>
  while (lk->locked) {
8010460a:	8b 03                	mov    (%ebx),%eax
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	75 ed                	jne    80104600 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104613:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104619:	e8 82 f5 ff ff       	call   80103ba0 <myproc>
8010461e:	8b 40 10             	mov    0x10(%eax),%eax
80104621:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104624:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104627:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462a:	5b                   	pop    %ebx
8010462b:	5e                   	pop    %esi
8010462c:	5d                   	pop    %ebp
  release(&lk->lk);
8010462d:	e9 9e 02 00 00       	jmp    801048d0 <release>
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	8d 73 04             	lea    0x4(%ebx),%esi
8010464e:	56                   	push   %esi
8010464f:	e8 bc 01 00 00       	call   80104810 <acquire>
  lk->locked = 0;
80104654:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010465a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104661:	89 1c 24             	mov    %ebx,(%esp)
80104664:	e8 67 fd ff ff       	call   801043d0 <wakeup>
  release(&lk->lk);
80104669:	89 75 08             	mov    %esi,0x8(%ebp)
8010466c:	83 c4 10             	add    $0x10,%esp
}
8010466f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104672:	5b                   	pop    %ebx
80104673:	5e                   	pop    %esi
80104674:	5d                   	pop    %ebp
  release(&lk->lk);
80104675:	e9 56 02 00 00       	jmp    801048d0 <release>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	53                   	push   %ebx
80104686:	31 ff                	xor    %edi,%edi
80104688:	83 ec 18             	sub    $0x18,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010468e:	8d 73 04             	lea    0x4(%ebx),%esi
80104691:	56                   	push   %esi
80104692:	e8 79 01 00 00       	call   80104810 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104697:	8b 03                	mov    (%ebx),%eax
80104699:	83 c4 10             	add    $0x10,%esp
8010469c:	85 c0                	test   %eax,%eax
8010469e:	74 13                	je     801046b3 <holdingsleep+0x33>
801046a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046a3:	e8 f8 f4 ff ff       	call   80103ba0 <myproc>
801046a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801046ab:	0f 94 c0             	sete   %al
801046ae:	0f b6 c0             	movzbl %al,%eax
801046b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801046b3:	83 ec 0c             	sub    $0xc,%esp
801046b6:	56                   	push   %esi
801046b7:	e8 14 02 00 00       	call   801048d0 <release>
  return r;
}
801046bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046bf:	89 f8                	mov    %edi,%eax
801046c1:	5b                   	pop    %ebx
801046c2:	5e                   	pop    %esi
801046c3:	5f                   	pop    %edi
801046c4:	5d                   	pop    %ebp
801046c5:	c3                   	ret    
801046c6:	66 90                	xchg   %ax,%ax
801046c8:	66 90                	xchg   %ax,%ax
801046ca:	66 90                	xchg   %ax,%ax
801046cc:	66 90                	xchg   %ax,%ax
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046f1:	31 d2                	xor    %edx,%edx
{
801046f3:	89 e5                	mov    %esp,%ebp
801046f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046fc:	83 e8 08             	sub    $0x8,%eax
801046ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104700:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104706:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010470c:	77 1a                	ja     80104728 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010470e:	8b 58 04             	mov    0x4(%eax),%ebx
80104711:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104714:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104717:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104719:	83 fa 0a             	cmp    $0xa,%edx
8010471c:	75 e2                	jne    80104700 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010471e:	5b                   	pop    %ebx
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104728:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010472b:	83 c1 28             	add    $0x28,%ecx
8010472e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104736:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104739:	39 c1                	cmp    %eax,%ecx
8010473b:	75 f3                	jne    80104730 <getcallerpcs+0x40>
}
8010473d:	5b                   	pop    %ebx
8010473e:	5d                   	pop    %ebp
8010473f:	c3                   	ret    

80104740 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 04             	sub    $0x4,%esp
80104747:	9c                   	pushf  
80104748:	5b                   	pop    %ebx
  asm volatile("cli");
80104749:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010474a:	e8 b1 f3 ff ff       	call   80103b00 <mycpu>
8010474f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	75 11                	jne    8010476a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104759:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010475f:	e8 9c f3 ff ff       	call   80103b00 <mycpu>
80104764:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010476a:	e8 91 f3 ff ff       	call   80103b00 <mycpu>
8010476f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104776:	83 c4 04             	add    $0x4,%esp
80104779:	5b                   	pop    %ebx
8010477a:	5d                   	pop    %ebp
8010477b:	c3                   	ret    
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <popcli>:

void
popcli(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104786:	9c                   	pushf  
80104787:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104788:	f6 c4 02             	test   $0x2,%ah
8010478b:	75 35                	jne    801047c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010478d:	e8 6e f3 ff ff       	call   80103b00 <mycpu>
80104792:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104799:	78 34                	js     801047cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010479b:	e8 60 f3 ff ff       	call   80103b00 <mycpu>
801047a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047a6:	85 d2                	test   %edx,%edx
801047a8:	74 06                	je     801047b0 <popcli+0x30>
    sti();
}
801047aa:	c9                   	leave  
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047b0:	e8 4b f3 ff ff       	call   80103b00 <mycpu>
801047b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047bb:	85 c0                	test   %eax,%eax
801047bd:	74 eb                	je     801047aa <popcli+0x2a>
  asm volatile("sti");
801047bf:	fb                   	sti    
}
801047c0:	c9                   	leave  
801047c1:	c3                   	ret    
    panic("popcli - interruptible");
801047c2:	83 ec 0c             	sub    $0xc,%esp
801047c5:	68 63 7a 10 80       	push   $0x80107a63
801047ca:	e8 c1 bb ff ff       	call   80100390 <panic>
    panic("popcli");
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	68 7a 7a 10 80       	push   $0x80107a7a
801047d7:	e8 b4 bb ff ff       	call   80100390 <panic>
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047e0 <holding>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 75 08             	mov    0x8(%ebp),%esi
801047e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047ea:	e8 51 ff ff ff       	call   80104740 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047ef:	8b 06                	mov    (%esi),%eax
801047f1:	85 c0                	test   %eax,%eax
801047f3:	74 10                	je     80104805 <holding+0x25>
801047f5:	8b 5e 08             	mov    0x8(%esi),%ebx
801047f8:	e8 03 f3 ff ff       	call   80103b00 <mycpu>
801047fd:	39 c3                	cmp    %eax,%ebx
801047ff:	0f 94 c3             	sete   %bl
80104802:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104805:	e8 76 ff ff ff       	call   80104780 <popcli>
}
8010480a:	89 d8                	mov    %ebx,%eax
8010480c:	5b                   	pop    %ebx
8010480d:	5e                   	pop    %esi
8010480e:	5d                   	pop    %ebp
8010480f:	c3                   	ret    

80104810 <acquire>:
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104815:	e8 26 ff ff ff       	call   80104740 <pushcli>
  if(holding(lk))
8010481a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	53                   	push   %ebx
80104821:	e8 ba ff ff ff       	call   801047e0 <holding>
80104826:	83 c4 10             	add    $0x10,%esp
80104829:	85 c0                	test   %eax,%eax
8010482b:	0f 85 83 00 00 00    	jne    801048b4 <acquire+0xa4>
80104831:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104833:	ba 01 00 00 00       	mov    $0x1,%edx
80104838:	eb 09                	jmp    80104843 <acquire+0x33>
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104840:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104843:	89 d0                	mov    %edx,%eax
80104845:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104848:	85 c0                	test   %eax,%eax
8010484a:	75 f4                	jne    80104840 <acquire+0x30>
  __sync_synchronize();
8010484c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104851:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104854:	e8 a7 f2 ff ff       	call   80103b00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104859:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010485c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010485f:	89 e8                	mov    %ebp,%eax
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104868:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010486e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104874:	77 1a                	ja     80104890 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104876:	8b 48 04             	mov    0x4(%eax),%ecx
80104879:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010487c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010487f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104881:	83 fe 0a             	cmp    $0xa,%esi
80104884:	75 e2                	jne    80104868 <acquire+0x58>
}
80104886:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
80104890:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104893:	83 c2 28             	add    $0x28,%edx
80104896:	8d 76 00             	lea    0x0(%esi),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801048a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048a9:	39 d0                	cmp    %edx,%eax
801048ab:	75 f3                	jne    801048a0 <acquire+0x90>
}
801048ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b0:	5b                   	pop    %ebx
801048b1:	5e                   	pop    %esi
801048b2:	5d                   	pop    %ebp
801048b3:	c3                   	ret    
    panic("acquire");
801048b4:	83 ec 0c             	sub    $0xc,%esp
801048b7:	68 81 7a 10 80       	push   $0x80107a81
801048bc:	e8 cf ba ff ff       	call   80100390 <panic>
801048c1:	eb 0d                	jmp    801048d0 <release>
801048c3:	90                   	nop
801048c4:	90                   	nop
801048c5:	90                   	nop
801048c6:	90                   	nop
801048c7:	90                   	nop
801048c8:	90                   	nop
801048c9:	90                   	nop
801048ca:	90                   	nop
801048cb:	90                   	nop
801048cc:	90                   	nop
801048cd:	90                   	nop
801048ce:	90                   	nop
801048cf:	90                   	nop

801048d0 <release>:
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 10             	sub    $0x10,%esp
801048d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801048da:	53                   	push   %ebx
801048db:	e8 00 ff ff ff       	call   801047e0 <holding>
801048e0:	83 c4 10             	add    $0x10,%esp
801048e3:	85 c0                	test   %eax,%eax
801048e5:	74 22                	je     80104909 <release+0x39>
  lk->pcs[0] = 0;
801048e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048f5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104900:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104903:	c9                   	leave  
  popcli();
80104904:	e9 77 fe ff ff       	jmp    80104780 <popcli>
    panic("release");
80104909:	83 ec 0c             	sub    $0xc,%esp
8010490c:	68 89 7a 10 80       	push   $0x80107a89
80104911:	e8 7a ba ff ff       	call   80100390 <panic>
80104916:	66 90                	xchg   %ax,%ax
80104918:	66 90                	xchg   %ax,%ax
8010491a:	66 90                	xchg   %ax,%ax
8010491c:	66 90                	xchg   %ax,%ax
8010491e:	66 90                	xchg   %ax,%ax

80104920 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	53                   	push   %ebx
80104925:	8b 55 08             	mov    0x8(%ebp),%edx
80104928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010492b:	f6 c2 03             	test   $0x3,%dl
8010492e:	75 05                	jne    80104935 <memset+0x15>
80104930:	f6 c1 03             	test   $0x3,%cl
80104933:	74 13                	je     80104948 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104935:	89 d7                	mov    %edx,%edi
80104937:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493a:	fc                   	cld    
8010493b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010493d:	5b                   	pop    %ebx
8010493e:	89 d0                	mov    %edx,%eax
80104940:	5f                   	pop    %edi
80104941:	5d                   	pop    %ebp
80104942:	c3                   	ret    
80104943:	90                   	nop
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104948:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010494c:	c1 e9 02             	shr    $0x2,%ecx
8010494f:	89 f8                	mov    %edi,%eax
80104951:	89 fb                	mov    %edi,%ebx
80104953:	c1 e0 18             	shl    $0x18,%eax
80104956:	c1 e3 10             	shl    $0x10,%ebx
80104959:	09 d8                	or     %ebx,%eax
8010495b:	09 f8                	or     %edi,%eax
8010495d:	c1 e7 08             	shl    $0x8,%edi
80104960:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104962:	89 d7                	mov    %edx,%edi
80104964:	fc                   	cld    
80104965:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104967:	5b                   	pop    %ebx
80104968:	89 d0                	mov    %edx,%eax
8010496a:	5f                   	pop    %edi
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret    
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	53                   	push   %ebx
80104976:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104979:	8b 75 08             	mov    0x8(%ebp),%esi
8010497c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010497f:	85 db                	test   %ebx,%ebx
80104981:	74 29                	je     801049ac <memcmp+0x3c>
    if(*s1 != *s2)
80104983:	0f b6 16             	movzbl (%esi),%edx
80104986:	0f b6 0f             	movzbl (%edi),%ecx
80104989:	38 d1                	cmp    %dl,%cl
8010498b:	75 2b                	jne    801049b8 <memcmp+0x48>
8010498d:	b8 01 00 00 00       	mov    $0x1,%eax
80104992:	eb 14                	jmp    801049a8 <memcmp+0x38>
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104998:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010499c:	83 c0 01             	add    $0x1,%eax
8010499f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801049a4:	38 ca                	cmp    %cl,%dl
801049a6:	75 10                	jne    801049b8 <memcmp+0x48>
  while(n-- > 0){
801049a8:	39 d8                	cmp    %ebx,%eax
801049aa:	75 ec                	jne    80104998 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049ac:	5b                   	pop    %ebx
  return 0;
801049ad:	31 c0                	xor    %eax,%eax
}
801049af:	5e                   	pop    %esi
801049b0:	5f                   	pop    %edi
801049b1:	5d                   	pop    %ebp
801049b2:	c3                   	ret    
801049b3:	90                   	nop
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801049b8:	0f b6 c2             	movzbl %dl,%eax
}
801049bb:	5b                   	pop    %ebx
      return *s1 - *s2;
801049bc:	29 c8                	sub    %ecx,%eax
}
801049be:	5e                   	pop    %esi
801049bf:	5f                   	pop    %edi
801049c0:	5d                   	pop    %ebp
801049c1:	c3                   	ret    
801049c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 45 08             	mov    0x8(%ebp),%eax
801049d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049db:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049de:	39 c3                	cmp    %eax,%ebx
801049e0:	73 26                	jae    80104a08 <memmove+0x38>
801049e2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801049e5:	39 c8                	cmp    %ecx,%eax
801049e7:	73 1f                	jae    80104a08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801049e9:	85 f6                	test   %esi,%esi
801049eb:	8d 56 ff             	lea    -0x1(%esi),%edx
801049ee:	74 0f                	je     801049ff <memmove+0x2f>
      *--d = *--s;
801049f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801049f7:	83 ea 01             	sub    $0x1,%edx
801049fa:	83 fa ff             	cmp    $0xffffffff,%edx
801049fd:	75 f1                	jne    801049f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049ff:	5b                   	pop    %ebx
80104a00:	5e                   	pop    %esi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a08:	31 d2                	xor    %edx,%edx
80104a0a:	85 f6                	test   %esi,%esi
80104a0c:	74 f1                	je     801049ff <memmove+0x2f>
80104a0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a1a:	39 d6                	cmp    %edx,%esi
80104a1c:	75 f2                	jne    80104a10 <memmove+0x40>
}
80104a1e:	5b                   	pop    %ebx
80104a1f:	5e                   	pop    %esi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a34:	eb 9a                	jmp    801049d0 <memmove>
80104a36:	8d 76 00             	lea    0x0(%esi),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a48:	53                   	push   %ebx
80104a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a4f:	85 ff                	test   %edi,%edi
80104a51:	74 2f                	je     80104a82 <strncmp+0x42>
80104a53:	0f b6 01             	movzbl (%ecx),%eax
80104a56:	0f b6 1e             	movzbl (%esi),%ebx
80104a59:	84 c0                	test   %al,%al
80104a5b:	74 37                	je     80104a94 <strncmp+0x54>
80104a5d:	38 c3                	cmp    %al,%bl
80104a5f:	75 33                	jne    80104a94 <strncmp+0x54>
80104a61:	01 f7                	add    %esi,%edi
80104a63:	eb 13                	jmp    80104a78 <strncmp+0x38>
80104a65:	8d 76 00             	lea    0x0(%esi),%esi
80104a68:	0f b6 01             	movzbl (%ecx),%eax
80104a6b:	84 c0                	test   %al,%al
80104a6d:	74 21                	je     80104a90 <strncmp+0x50>
80104a6f:	0f b6 1a             	movzbl (%edx),%ebx
80104a72:	89 d6                	mov    %edx,%esi
80104a74:	38 d8                	cmp    %bl,%al
80104a76:	75 1c                	jne    80104a94 <strncmp+0x54>
    n--, p++, q++;
80104a78:	8d 56 01             	lea    0x1(%esi),%edx
80104a7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a7e:	39 fa                	cmp    %edi,%edx
80104a80:	75 e6                	jne    80104a68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a82:	5b                   	pop    %ebx
    return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	5e                   	pop    %esi
80104a86:	5f                   	pop    %edi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a94:	29 d8                	sub    %ebx,%eax
}
80104a96:	5b                   	pop    %ebx
80104a97:	5e                   	pop    %esi
80104a98:	5f                   	pop    %edi
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	90                   	nop
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104aae:	89 c2                	mov    %eax,%edx
80104ab0:	eb 19                	jmp    80104acb <strncpy+0x2b>
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ab8:	83 c3 01             	add    $0x1,%ebx
80104abb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104abf:	83 c2 01             	add    $0x1,%edx
80104ac2:	84 c9                	test   %cl,%cl
80104ac4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ac7:	74 09                	je     80104ad2 <strncpy+0x32>
80104ac9:	89 f1                	mov    %esi,%ecx
80104acb:	85 c9                	test   %ecx,%ecx
80104acd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ad0:	7f e6                	jg     80104ab8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ad2:	31 c9                	xor    %ecx,%ecx
80104ad4:	85 f6                	test   %esi,%esi
80104ad6:	7e 17                	jle    80104aef <strncpy+0x4f>
80104ad8:	90                   	nop
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ae0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ae4:	89 f3                	mov    %esi,%ebx
80104ae6:	83 c1 01             	add    $0x1,%ecx
80104ae9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104aeb:	85 db                	test   %ebx,%ebx
80104aed:	7f f1                	jg     80104ae0 <strncpy+0x40>
  return os;
}
80104aef:	5b                   	pop    %ebx
80104af0:	5e                   	pop    %esi
80104af1:	5d                   	pop    %ebp
80104af2:	c3                   	ret    
80104af3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b08:	8b 45 08             	mov    0x8(%ebp),%eax
80104b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b0e:	85 c9                	test   %ecx,%ecx
80104b10:	7e 26                	jle    80104b38 <safestrcpy+0x38>
80104b12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b16:	89 c1                	mov    %eax,%ecx
80104b18:	eb 17                	jmp    80104b31 <safestrcpy+0x31>
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b20:	83 c2 01             	add    $0x1,%edx
80104b23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b27:	83 c1 01             	add    $0x1,%ecx
80104b2a:	84 db                	test   %bl,%bl
80104b2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b2f:	74 04                	je     80104b35 <safestrcpy+0x35>
80104b31:	39 f2                	cmp    %esi,%edx
80104b33:	75 eb                	jne    80104b20 <safestrcpy+0x20>
    ;
  *s = 0;
80104b35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b38:	5b                   	pop    %ebx
80104b39:	5e                   	pop    %esi
80104b3a:	5d                   	pop    %ebp
80104b3b:	c3                   	ret    
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b40 <strlen>:

int
strlen(const char *s)
{
80104b40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b41:	31 c0                	xor    %eax,%eax
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b48:	80 3a 00             	cmpb   $0x0,(%edx)
80104b4b:	74 0c                	je     80104b59 <strlen+0x19>
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b57:	75 f7                	jne    80104b50 <strlen+0x10>
    ;
  return n;
}
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    

80104b5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b63:	55                   	push   %ebp
  pushl %ebx
80104b64:	53                   	push   %ebx
  pushl %esi
80104b65:	56                   	push   %esi
  pushl %edi
80104b66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b6b:	5f                   	pop    %edi
  popl %esi
80104b6c:	5e                   	pop    %esi
  popl %ebx
80104b6d:	5b                   	pop    %ebx
  popl %ebp
80104b6e:	5d                   	pop    %ebp
  ret
80104b6f:	c3                   	ret    

80104b70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
80104b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b7a:	e8 21 f0 ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7f:	8b 00                	mov    (%eax),%eax
80104b81:	39 d8                	cmp    %ebx,%eax
80104b83:	76 1b                	jbe    80104ba0 <fetchint+0x30>
80104b85:	8d 53 04             	lea    0x4(%ebx),%edx
80104b88:	39 d0                	cmp    %edx,%eax
80104b8a:	72 14                	jb     80104ba0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8f:	8b 13                	mov    (%ebx),%edx
80104b91:	89 10                	mov    %edx,(%eax)
  return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	83 c4 04             	add    $0x4,%esp
80104b98:	5b                   	pop    %ebx
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba5:	eb ee                	jmp    80104b95 <fetchint+0x25>
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bba:	e8 e1 ef ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz)
80104bbf:	39 18                	cmp    %ebx,(%eax)
80104bc1:	76 29                	jbe    80104bec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104bc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104bc6:	89 da                	mov    %ebx,%edx
80104bc8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bcc:	39 c3                	cmp    %eax,%ebx
80104bce:	73 1c                	jae    80104bec <fetchstr+0x3c>
    if(*s == 0)
80104bd0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104bd3:	75 10                	jne    80104be5 <fetchstr+0x35>
80104bd5:	eb 39                	jmp    80104c10 <fetchstr+0x60>
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104be0:	80 3a 00             	cmpb   $0x0,(%edx)
80104be3:	74 1b                	je     80104c00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104be5:	83 c2 01             	add    $0x1,%edx
80104be8:	39 d0                	cmp    %edx,%eax
80104bea:	77 f4                	ja     80104be0 <fetchstr+0x30>
    return -1;
80104bec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104bf1:	83 c4 04             	add    $0x4,%esp
80104bf4:	5b                   	pop    %ebx
80104bf5:	5d                   	pop    %ebp
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c00:	83 c4 04             	add    $0x4,%esp
80104c03:	89 d0                	mov    %edx,%eax
80104c05:	29 d8                	sub    %ebx,%eax
80104c07:	5b                   	pop    %ebx
80104c08:	5d                   	pop    %ebp
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c12:	eb dd                	jmp    80104bf1 <fetchstr+0x41>
80104c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 76 ef ff ff       	call   80103ba0 <myproc>
80104c2a:	8b 40 18             	mov    0x18(%eax),%eax
80104c2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 65 ef ff ff       	call   80103ba0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 1c                	jae    80104c60 <argint+0x40>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 15                	jb     80104c60 <argint+0x40>
  *ip = *(int*)(addr);
80104c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5d                   	pop    %ebp
80104c58:	c3                   	ret    
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	eb ee                	jmp    80104c55 <argint+0x35>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	83 ec 10             	sub    $0x10,%esp
80104c78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c7b:	e8 20 ef ff ff       	call   80103ba0 <myproc>
80104c80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c85:	83 ec 08             	sub    $0x8,%esp
80104c88:	50                   	push   %eax
80104c89:	ff 75 08             	pushl  0x8(%ebp)
80104c8c:	e8 8f ff ff ff       	call   80104c20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c91:	83 c4 10             	add    $0x10,%esp
80104c94:	85 c0                	test   %eax,%eax
80104c96:	78 28                	js     80104cc0 <argptr+0x50>
80104c98:	85 db                	test   %ebx,%ebx
80104c9a:	78 24                	js     80104cc0 <argptr+0x50>
80104c9c:	8b 16                	mov    (%esi),%edx
80104c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca1:	39 c2                	cmp    %eax,%edx
80104ca3:	76 1b                	jbe    80104cc0 <argptr+0x50>
80104ca5:	01 c3                	add    %eax,%ebx
80104ca7:	39 da                	cmp    %ebx,%edx
80104ca9:	72 15                	jb     80104cc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cae:	89 02                	mov    %eax,(%edx)
  return 0;
80104cb0:	31 c0                	xor    %eax,%eax
}
80104cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb5:	5b                   	pop    %ebx
80104cb6:	5e                   	pop    %esi
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc5:	eb eb                	jmp    80104cb2 <argptr+0x42>
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd9:	50                   	push   %eax
80104cda:	ff 75 08             	pushl  0x8(%ebp)
80104cdd:	e8 3e ff ff ff       	call   80104c20 <argint>
80104ce2:	83 c4 10             	add    $0x10,%esp
80104ce5:	85 c0                	test   %eax,%eax
80104ce7:	78 17                	js     80104d00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ce9:	83 ec 08             	sub    $0x8,%esp
80104cec:	ff 75 0c             	pushl  0xc(%ebp)
80104cef:	ff 75 f4             	pushl  -0xc(%ebp)
80104cf2:	e8 b9 fe ff ff       	call   80104bb0 <fetchstr>
80104cf7:	83 c4 10             	add    $0x10,%esp
}
80104cfa:	c9                   	leave  
80104cfb:	c3                   	ret    
80104cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <syscall>:
[SYS_stride]  sys_stride,
};

void
syscall(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d17:	e8 84 ee ff ff       	call   80103ba0 <myproc>
80104d1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d1e:	8b 40 18             	mov    0x18(%eax),%eax
80104d21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d27:	83 fa 15             	cmp    $0x15,%edx
80104d2a:	77 1c                	ja     80104d48 <syscall+0x38>
80104d2c:	8b 14 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%edx
80104d33:	85 d2                	test   %edx,%edx
80104d35:	74 11                	je     80104d48 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d37:	ff d2                	call   *%edx
80104d39:	8b 53 18             	mov    0x18(%ebx),%edx
80104d3c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d42:	c9                   	leave  
80104d43:	c3                   	ret    
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d4c:	50                   	push   %eax
80104d4d:	ff 73 10             	pushl  0x10(%ebx)
80104d50:	68 91 7a 10 80       	push   $0x80107a91
80104d55:	e8 06 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104d5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d5d:	83 c4 10             	add    $0x10,%esp
80104d60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d6a:	c9                   	leave  
80104d6b:	c3                   	ret    
80104d6c:	66 90                	xchg   %ax,%ax
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d76:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104d79:	83 ec 44             	sub    $0x44,%esp
80104d7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d82:	56                   	push   %esi
80104d83:	50                   	push   %eax
{
80104d84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d87:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d8a:	e8 81 d1 ff ff       	call   80101f10 <nameiparent>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	85 c0                	test   %eax,%eax
80104d94:	0f 84 46 01 00 00    	je     80104ee0 <create+0x170>
    return 0;
  ilock(dp);
80104d9a:	83 ec 0c             	sub    $0xc,%esp
80104d9d:	89 c3                	mov    %eax,%ebx
80104d9f:	50                   	push   %eax
80104da0:	e8 eb c8 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104da5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104da8:	83 c4 0c             	add    $0xc,%esp
80104dab:	50                   	push   %eax
80104dac:	56                   	push   %esi
80104dad:	53                   	push   %ebx
80104dae:	e8 0d ce ff ff       	call   80101bc0 <dirlookup>
80104db3:	83 c4 10             	add    $0x10,%esp
80104db6:	85 c0                	test   %eax,%eax
80104db8:	89 c7                	mov    %eax,%edi
80104dba:	74 34                	je     80104df0 <create+0x80>
    iunlockput(dp);
80104dbc:	83 ec 0c             	sub    $0xc,%esp
80104dbf:	53                   	push   %ebx
80104dc0:	e8 5b cb ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104dc5:	89 3c 24             	mov    %edi,(%esp)
80104dc8:	e8 c3 c8 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104dd5:	0f 85 95 00 00 00    	jne    80104e70 <create+0x100>
80104ddb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104de0:	0f 85 8a 00 00 00    	jne    80104e70 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de9:	89 f8                	mov    %edi,%eax
80104deb:	5b                   	pop    %ebx
80104dec:	5e                   	pop    %esi
80104ded:	5f                   	pop    %edi
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104df0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104df4:	83 ec 08             	sub    $0x8,%esp
80104df7:	50                   	push   %eax
80104df8:	ff 33                	pushl  (%ebx)
80104dfa:	e8 21 c7 ff ff       	call   80101520 <ialloc>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	85 c0                	test   %eax,%eax
80104e04:	89 c7                	mov    %eax,%edi
80104e06:	0f 84 e8 00 00 00    	je     80104ef4 <create+0x184>
  ilock(ip);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	50                   	push   %eax
80104e10:	e8 7b c8 ff ff       	call   80101690 <ilock>
  ip->major = major;
80104e15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e25:	b8 01 00 00 00       	mov    $0x1,%eax
80104e2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e2e:	89 3c 24             	mov    %edi,(%esp)
80104e31:	e8 aa c7 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e36:	83 c4 10             	add    $0x10,%esp
80104e39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e3e:	74 50                	je     80104e90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e40:	83 ec 04             	sub    $0x4,%esp
80104e43:	ff 77 04             	pushl  0x4(%edi)
80104e46:	56                   	push   %esi
80104e47:	53                   	push   %ebx
80104e48:	e8 e3 cf ff ff       	call   80101e30 <dirlink>
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	85 c0                	test   %eax,%eax
80104e52:	0f 88 8f 00 00 00    	js     80104ee7 <create+0x177>
  iunlockput(dp);
80104e58:	83 ec 0c             	sub    $0xc,%esp
80104e5b:	53                   	push   %ebx
80104e5c:	e8 bf ca ff ff       	call   80101920 <iunlockput>
  return ip;
80104e61:	83 c4 10             	add    $0x10,%esp
}
80104e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e67:	89 f8                	mov    %edi,%eax
80104e69:	5b                   	pop    %ebx
80104e6a:	5e                   	pop    %esi
80104e6b:	5f                   	pop    %edi
80104e6c:	5d                   	pop    %ebp
80104e6d:	c3                   	ret    
80104e6e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	57                   	push   %edi
    return 0;
80104e74:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e76:	e8 a5 ca ff ff       	call   80101920 <iunlockput>
    return 0;
80104e7b:	83 c4 10             	add    $0x10,%esp
}
80104e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e81:	89 f8                	mov    %edi,%eax
80104e83:	5b                   	pop    %ebx
80104e84:	5e                   	pop    %esi
80104e85:	5f                   	pop    %edi
80104e86:	5d                   	pop    %ebp
80104e87:	c3                   	ret    
80104e88:	90                   	nop
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104e90:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e95:	83 ec 0c             	sub    $0xc,%esp
80104e98:	53                   	push   %ebx
80104e99:	e8 42 c7 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e9e:	83 c4 0c             	add    $0xc,%esp
80104ea1:	ff 77 04             	pushl  0x4(%edi)
80104ea4:	68 38 7b 10 80       	push   $0x80107b38
80104ea9:	57                   	push   %edi
80104eaa:	e8 81 cf ff ff       	call   80101e30 <dirlink>
80104eaf:	83 c4 10             	add    $0x10,%esp
80104eb2:	85 c0                	test   %eax,%eax
80104eb4:	78 1c                	js     80104ed2 <create+0x162>
80104eb6:	83 ec 04             	sub    $0x4,%esp
80104eb9:	ff 73 04             	pushl  0x4(%ebx)
80104ebc:	68 37 7b 10 80       	push   $0x80107b37
80104ec1:	57                   	push   %edi
80104ec2:	e8 69 cf ff ff       	call   80101e30 <dirlink>
80104ec7:	83 c4 10             	add    $0x10,%esp
80104eca:	85 c0                	test   %eax,%eax
80104ecc:	0f 89 6e ff ff ff    	jns    80104e40 <create+0xd0>
      panic("create dots");
80104ed2:	83 ec 0c             	sub    $0xc,%esp
80104ed5:	68 2b 7b 10 80       	push   $0x80107b2b
80104eda:	e8 b1 b4 ff ff       	call   80100390 <panic>
80104edf:	90                   	nop
    return 0;
80104ee0:	31 ff                	xor    %edi,%edi
80104ee2:	e9 ff fe ff ff       	jmp    80104de6 <create+0x76>
    panic("create: dirlink");
80104ee7:	83 ec 0c             	sub    $0xc,%esp
80104eea:	68 3a 7b 10 80       	push   $0x80107b3a
80104eef:	e8 9c b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	68 1c 7b 10 80       	push   $0x80107b1c
80104efc:	e8 8f b4 ff ff       	call   80100390 <panic>
80104f01:	eb 0d                	jmp    80104f10 <argfd.constprop.0>
80104f03:	90                   	nop
80104f04:	90                   	nop
80104f05:	90                   	nop
80104f06:	90                   	nop
80104f07:	90                   	nop
80104f08:	90                   	nop
80104f09:	90                   	nop
80104f0a:	90                   	nop
80104f0b:	90                   	nop
80104f0c:	90                   	nop
80104f0d:	90                   	nop
80104f0e:	90                   	nop
80104f0f:	90                   	nop

80104f10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
80104f15:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f17:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f1a:	89 d6                	mov    %edx,%esi
80104f1c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f1f:	50                   	push   %eax
80104f20:	6a 00                	push   $0x0
80104f22:	e8 f9 fc ff ff       	call   80104c20 <argint>
80104f27:	83 c4 10             	add    $0x10,%esp
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	78 2a                	js     80104f58 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f2e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f32:	77 24                	ja     80104f58 <argfd.constprop.0+0x48>
80104f34:	e8 67 ec ff ff       	call   80103ba0 <myproc>
80104f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f3c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f40:	85 c0                	test   %eax,%eax
80104f42:	74 14                	je     80104f58 <argfd.constprop.0+0x48>
  if(pfd)
80104f44:	85 db                	test   %ebx,%ebx
80104f46:	74 02                	je     80104f4a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f48:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f4a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f4c:	31 c0                	xor    %eax,%eax
}
80104f4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f51:	5b                   	pop    %ebx
80104f52:	5e                   	pop    %esi
80104f53:	5d                   	pop    %ebp
80104f54:	c3                   	ret    
80104f55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f5d:	eb ef                	jmp    80104f4e <argfd.constprop.0+0x3e>
80104f5f:	90                   	nop

80104f60 <sys_dup>:
{
80104f60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f61:	31 c0                	xor    %eax,%eax
{
80104f63:	89 e5                	mov    %esp,%ebp
80104f65:	56                   	push   %esi
80104f66:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f67:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f6a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f6d:	e8 9e ff ff ff       	call   80104f10 <argfd.constprop.0>
80104f72:	85 c0                	test   %eax,%eax
80104f74:	78 42                	js     80104fb8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104f76:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f79:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f7b:	e8 20 ec ff ff       	call   80103ba0 <myproc>
80104f80:	eb 0e                	jmp    80104f90 <sys_dup+0x30>
80104f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f88:	83 c3 01             	add    $0x1,%ebx
80104f8b:	83 fb 10             	cmp    $0x10,%ebx
80104f8e:	74 28                	je     80104fb8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104f90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f94:	85 d2                	test   %edx,%edx
80104f96:	75 f0                	jne    80104f88 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104f98:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f9c:	83 ec 0c             	sub    $0xc,%esp
80104f9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104fa2:	e8 49 be ff ff       	call   80100df0 <filedup>
  return fd;
80104fa7:	83 c4 10             	add    $0x10,%esp
}
80104faa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fad:	89 d8                	mov    %ebx,%eax
80104faf:	5b                   	pop    %ebx
80104fb0:	5e                   	pop    %esi
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret    
80104fb3:	90                   	nop
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fc0:	89 d8                	mov    %ebx,%eax
80104fc2:	5b                   	pop    %ebx
80104fc3:	5e                   	pop    %esi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d 76 00             	lea    0x0(%esi),%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <sys_read>:
{
80104fd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd1:	31 c0                	xor    %eax,%eax
{
80104fd3:	89 e5                	mov    %esp,%ebp
80104fd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fdb:	e8 30 ff ff ff       	call   80104f10 <argfd.constprop.0>
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	78 4c                	js     80105030 <sys_read+0x60>
80104fe4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fe7:	83 ec 08             	sub    $0x8,%esp
80104fea:	50                   	push   %eax
80104feb:	6a 02                	push   $0x2
80104fed:	e8 2e fc ff ff       	call   80104c20 <argint>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	78 37                	js     80105030 <sys_read+0x60>
80104ff9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ffc:	83 ec 04             	sub    $0x4,%esp
80104fff:	ff 75 f0             	pushl  -0x10(%ebp)
80105002:	50                   	push   %eax
80105003:	6a 01                	push   $0x1
80105005:	e8 66 fc ff ff       	call   80104c70 <argptr>
8010500a:	83 c4 10             	add    $0x10,%esp
8010500d:	85 c0                	test   %eax,%eax
8010500f:	78 1f                	js     80105030 <sys_read+0x60>
  return fileread(f, p, n);
80105011:	83 ec 04             	sub    $0x4,%esp
80105014:	ff 75 f0             	pushl  -0x10(%ebp)
80105017:	ff 75 f4             	pushl  -0xc(%ebp)
8010501a:	ff 75 ec             	pushl  -0x14(%ebp)
8010501d:	e8 3e bf ff ff       	call   80100f60 <fileread>
80105022:	83 c4 10             	add    $0x10,%esp
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <sys_write>:
{
80105040:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105041:	31 c0                	xor    %eax,%eax
{
80105043:	89 e5                	mov    %esp,%ebp
80105045:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105048:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010504b:	e8 c0 fe ff ff       	call   80104f10 <argfd.constprop.0>
80105050:	85 c0                	test   %eax,%eax
80105052:	78 4c                	js     801050a0 <sys_write+0x60>
80105054:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105057:	83 ec 08             	sub    $0x8,%esp
8010505a:	50                   	push   %eax
8010505b:	6a 02                	push   $0x2
8010505d:	e8 be fb ff ff       	call   80104c20 <argint>
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	78 37                	js     801050a0 <sys_write+0x60>
80105069:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010506c:	83 ec 04             	sub    $0x4,%esp
8010506f:	ff 75 f0             	pushl  -0x10(%ebp)
80105072:	50                   	push   %eax
80105073:	6a 01                	push   $0x1
80105075:	e8 f6 fb ff ff       	call   80104c70 <argptr>
8010507a:	83 c4 10             	add    $0x10,%esp
8010507d:	85 c0                	test   %eax,%eax
8010507f:	78 1f                	js     801050a0 <sys_write+0x60>
  return filewrite(f, p, n);
80105081:	83 ec 04             	sub    $0x4,%esp
80105084:	ff 75 f0             	pushl  -0x10(%ebp)
80105087:	ff 75 f4             	pushl  -0xc(%ebp)
8010508a:	ff 75 ec             	pushl  -0x14(%ebp)
8010508d:	e8 5e bf ff ff       	call   80100ff0 <filewrite>
80105092:	83 c4 10             	add    $0x10,%esp
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <sys_close>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050bc:	e8 4f fe ff ff       	call   80104f10 <argfd.constprop.0>
801050c1:	85 c0                	test   %eax,%eax
801050c3:	78 2b                	js     801050f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801050c5:	e8 d6 ea ff ff       	call   80103ba0 <myproc>
801050ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050d7:	00 
  fileclose(f);
801050d8:	ff 75 f4             	pushl  -0xc(%ebp)
801050db:	e8 60 bd ff ff       	call   80100e40 <fileclose>
  return 0;
801050e0:	83 c4 10             	add    $0x10,%esp
801050e3:	31 c0                	xor    %eax,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105101:	31 c0                	xor    %eax,%eax
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105108:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010510b:	e8 00 fe ff ff       	call   80104f10 <argfd.constprop.0>
80105110:	85 c0                	test   %eax,%eax
80105112:	78 2c                	js     80105140 <sys_fstat+0x40>
80105114:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105117:	83 ec 04             	sub    $0x4,%esp
8010511a:	6a 14                	push   $0x14
8010511c:	50                   	push   %eax
8010511d:	6a 01                	push   $0x1
8010511f:	e8 4c fb ff ff       	call   80104c70 <argptr>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
80105129:	78 15                	js     80105140 <sys_fstat+0x40>
  return filestat(f, st);
8010512b:	83 ec 08             	sub    $0x8,%esp
8010512e:	ff 75 f4             	pushl  -0xc(%ebp)
80105131:	ff 75 f0             	pushl  -0x10(%ebp)
80105134:	e8 d7 bd ff ff       	call   80100f10 <filestat>
80105139:	83 c4 10             	add    $0x10,%esp
}
8010513c:	c9                   	leave  
8010513d:	c3                   	ret    
8010513e:	66 90                	xchg   %ax,%ax
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105150 <sys_link>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
80105155:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105156:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105159:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010515c:	50                   	push   %eax
8010515d:	6a 00                	push   $0x0
8010515f:	e8 6c fb ff ff       	call   80104cd0 <argstr>
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	85 c0                	test   %eax,%eax
80105169:	0f 88 fb 00 00 00    	js     8010526a <sys_link+0x11a>
8010516f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105172:	83 ec 08             	sub    $0x8,%esp
80105175:	50                   	push   %eax
80105176:	6a 01                	push   $0x1
80105178:	e8 53 fb ff ff       	call   80104cd0 <argstr>
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	85 c0                	test   %eax,%eax
80105182:	0f 88 e2 00 00 00    	js     8010526a <sys_link+0x11a>
  begin_op();
80105188:	e8 b3 db ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
8010518d:	83 ec 0c             	sub    $0xc,%esp
80105190:	ff 75 d4             	pushl  -0x2c(%ebp)
80105193:	e8 58 cd ff ff       	call   80101ef0 <namei>
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	85 c0                	test   %eax,%eax
8010519d:	89 c3                	mov    %eax,%ebx
8010519f:	0f 84 ea 00 00 00    	je     8010528f <sys_link+0x13f>
  ilock(ip);
801051a5:	83 ec 0c             	sub    $0xc,%esp
801051a8:	50                   	push   %eax
801051a9:	e8 e2 c4 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b6:	0f 84 bb 00 00 00    	je     80105277 <sys_link+0x127>
  ip->nlink++;
801051bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051c1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801051c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051c7:	53                   	push   %ebx
801051c8:	e8 13 c4 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
801051cd:	89 1c 24             	mov    %ebx,(%esp)
801051d0:	e8 9b c5 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051d5:	58                   	pop    %eax
801051d6:	5a                   	pop    %edx
801051d7:	57                   	push   %edi
801051d8:	ff 75 d0             	pushl  -0x30(%ebp)
801051db:	e8 30 cd ff ff       	call   80101f10 <nameiparent>
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	85 c0                	test   %eax,%eax
801051e5:	89 c6                	mov    %eax,%esi
801051e7:	74 5b                	je     80105244 <sys_link+0xf4>
  ilock(dp);
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	50                   	push   %eax
801051ed:	e8 9e c4 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	8b 03                	mov    (%ebx),%eax
801051f7:	39 06                	cmp    %eax,(%esi)
801051f9:	75 3d                	jne    80105238 <sys_link+0xe8>
801051fb:	83 ec 04             	sub    $0x4,%esp
801051fe:	ff 73 04             	pushl  0x4(%ebx)
80105201:	57                   	push   %edi
80105202:	56                   	push   %esi
80105203:	e8 28 cc ff ff       	call   80101e30 <dirlink>
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	85 c0                	test   %eax,%eax
8010520d:	78 29                	js     80105238 <sys_link+0xe8>
  iunlockput(dp);
8010520f:	83 ec 0c             	sub    $0xc,%esp
80105212:	56                   	push   %esi
80105213:	e8 08 c7 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105218:	89 1c 24             	mov    %ebx,(%esp)
8010521b:	e8 a0 c5 ff ff       	call   801017c0 <iput>
  end_op();
80105220:	e8 8b db ff ff       	call   80102db0 <end_op>
  return 0;
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	31 c0                	xor    %eax,%eax
}
8010522a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010522d:	5b                   	pop    %ebx
8010522e:	5e                   	pop    %esi
8010522f:	5f                   	pop    %edi
80105230:	5d                   	pop    %ebp
80105231:	c3                   	ret    
80105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	56                   	push   %esi
8010523c:	e8 df c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105241:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	53                   	push   %ebx
80105248:	e8 43 c4 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010524d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105252:	89 1c 24             	mov    %ebx,(%esp)
80105255:	e8 86 c3 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010525a:	89 1c 24             	mov    %ebx,(%esp)
8010525d:	e8 be c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105262:	e8 49 db ff ff       	call   80102db0 <end_op>
  return -1;
80105267:	83 c4 10             	add    $0x10,%esp
}
8010526a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010526d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105272:	5b                   	pop    %ebx
80105273:	5e                   	pop    %esi
80105274:	5f                   	pop    %edi
80105275:	5d                   	pop    %ebp
80105276:	c3                   	ret    
    iunlockput(ip);
80105277:	83 ec 0c             	sub    $0xc,%esp
8010527a:	53                   	push   %ebx
8010527b:	e8 a0 c6 ff ff       	call   80101920 <iunlockput>
    end_op();
80105280:	e8 2b db ff ff       	call   80102db0 <end_op>
    return -1;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528d:	eb 9b                	jmp    8010522a <sys_link+0xda>
    end_op();
8010528f:	e8 1c db ff ff       	call   80102db0 <end_op>
    return -1;
80105294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105299:	eb 8f                	jmp    8010522a <sys_link+0xda>
8010529b:	90                   	nop
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_unlink>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801052a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801052ac:	50                   	push   %eax
801052ad:	6a 00                	push   $0x0
801052af:	e8 1c fa ff ff       	call   80104cd0 <argstr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	0f 88 77 01 00 00    	js     80105436 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801052bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801052c2:	e8 79 da ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	53                   	push   %ebx
801052cb:	ff 75 c0             	pushl  -0x40(%ebp)
801052ce:	e8 3d cc ff ff       	call   80101f10 <nameiparent>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	89 c6                	mov    %eax,%esi
801052da:	0f 84 60 01 00 00    	je     80105440 <sys_unlink+0x1a0>
  ilock(dp);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	50                   	push   %eax
801052e4:	e8 a7 c3 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052e9:	58                   	pop    %eax
801052ea:	5a                   	pop    %edx
801052eb:	68 38 7b 10 80       	push   $0x80107b38
801052f0:	53                   	push   %ebx
801052f1:	e8 aa c8 ff ff       	call   80101ba0 <namecmp>
801052f6:	83 c4 10             	add    $0x10,%esp
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 03 01 00 00    	je     80105404 <sys_unlink+0x164>
80105301:	83 ec 08             	sub    $0x8,%esp
80105304:	68 37 7b 10 80       	push   $0x80107b37
80105309:	53                   	push   %ebx
8010530a:	e8 91 c8 ff ff       	call   80101ba0 <namecmp>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	0f 84 ea 00 00 00    	je     80105404 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010531a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010531d:	83 ec 04             	sub    $0x4,%esp
80105320:	50                   	push   %eax
80105321:	53                   	push   %ebx
80105322:	56                   	push   %esi
80105323:	e8 98 c8 ff ff       	call   80101bc0 <dirlookup>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c3                	mov    %eax,%ebx
8010532f:	0f 84 cf 00 00 00    	je     80105404 <sys_unlink+0x164>
  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 52 c3 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105346:	0f 8e 10 01 00 00    	jle    8010545c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010534c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105351:	74 6d                	je     801053c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105353:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105356:	83 ec 04             	sub    $0x4,%esp
80105359:	6a 10                	push   $0x10
8010535b:	6a 00                	push   $0x0
8010535d:	50                   	push   %eax
8010535e:	e8 bd f5 ff ff       	call   80104920 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105363:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105366:	6a 10                	push   $0x10
80105368:	ff 75 c4             	pushl  -0x3c(%ebp)
8010536b:	50                   	push   %eax
8010536c:	56                   	push   %esi
8010536d:	e8 fe c6 ff ff       	call   80101a70 <writei>
80105372:	83 c4 20             	add    $0x20,%esp
80105375:	83 f8 10             	cmp    $0x10,%eax
80105378:	0f 85 eb 00 00 00    	jne    80105469 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010537e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105383:	0f 84 97 00 00 00    	je     80105420 <sys_unlink+0x180>
  iunlockput(dp);
80105389:	83 ec 0c             	sub    $0xc,%esp
8010538c:	56                   	push   %esi
8010538d:	e8 8e c5 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105392:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105397:	89 1c 24             	mov    %ebx,(%esp)
8010539a:	e8 41 c2 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010539f:	89 1c 24             	mov    %ebx,(%esp)
801053a2:	e8 79 c5 ff ff       	call   80101920 <iunlockput>
  end_op();
801053a7:	e8 04 da ff ff       	call   80102db0 <end_op>
  return 0;
801053ac:	83 c4 10             	add    $0x10,%esp
801053af:	31 c0                	xor    %eax,%eax
}
801053b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b4:	5b                   	pop    %ebx
801053b5:	5e                   	pop    %esi
801053b6:	5f                   	pop    %edi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053c4:	76 8d                	jbe    80105353 <sys_unlink+0xb3>
801053c6:	bf 20 00 00 00       	mov    $0x20,%edi
801053cb:	eb 0f                	jmp    801053dc <sys_unlink+0x13c>
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
801053d0:	83 c7 10             	add    $0x10,%edi
801053d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801053d6:	0f 83 77 ff ff ff    	jae    80105353 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053df:	6a 10                	push   $0x10
801053e1:	57                   	push   %edi
801053e2:	50                   	push   %eax
801053e3:	53                   	push   %ebx
801053e4:	e8 87 c5 ff ff       	call   80101970 <readi>
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	83 f8 10             	cmp    $0x10,%eax
801053ef:	75 5e                	jne    8010544f <sys_unlink+0x1af>
    if(de.inum != 0)
801053f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053f6:	74 d8                	je     801053d0 <sys_unlink+0x130>
    iunlockput(ip);
801053f8:	83 ec 0c             	sub    $0xc,%esp
801053fb:	53                   	push   %ebx
801053fc:	e8 1f c5 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105401:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	56                   	push   %esi
80105408:	e8 13 c5 ff ff       	call   80101920 <iunlockput>
  end_op();
8010540d:	e8 9e d9 ff ff       	call   80102db0 <end_op>
  return -1;
80105412:	83 c4 10             	add    $0x10,%esp
80105415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541a:	eb 95                	jmp    801053b1 <sys_unlink+0x111>
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105420:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105425:	83 ec 0c             	sub    $0xc,%esp
80105428:	56                   	push   %esi
80105429:	e8 b2 c1 ff ff       	call   801015e0 <iupdate>
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	e9 53 ff ff ff       	jmp    80105389 <sys_unlink+0xe9>
    return -1;
80105436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543b:	e9 71 ff ff ff       	jmp    801053b1 <sys_unlink+0x111>
    end_op();
80105440:	e8 6b d9 ff ff       	call   80102db0 <end_op>
    return -1;
80105445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544a:	e9 62 ff ff ff       	jmp    801053b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	68 5c 7b 10 80       	push   $0x80107b5c
80105457:	e8 34 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	68 4a 7b 10 80       	push   $0x80107b4a
80105464:	e8 27 af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	68 6e 7b 10 80       	push   $0x80107b6e
80105471:	e8 1a af ff ff       	call   80100390 <panic>
80105476:	8d 76 00             	lea    0x0(%esi),%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105480 <sys_open>:

int
sys_open(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
80105485:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105486:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105489:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010548c:	50                   	push   %eax
8010548d:	6a 00                	push   $0x0
8010548f:	e8 3c f8 ff ff       	call   80104cd0 <argstr>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	0f 88 1d 01 00 00    	js     801055bc <sys_open+0x13c>
8010549f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054a2:	83 ec 08             	sub    $0x8,%esp
801054a5:	50                   	push   %eax
801054a6:	6a 01                	push   $0x1
801054a8:	e8 73 f7 ff ff       	call   80104c20 <argint>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	0f 88 04 01 00 00    	js     801055bc <sys_open+0x13c>
    return -1;

  begin_op();
801054b8:	e8 83 d8 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
801054bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054c1:	0f 85 a9 00 00 00    	jne    80105570 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	ff 75 e0             	pushl  -0x20(%ebp)
801054cd:	e8 1e ca ff ff       	call   80101ef0 <namei>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	89 c6                	mov    %eax,%esi
801054d9:	0f 84 b2 00 00 00    	je     80105591 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	50                   	push   %eax
801054e3:	e8 a8 c1 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054f0:	0f 84 aa 00 00 00    	je     801055a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054f6:	e8 85 b8 ff ff       	call   80100d80 <filealloc>
801054fb:	85 c0                	test   %eax,%eax
801054fd:	89 c7                	mov    %eax,%edi
801054ff:	0f 84 a6 00 00 00    	je     801055ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105505:	e8 96 e6 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010550a:	31 db                	xor    %ebx,%ebx
8010550c:	eb 0e                	jmp    8010551c <sys_open+0x9c>
8010550e:	66 90                	xchg   %ax,%ax
80105510:	83 c3 01             	add    $0x1,%ebx
80105513:	83 fb 10             	cmp    $0x10,%ebx
80105516:	0f 84 ac 00 00 00    	je     801055c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010551c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105520:	85 d2                	test   %edx,%edx
80105522:	75 ec                	jne    80105510 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105524:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105527:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010552b:	56                   	push   %esi
8010552c:	e8 3f c2 ff ff       	call   80101770 <iunlock>
  end_op();
80105531:	e8 7a d8 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105536:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010553c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105542:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105545:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010554c:	89 d0                	mov    %edx,%eax
8010554e:	f7 d0                	not    %eax
80105550:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105553:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105556:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105559:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010555d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105560:	89 d8                	mov    %ebx,%eax
80105562:	5b                   	pop    %ebx
80105563:	5e                   	pop    %esi
80105564:	5f                   	pop    %edi
80105565:	5d                   	pop    %ebp
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105576:	31 c9                	xor    %ecx,%ecx
80105578:	6a 00                	push   $0x0
8010557a:	ba 02 00 00 00       	mov    $0x2,%edx
8010557f:	e8 ec f7 ff ff       	call   80104d70 <create>
    if(ip == 0){
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105589:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010558b:	0f 85 65 ff ff ff    	jne    801054f6 <sys_open+0x76>
      end_op();
80105591:	e8 1a d8 ff ff       	call   80102db0 <end_op>
      return -1;
80105596:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010559b:	eb c0                	jmp    8010555d <sys_open+0xdd>
8010559d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055a3:	85 c9                	test   %ecx,%ecx
801055a5:	0f 84 4b ff ff ff    	je     801054f6 <sys_open+0x76>
    iunlockput(ip);
801055ab:	83 ec 0c             	sub    $0xc,%esp
801055ae:	56                   	push   %esi
801055af:	e8 6c c3 ff ff       	call   80101920 <iunlockput>
    end_op();
801055b4:	e8 f7 d7 ff ff       	call   80102db0 <end_op>
    return -1;
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055c1:	eb 9a                	jmp    8010555d <sys_open+0xdd>
801055c3:	90                   	nop
801055c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	57                   	push   %edi
801055cc:	e8 6f b8 ff ff       	call   80100e40 <fileclose>
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	eb d5                	jmp    801055ab <sys_open+0x12b>
801055d6:	8d 76 00             	lea    0x0(%esi),%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055e6:	e8 55 d7 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ee:	83 ec 08             	sub    $0x8,%esp
801055f1:	50                   	push   %eax
801055f2:	6a 00                	push   $0x0
801055f4:	e8 d7 f6 ff ff       	call   80104cd0 <argstr>
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	85 c0                	test   %eax,%eax
801055fe:	78 30                	js     80105630 <sys_mkdir+0x50>
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105606:	31 c9                	xor    %ecx,%ecx
80105608:	6a 00                	push   $0x0
8010560a:	ba 01 00 00 00       	mov    $0x1,%edx
8010560f:	e8 5c f7 ff ff       	call   80104d70 <create>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	74 15                	je     80105630 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010561b:	83 ec 0c             	sub    $0xc,%esp
8010561e:	50                   	push   %eax
8010561f:	e8 fc c2 ff ff       	call   80101920 <iunlockput>
  end_op();
80105624:	e8 87 d7 ff ff       	call   80102db0 <end_op>
  return 0;
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	31 c0                	xor    %eax,%eax
}
8010562e:	c9                   	leave  
8010562f:	c3                   	ret    
    end_op();
80105630:	e8 7b d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_mknod>:

int
sys_mknod(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105646:	e8 f5 d6 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010564b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010564e:	83 ec 08             	sub    $0x8,%esp
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 77 f6 ff ff       	call   80104cd0 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 60                	js     801056c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105660:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105663:	83 ec 08             	sub    $0x8,%esp
80105666:	50                   	push   %eax
80105667:	6a 01                	push   $0x1
80105669:	e8 b2 f5 ff ff       	call   80104c20 <argint>
  if((argstr(0, &path)) < 0 ||
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 4b                	js     801056c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105675:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105678:	83 ec 08             	sub    $0x8,%esp
8010567b:	50                   	push   %eax
8010567c:	6a 02                	push   $0x2
8010567e:	e8 9d f5 ff ff       	call   80104c20 <argint>
     argint(1, &major) < 0 ||
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	78 36                	js     801056c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010568a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010568e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105691:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105695:	ba 03 00 00 00       	mov    $0x3,%edx
8010569a:	50                   	push   %eax
8010569b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010569e:	e8 cd f6 ff ff       	call   80104d70 <create>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	74 16                	je     801056c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	50                   	push   %eax
801056ae:	e8 6d c2 ff ff       	call   80101920 <iunlockput>
  end_op();
801056b3:	e8 f8 d6 ff ff       	call   80102db0 <end_op>
  return 0;
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	31 c0                	xor    %eax,%eax
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    
801056bf:	90                   	nop
    end_op();
801056c0:	e8 eb d6 ff ff       	call   80102db0 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ca:	c9                   	leave  
801056cb:	c3                   	ret    
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_chdir>:

int
sys_chdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056d8:	e8 c3 e4 ff ff       	call   80103ba0 <myproc>
801056dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056df:	e8 5c d6 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e7:	83 ec 08             	sub    $0x8,%esp
801056ea:	50                   	push   %eax
801056eb:	6a 00                	push   $0x0
801056ed:	e8 de f5 ff ff       	call   80104cd0 <argstr>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 77                	js     80105770 <sys_chdir+0xa0>
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	ff 75 f4             	pushl  -0xc(%ebp)
801056ff:	e8 ec c7 ff ff       	call   80101ef0 <namei>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	89 c3                	mov    %eax,%ebx
8010570b:	74 63                	je     80105770 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	50                   	push   %eax
80105711:	e8 7a bf ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010571e:	75 30                	jne    80105750 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 47 c0 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105729:	58                   	pop    %eax
8010572a:	ff 76 68             	pushl  0x68(%esi)
8010572d:	e8 8e c0 ff ff       	call   801017c0 <iput>
  end_op();
80105732:	e8 79 d6 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105737:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	31 c0                	xor    %eax,%eax
}
8010573f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105742:	5b                   	pop    %ebx
80105743:	5e                   	pop    %esi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d 76 00             	lea    0x0(%esi),%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	53                   	push   %ebx
80105754:	e8 c7 c1 ff ff       	call   80101920 <iunlockput>
    end_op();
80105759:	e8 52 d6 ff ff       	call   80102db0 <end_op>
    return -1;
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105766:	eb d7                	jmp    8010573f <sys_chdir+0x6f>
80105768:	90                   	nop
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105770:	e8 3b d6 ff ff       	call   80102db0 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb c3                	jmp    8010573f <sys_chdir+0x6f>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exec>:

int
sys_exec(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
80105785:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105786:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010578c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105792:	50                   	push   %eax
80105793:	6a 00                	push   $0x0
80105795:	e8 36 f5 ff ff       	call   80104cd0 <argstr>
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	85 c0                	test   %eax,%eax
8010579f:	0f 88 87 00 00 00    	js     8010582c <sys_exec+0xac>
801057a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ab:	83 ec 08             	sub    $0x8,%esp
801057ae:	50                   	push   %eax
801057af:	6a 01                	push   $0x1
801057b1:	e8 6a f4 ff ff       	call   80104c20 <argint>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 6f                	js     8010582c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057c3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801057c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057c8:	68 80 00 00 00       	push   $0x80
801057cd:	6a 00                	push   $0x0
801057cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057d5:	50                   	push   %eax
801057d6:	e8 45 f1 ff ff       	call   80104920 <memset>
801057db:	83 c4 10             	add    $0x10,%esp
801057de:	eb 2c                	jmp    8010580c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801057e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057e6:	85 c0                	test   %eax,%eax
801057e8:	74 56                	je     80105840 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801057f6:	52                   	push   %edx
801057f7:	50                   	push   %eax
801057f8:	e8 b3 f3 ff ff       	call   80104bb0 <fetchstr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	78 28                	js     8010582c <sys_exec+0xac>
  for(i=0;; i++){
80105804:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105807:	83 fb 20             	cmp    $0x20,%ebx
8010580a:	74 20                	je     8010582c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010580c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105812:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105819:	83 ec 08             	sub    $0x8,%esp
8010581c:	57                   	push   %edi
8010581d:	01 f0                	add    %esi,%eax
8010581f:	50                   	push   %eax
80105820:	e8 4b f3 ff ff       	call   80104b70 <fetchint>
80105825:	83 c4 10             	add    $0x10,%esp
80105828:	85 c0                	test   %eax,%eax
8010582a:	79 b4                	jns    801057e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010582c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105840:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105846:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105849:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105850:	00 00 00 00 
  return exec(path, argv);
80105854:	50                   	push   %eax
80105855:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010585b:	e8 b0 b1 ff ff       	call   80100a10 <exec>
80105860:	83 c4 10             	add    $0x10,%esp
}
80105863:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105866:	5b                   	pop    %ebx
80105867:	5e                   	pop    %esi
80105868:	5f                   	pop    %edi
80105869:	5d                   	pop    %ebp
8010586a:	c3                   	ret    
8010586b:	90                   	nop
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_pipe>:

int
sys_pipe(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
80105875:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105876:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105879:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010587c:	6a 08                	push   $0x8
8010587e:	50                   	push   %eax
8010587f:	6a 00                	push   $0x0
80105881:	e8 ea f3 ff ff       	call   80104c70 <argptr>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	0f 88 ae 00 00 00    	js     8010593f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105891:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105894:	83 ec 08             	sub    $0x8,%esp
80105897:	50                   	push   %eax
80105898:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010589b:	50                   	push   %eax
8010589c:	e8 3f db ff ff       	call   801033e0 <pipealloc>
801058a1:	83 c4 10             	add    $0x10,%esp
801058a4:	85 c0                	test   %eax,%eax
801058a6:	0f 88 93 00 00 00    	js     8010593f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058af:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058b1:	e8 ea e2 ff ff       	call   80103ba0 <myproc>
801058b6:	eb 10                	jmp    801058c8 <sys_pipe+0x58>
801058b8:	90                   	nop
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058c0:	83 c3 01             	add    $0x1,%ebx
801058c3:	83 fb 10             	cmp    $0x10,%ebx
801058c6:	74 60                	je     80105928 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801058c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058cc:	85 f6                	test   %esi,%esi
801058ce:	75 f0                	jne    801058c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058d0:	8d 73 08             	lea    0x8(%ebx),%esi
801058d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058da:	e8 c1 e2 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058df:	31 d2                	xor    %edx,%edx
801058e1:	eb 0d                	jmp    801058f0 <sys_pipe+0x80>
801058e3:	90                   	nop
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058e8:	83 c2 01             	add    $0x1,%edx
801058eb:	83 fa 10             	cmp    $0x10,%edx
801058ee:	74 28                	je     80105918 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801058f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058f4:	85 c9                	test   %ecx,%ecx
801058f6:	75 f0                	jne    801058e8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801058f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801058fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105901:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105904:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105907:	31 c0                	xor    %eax,%eax
}
80105909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010590c:	5b                   	pop    %ebx
8010590d:	5e                   	pop    %esi
8010590e:	5f                   	pop    %edi
8010590f:	5d                   	pop    %ebp
80105910:	c3                   	ret    
80105911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105918:	e8 83 e2 ff ff       	call   80103ba0 <myproc>
8010591d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105924:	00 
80105925:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105928:	83 ec 0c             	sub    $0xc,%esp
8010592b:	ff 75 e0             	pushl  -0x20(%ebp)
8010592e:	e8 0d b5 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105933:	58                   	pop    %eax
80105934:	ff 75 e4             	pushl  -0x1c(%ebp)
80105937:	e8 04 b5 ff ff       	call   80100e40 <fileclose>
    return -1;
8010593c:	83 c4 10             	add    $0x10,%esp
8010593f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105944:	eb c3                	jmp    80105909 <sys_pipe+0x99>
80105946:	66 90                	xchg   %ax,%ax
80105948:	66 90                	xchg   %ax,%ax
8010594a:	66 90                	xchg   %ax,%ax
8010594c:	66 90                	xchg   %ax,%ax
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105953:	5d                   	pop    %ebp
  return fork();
80105954:	e9 07 e4 ff ff       	jmp    80103d60 <fork>
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_exit>:

int
sys_exit(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 08             	sub    $0x8,%esp
  exit();
80105966:	e8 b5 e6 ff ff       	call   80104020 <exit>
  return 0;  // not reached
}
8010596b:	31 c0                	xor    %eax,%eax
8010596d:	c9                   	leave  
8010596e:	c3                   	ret    
8010596f:	90                   	nop

80105970 <sys_wait>:

int
sys_wait(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105973:	5d                   	pop    %ebp
  return wait();
80105974:	e9 27 e9 ff ff       	jmp    801042a0 <wait>
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_kill>:

int
sys_kill(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105986:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105989:	50                   	push   %eax
8010598a:	6a 00                	push   $0x0
8010598c:	e8 8f f2 ff ff       	call   80104c20 <argint>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	78 18                	js     801059b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	ff 75 f4             	pushl  -0xc(%ebp)
8010599e:	e8 ad ea ff ff       	call   80104450 <kill>
801059a3:	83 c4 10             	add    $0x10,%esp
}
801059a6:	c9                   	leave  
801059a7:	c3                   	ret    
801059a8:	90                   	nop
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b5:	c9                   	leave  
801059b6:	c3                   	ret    
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_getpid>:

int
sys_getpid(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059c6:	e8 d5 e1 ff ff       	call   80103ba0 <myproc>
801059cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    

801059d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059da:	50                   	push   %eax
801059db:	6a 00                	push   $0x0
801059dd:	e8 3e f2 ff ff       	call   80104c20 <argint>
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	85 c0                	test   %eax,%eax
801059e7:	78 27                	js     80105a10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059e9:	e8 b2 e1 ff ff       	call   80103ba0 <myproc>
  if(growproc(n) < 0)
801059ee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059f3:	ff 75 f4             	pushl  -0xc(%ebp)
801059f6:	e8 e5 e2 ff ff       	call   80103ce0 <growproc>
801059fb:	83 c4 10             	add    $0x10,%esp
801059fe:	85 c0                	test   %eax,%eax
80105a00:	78 0e                	js     80105a10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a02:	89 d8                	mov    %ebx,%eax
80105a04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a07:	c9                   	leave  
80105a08:	c3                   	ret    
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a15:	eb eb                	jmp    80105a02 <sys_sbrk+0x32>
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a20 <sys_sleep>:

int
sys_sleep(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 ee f1 ff ff       	call   80104c20 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	0f 88 8a 00 00 00    	js     80105ac7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	68 60 2e 11 80       	push   $0x80112e60
80105a45:	e8 c6 ed ff ff       	call   80104810 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a4d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a50:	8b 1d a0 36 11 80    	mov    0x801136a0,%ebx
  while(ticks - ticks0 < n){
80105a56:	85 d2                	test   %edx,%edx
80105a58:	75 27                	jne    80105a81 <sys_sleep+0x61>
80105a5a:	eb 54                	jmp    80105ab0 <sys_sleep+0x90>
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	68 60 2e 11 80       	push   $0x80112e60
80105a68:	68 a0 36 11 80       	push   $0x801136a0
80105a6d:	e8 6e e7 ff ff       	call   801041e0 <sleep>
  while(ticks - ticks0 < n){
80105a72:	a1 a0 36 11 80       	mov    0x801136a0,%eax
80105a77:	83 c4 10             	add    $0x10,%esp
80105a7a:	29 d8                	sub    %ebx,%eax
80105a7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a7f:	73 2f                	jae    80105ab0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a81:	e8 1a e1 ff ff       	call   80103ba0 <myproc>
80105a86:	8b 40 24             	mov    0x24(%eax),%eax
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	74 d3                	je     80105a60 <sys_sleep+0x40>
      release(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 60 2e 11 80       	push   $0x80112e60
80105a95:	e8 36 ee ff ff       	call   801048d0 <release>
      return -1;
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa5:	c9                   	leave  
80105aa6:	c3                   	ret    
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	68 60 2e 11 80       	push   $0x80112e60
80105ab8:	e8 13 ee ff ff       	call   801048d0 <release>
  return 0;
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	31 c0                	xor    %eax,%eax
}
80105ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
    return -1;
80105ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acc:	eb f4                	jmp    80105ac2 <sys_sleep+0xa2>
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	53                   	push   %ebx
80105ad4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ad7:	68 60 2e 11 80       	push   $0x80112e60
80105adc:	e8 2f ed ff ff       	call   80104810 <acquire>
  xticks = ticks;
80105ae1:	8b 1d a0 36 11 80    	mov    0x801136a0,%ebx
  release(&tickslock);
80105ae7:	c7 04 24 60 2e 11 80 	movl   $0x80112e60,(%esp)
80105aee:	e8 dd ed ff ff       	call   801048d0 <release>
  return xticks;
}
80105af3:	89 d8                	mov    %ebx,%eax
80105af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af8:	c9                   	leave  
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b00 <sys_stride>:

int sys_stride(void) {
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
  int tickets;
  if (argint(0, &tickets) < 0)
80105b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_stride(void) {
80105b07:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &tickets) < 0)
80105b0a:	50                   	push   %eax
80105b0b:	6a 00                	push   $0x0
80105b0d:	e8 0e f1 ff ff       	call   80104c20 <argint>
80105b12:	83 c4 10             	add    $0x10,%esp
80105b15:	85 c0                	test   %eax,%eax
80105b17:	78 2f                	js     80105b48 <sys_stride+0x48>
    return -1;
  myproc()->stride_info.tickets = tickets;
80105b19:	e8 82 e0 ff ff       	call   80103ba0 <myproc>
80105b1e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105b21:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
  myproc()->stride_info.stride = 10000 / tickets;
80105b27:	e8 74 e0 ff ff       	call   80103ba0 <myproc>
80105b2c:	89 c1                	mov    %eax,%ecx
80105b2e:	b8 10 27 00 00       	mov    $0x2710,%eax
80105b33:	99                   	cltd   
80105b34:	f7 fb                	idiv   %ebx
80105b36:	89 81 84 00 00 00    	mov    %eax,0x84(%ecx)

  return 0;
80105b3c:	31 c0                	xor    %eax,%eax
}
80105b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b41:	c9                   	leave  
80105b42:	c3                   	ret    
80105b43:	90                   	nop
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b4d:	eb ef                	jmp    80105b3e <sys_stride+0x3e>

80105b4f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b4f:	1e                   	push   %ds
  pushl %es
80105b50:	06                   	push   %es
  pushl %fs
80105b51:	0f a0                	push   %fs
  pushl %gs
80105b53:	0f a8                	push   %gs
  pushal
80105b55:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b56:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b5a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b5c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b5e:	54                   	push   %esp
  call trap
80105b5f:	e8 cc 00 00 00       	call   80105c30 <trap>
  addl $4, %esp
80105b64:	83 c4 04             	add    $0x4,%esp

80105b67 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b67:	61                   	popa   
  popl %gs
80105b68:	0f a9                	pop    %gs
  popl %fs
80105b6a:	0f a1                	pop    %fs
  popl %es
80105b6c:	07                   	pop    %es
  popl %ds
80105b6d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b6e:	83 c4 08             	add    $0x8,%esp
  iret
80105b71:	cf                   	iret   
80105b72:	66 90                	xchg   %ax,%ax
80105b74:	66 90                	xchg   %ax,%ax
80105b76:	66 90                	xchg   %ax,%ax
80105b78:	66 90                	xchg   %ax,%ax
80105b7a:	66 90                	xchg   %ax,%ax
80105b7c:	66 90                	xchg   %ax,%ax
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b81:	31 c0                	xor    %eax,%eax
{
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	90                   	nop
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b90:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b97:	c7 04 c5 a2 2e 11 80 	movl   $0x8e000008,-0x7feed15e(,%eax,8)
80105b9e:	08 00 00 8e 
80105ba2:	66 89 14 c5 a0 2e 11 	mov    %dx,-0x7feed160(,%eax,8)
80105ba9:	80 
80105baa:	c1 ea 10             	shr    $0x10,%edx
80105bad:	66 89 14 c5 a6 2e 11 	mov    %dx,-0x7feed15a(,%eax,8)
80105bb4:	80 
  for(i = 0; i < 256; i++)
80105bb5:	83 c0 01             	add    $0x1,%eax
80105bb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bbd:	75 d1                	jne    80105b90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bbf:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105bc4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bc7:	c7 05 a2 30 11 80 08 	movl   $0xef000008,0x801130a2
80105bce:	00 00 ef 
  initlock(&tickslock, "time");
80105bd1:	68 7d 7b 10 80       	push   $0x80107b7d
80105bd6:	68 60 2e 11 80       	push   $0x80112e60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bdb:	66 a3 a0 30 11 80    	mov    %ax,0x801130a0
80105be1:	c1 e8 10             	shr    $0x10,%eax
80105be4:	66 a3 a6 30 11 80    	mov    %ax,0x801130a6
  initlock(&tickslock, "time");
80105bea:	e8 e1 ea ff ff       	call   801046d0 <initlock>
}
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c00 <idtinit>:

void
idtinit(void)
{
80105c00:	55                   	push   %ebp
  pd[0] = size-1;
80105c01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c06:	89 e5                	mov    %esp,%ebp
80105c08:	83 ec 10             	sub    $0x10,%esp
80105c0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c0f:	b8 a0 2e 11 80       	mov    $0x80112ea0,%eax
80105c14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c18:	c1 e8 10             	shr    $0x10,%eax
80105c1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	89 f6                	mov    %esi,%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	83 ec 1c             	sub    $0x1c,%esp
80105c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c3c:	8b 47 30             	mov    0x30(%edi),%eax
80105c3f:	83 f8 40             	cmp    $0x40,%eax
80105c42:	0f 84 f0 00 00 00    	je     80105d38 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c48:	83 e8 20             	sub    $0x20,%eax
80105c4b:	83 f8 1f             	cmp    $0x1f,%eax
80105c4e:	77 10                	ja     80105c60 <trap+0x30>
80105c50:	ff 24 85 24 7c 10 80 	jmp    *-0x7fef83dc(,%eax,4)
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c60:	e8 3b df ff ff       	call   80103ba0 <myproc>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c6a:	0f 84 14 02 00 00    	je     80105e84 <trap+0x254>
80105c70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c74:	0f 84 0a 02 00 00    	je     80105e84 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c7a:	0f 20 d1             	mov    %cr2,%ecx
80105c7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c80:	e8 fb de ff ff       	call   80103b80 <cpuid>
80105c85:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c88:	8b 47 34             	mov    0x34(%edi),%eax
80105c8b:	8b 77 30             	mov    0x30(%edi),%esi
80105c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c91:	e8 0a df ff ff       	call   80103ba0 <myproc>
80105c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c99:	e8 02 df ff ff       	call   80103ba0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ca1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ca4:	51                   	push   %ecx
80105ca5:	53                   	push   %ebx
80105ca6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ca7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105caa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cb1:	52                   	push   %edx
80105cb2:	ff 70 10             	pushl  0x10(%eax)
80105cb5:	68 e0 7b 10 80       	push   $0x80107be0
80105cba:	e8 a1 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cbf:	83 c4 20             	add    $0x20,%esp
80105cc2:	e8 d9 de ff ff       	call   80103ba0 <myproc>
80105cc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cce:	e8 cd de ff ff       	call   80103ba0 <myproc>
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	74 1d                	je     80105cf4 <trap+0xc4>
80105cd7:	e8 c4 de ff ff       	call   80103ba0 <myproc>
80105cdc:	8b 50 24             	mov    0x24(%eax),%edx
80105cdf:	85 d2                	test   %edx,%edx
80105ce1:	74 11                	je     80105cf4 <trap+0xc4>
80105ce3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ce7:	83 e0 03             	and    $0x3,%eax
80105cea:	66 83 f8 03          	cmp    $0x3,%ax
80105cee:	0f 84 4c 01 00 00    	je     80105e40 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cf4:	e8 a7 de ff ff       	call   80103ba0 <myproc>
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 0b                	je     80105d08 <trap+0xd8>
80105cfd:	e8 9e de ff ff       	call   80103ba0 <myproc>
80105d02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d06:	74 68                	je     80105d70 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d08:	e8 93 de ff ff       	call   80103ba0 <myproc>
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	74 19                	je     80105d2a <trap+0xfa>
80105d11:	e8 8a de ff ff       	call   80103ba0 <myproc>
80105d16:	8b 40 24             	mov    0x24(%eax),%eax
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	74 0d                	je     80105d2a <trap+0xfa>
80105d1d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d21:	83 e0 03             	and    $0x3,%eax
80105d24:	66 83 f8 03          	cmp    $0x3,%ax
80105d28:	74 37                	je     80105d61 <trap+0x131>
    exit();
}
80105d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d2d:	5b                   	pop    %ebx
80105d2e:	5e                   	pop    %esi
80105d2f:	5f                   	pop    %edi
80105d30:	5d                   	pop    %ebp
80105d31:	c3                   	ret    
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105d38:	e8 63 de ff ff       	call   80103ba0 <myproc>
80105d3d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d40:	85 db                	test   %ebx,%ebx
80105d42:	0f 85 e8 00 00 00    	jne    80105e30 <trap+0x200>
    myproc()->tf = tf;
80105d48:	e8 53 de ff ff       	call   80103ba0 <myproc>
80105d4d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d50:	e8 bb ef ff ff       	call   80104d10 <syscall>
    if(myproc()->killed)
80105d55:	e8 46 de ff ff       	call   80103ba0 <myproc>
80105d5a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d5d:	85 c9                	test   %ecx,%ecx
80105d5f:	74 c9                	je     80105d2a <trap+0xfa>
}
80105d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
      exit();
80105d68:	e9 b3 e2 ff ff       	jmp    80104020 <exit>
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d70:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d74:	75 92                	jne    80105d08 <trap+0xd8>
    yield();
80105d76:	e8 15 e4 ff ff       	call   80104190 <yield>
80105d7b:	eb 8b                	jmp    80105d08 <trap+0xd8>
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105d80:	e8 fb dd ff ff       	call   80103b80 <cpuid>
80105d85:	85 c0                	test   %eax,%eax
80105d87:	0f 84 c3 00 00 00    	je     80105e50 <trap+0x220>
    lapiceoi();
80105d8d:	e8 5e cb ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d92:	e8 09 de ff ff       	call   80103ba0 <myproc>
80105d97:	85 c0                	test   %eax,%eax
80105d99:	0f 85 38 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105d9f:	e9 50 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105da8:	e8 03 ca ff ff       	call   801027b0 <kbdintr>
    lapiceoi();
80105dad:	e8 3e cb ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db2:	e8 e9 dd ff ff       	call   80103ba0 <myproc>
80105db7:	85 c0                	test   %eax,%eax
80105db9:	0f 85 18 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105dbf:	e9 30 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105dc8:	e8 53 02 00 00       	call   80106020 <uartintr>
    lapiceoi();
80105dcd:	e8 1e cb ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 c9 dd ff ff       	call   80103ba0 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 f8 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105ddf:	e9 10 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105de8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105dec:	8b 77 38             	mov    0x38(%edi),%esi
80105def:	e8 8c dd ff ff       	call   80103b80 <cpuid>
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
80105df6:	50                   	push   %eax
80105df7:	68 88 7b 10 80       	push   $0x80107b88
80105dfc:	e8 5f a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105e01:	e8 ea ca ff ff       	call   801028f0 <lapiceoi>
    break;
80105e06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e09:	e8 92 dd ff ff       	call   80103ba0 <myproc>
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	0f 85 c1 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105e16:	e9 d9 fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e1b:	90                   	nop
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e20:	e8 6b c2 ff ff       	call   80102090 <ideintr>
80105e25:	e9 63 ff ff ff       	jmp    80105d8d <trap+0x15d>
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e30:	e8 eb e1 ff ff       	call   80104020 <exit>
80105e35:	e9 0e ff ff ff       	jmp    80105d48 <trap+0x118>
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e40:	e8 db e1 ff ff       	call   80104020 <exit>
80105e45:	e9 aa fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 60 2e 11 80       	push   $0x80112e60
80105e58:	e8 b3 e9 ff ff       	call   80104810 <acquire>
      wakeup(&ticks);
80105e5d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
      ticks++;
80105e64:	83 05 a0 36 11 80 01 	addl   $0x1,0x801136a0
      wakeup(&ticks);
80105e6b:	e8 60 e5 ff ff       	call   801043d0 <wakeup>
      release(&tickslock);
80105e70:	c7 04 24 60 2e 11 80 	movl   $0x80112e60,(%esp)
80105e77:	e8 54 ea ff ff       	call   801048d0 <release>
80105e7c:	83 c4 10             	add    $0x10,%esp
80105e7f:	e9 09 ff ff ff       	jmp    80105d8d <trap+0x15d>
80105e84:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e87:	e8 f4 dc ff ff       	call   80103b80 <cpuid>
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	56                   	push   %esi
80105e90:	53                   	push   %ebx
80105e91:	50                   	push   %eax
80105e92:	ff 77 30             	pushl  0x30(%edi)
80105e95:	68 ac 7b 10 80       	push   $0x80107bac
80105e9a:	e8 c1 a7 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105e9f:	83 c4 14             	add    $0x14,%esp
80105ea2:	68 82 7b 10 80       	push   $0x80107b82
80105ea7:	e8 e4 a4 ff ff       	call   80100390 <panic>
80105eac:	66 90                	xchg   %ax,%ax
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105eb0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105eb5:	55                   	push   %ebp
80105eb6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	74 1c                	je     80105ed8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ebc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ec1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ec2:	a8 01                	test   $0x1,%al
80105ec4:	74 12                	je     80105ed8 <uartgetc+0x28>
80105ec6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ecc:	0f b6 c0             	movzbl %al,%eax
}
80105ecf:	5d                   	pop    %ebp
80105ed0:	c3                   	ret    
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105edd:	5d                   	pop    %ebp
80105ede:	c3                   	ret    
80105edf:	90                   	nop

80105ee0 <uartputc.part.0>:
uartputc(int c)
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
80105ee5:	53                   	push   %ebx
80105ee6:	89 c7                	mov    %eax,%edi
80105ee8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105eed:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ef2:	83 ec 0c             	sub    $0xc,%esp
80105ef5:	eb 1b                	jmp    80105f12 <uartputc.part.0+0x32>
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	6a 0a                	push   $0xa
80105f05:	e8 06 ca ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	83 eb 01             	sub    $0x1,%ebx
80105f10:	74 07                	je     80105f19 <uartputc.part.0+0x39>
80105f12:	89 f2                	mov    %esi,%edx
80105f14:	ec                   	in     (%dx),%al
80105f15:	a8 20                	test   $0x20,%al
80105f17:	74 e7                	je     80105f00 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1e:	89 f8                	mov    %edi,%eax
80105f20:	ee                   	out    %al,(%dx)
}
80105f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f24:	5b                   	pop    %ebx
80105f25:	5e                   	pop    %esi
80105f26:	5f                   	pop    %edi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <uartinit>:
{
80105f30:	55                   	push   %ebp
80105f31:	31 c9                	xor    %ecx,%ecx
80105f33:	89 c8                	mov    %ecx,%eax
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	57                   	push   %edi
80105f38:	56                   	push   %esi
80105f39:	53                   	push   %ebx
80105f3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f3f:	89 da                	mov    %ebx,%edx
80105f41:	83 ec 0c             	sub    $0xc,%esp
80105f44:	ee                   	out    %al,(%dx)
80105f45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f4f:	89 fa                	mov    %edi,%edx
80105f51:	ee                   	out    %al,(%dx)
80105f52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5c:	ee                   	out    %al,(%dx)
80105f5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f62:	89 c8                	mov    %ecx,%eax
80105f64:	89 f2                	mov    %esi,%edx
80105f66:	ee                   	out    %al,(%dx)
80105f67:	b8 03 00 00 00       	mov    $0x3,%eax
80105f6c:	89 fa                	mov    %edi,%edx
80105f6e:	ee                   	out    %al,(%dx)
80105f6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f74:	89 c8                	mov    %ecx,%eax
80105f76:	ee                   	out    %al,(%dx)
80105f77:	b8 01 00 00 00       	mov    $0x1,%eax
80105f7c:	89 f2                	mov    %esi,%edx
80105f7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f85:	3c ff                	cmp    $0xff,%al
80105f87:	74 5a                	je     80105fe3 <uartinit+0xb3>
  uart = 1;
80105f89:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105f90:	00 00 00 
80105f93:	89 da                	mov    %ebx,%edx
80105f95:	ec                   	in     (%dx),%al
80105f96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f9c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f9f:	bb a4 7c 10 80       	mov    $0x80107ca4,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fa4:	6a 00                	push   $0x0
80105fa6:	6a 04                	push   $0x4
80105fa8:	e8 33 c3 ff ff       	call   801022e0 <ioapicenable>
80105fad:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fb0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fb5:	eb 13                	jmp    80105fca <uartinit+0x9a>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fc0:	83 c3 01             	add    $0x1,%ebx
80105fc3:	0f be 03             	movsbl (%ebx),%eax
80105fc6:	84 c0                	test   %al,%al
80105fc8:	74 19                	je     80105fe3 <uartinit+0xb3>
  if(!uart)
80105fca:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105fd0:	85 d2                	test   %edx,%edx
80105fd2:	74 ec                	je     80105fc0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105fd4:	83 c3 01             	add    $0x1,%ebx
80105fd7:	e8 04 ff ff ff       	call   80105ee0 <uartputc.part.0>
80105fdc:	0f be 03             	movsbl (%ebx),%eax
80105fdf:	84 c0                	test   %al,%al
80105fe1:	75 e7                	jne    80105fca <uartinit+0x9a>
}
80105fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe6:	5b                   	pop    %ebx
80105fe7:	5e                   	pop    %esi
80105fe8:	5f                   	pop    %edi
80105fe9:	5d                   	pop    %ebp
80105fea:	c3                   	ret    
80105feb:	90                   	nop
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <uartputc>:
  if(!uart)
80105ff0:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80105ff6:	55                   	push   %ebp
80105ff7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ff9:	85 d2                	test   %edx,%edx
{
80105ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ffe:	74 10                	je     80106010 <uartputc+0x20>
}
80106000:	5d                   	pop    %ebp
80106001:	e9 da fe ff ff       	jmp    80105ee0 <uartputc.part.0>
80106006:	8d 76 00             	lea    0x0(%esi),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106010:	5d                   	pop    %ebp
80106011:	c3                   	ret    
80106012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106020 <uartintr>:

void
uartintr(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106026:	68 b0 5e 10 80       	push   $0x80105eb0
8010602b:	e8 e0 a7 ff ff       	call   80100810 <consoleintr>
}
80106030:	83 c4 10             	add    $0x10,%esp
80106033:	c9                   	leave  
80106034:	c3                   	ret    

80106035 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $0
80106037:	6a 00                	push   $0x0
  jmp alltraps
80106039:	e9 11 fb ff ff       	jmp    80105b4f <alltraps>

8010603e <vector1>:
.globl vector1
vector1:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $1
80106040:	6a 01                	push   $0x1
  jmp alltraps
80106042:	e9 08 fb ff ff       	jmp    80105b4f <alltraps>

80106047 <vector2>:
.globl vector2
vector2:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $2
80106049:	6a 02                	push   $0x2
  jmp alltraps
8010604b:	e9 ff fa ff ff       	jmp    80105b4f <alltraps>

80106050 <vector3>:
.globl vector3
vector3:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $3
80106052:	6a 03                	push   $0x3
  jmp alltraps
80106054:	e9 f6 fa ff ff       	jmp    80105b4f <alltraps>

80106059 <vector4>:
.globl vector4
vector4:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $4
8010605b:	6a 04                	push   $0x4
  jmp alltraps
8010605d:	e9 ed fa ff ff       	jmp    80105b4f <alltraps>

80106062 <vector5>:
.globl vector5
vector5:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $5
80106064:	6a 05                	push   $0x5
  jmp alltraps
80106066:	e9 e4 fa ff ff       	jmp    80105b4f <alltraps>

8010606b <vector6>:
.globl vector6
vector6:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $6
8010606d:	6a 06                	push   $0x6
  jmp alltraps
8010606f:	e9 db fa ff ff       	jmp    80105b4f <alltraps>

80106074 <vector7>:
.globl vector7
vector7:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $7
80106076:	6a 07                	push   $0x7
  jmp alltraps
80106078:	e9 d2 fa ff ff       	jmp    80105b4f <alltraps>

8010607d <vector8>:
.globl vector8
vector8:
  pushl $8
8010607d:	6a 08                	push   $0x8
  jmp alltraps
8010607f:	e9 cb fa ff ff       	jmp    80105b4f <alltraps>

80106084 <vector9>:
.globl vector9
vector9:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $9
80106086:	6a 09                	push   $0x9
  jmp alltraps
80106088:	e9 c2 fa ff ff       	jmp    80105b4f <alltraps>

8010608d <vector10>:
.globl vector10
vector10:
  pushl $10
8010608d:	6a 0a                	push   $0xa
  jmp alltraps
8010608f:	e9 bb fa ff ff       	jmp    80105b4f <alltraps>

80106094 <vector11>:
.globl vector11
vector11:
  pushl $11
80106094:	6a 0b                	push   $0xb
  jmp alltraps
80106096:	e9 b4 fa ff ff       	jmp    80105b4f <alltraps>

8010609b <vector12>:
.globl vector12
vector12:
  pushl $12
8010609b:	6a 0c                	push   $0xc
  jmp alltraps
8010609d:	e9 ad fa ff ff       	jmp    80105b4f <alltraps>

801060a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060a2:	6a 0d                	push   $0xd
  jmp alltraps
801060a4:	e9 a6 fa ff ff       	jmp    80105b4f <alltraps>

801060a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060a9:	6a 0e                	push   $0xe
  jmp alltraps
801060ab:	e9 9f fa ff ff       	jmp    80105b4f <alltraps>

801060b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $15
801060b2:	6a 0f                	push   $0xf
  jmp alltraps
801060b4:	e9 96 fa ff ff       	jmp    80105b4f <alltraps>

801060b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $16
801060bb:	6a 10                	push   $0x10
  jmp alltraps
801060bd:	e9 8d fa ff ff       	jmp    80105b4f <alltraps>

801060c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060c2:	6a 11                	push   $0x11
  jmp alltraps
801060c4:	e9 86 fa ff ff       	jmp    80105b4f <alltraps>

801060c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $18
801060cb:	6a 12                	push   $0x12
  jmp alltraps
801060cd:	e9 7d fa ff ff       	jmp    80105b4f <alltraps>

801060d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $19
801060d4:	6a 13                	push   $0x13
  jmp alltraps
801060d6:	e9 74 fa ff ff       	jmp    80105b4f <alltraps>

801060db <vector20>:
.globl vector20
vector20:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $20
801060dd:	6a 14                	push   $0x14
  jmp alltraps
801060df:	e9 6b fa ff ff       	jmp    80105b4f <alltraps>

801060e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $21
801060e6:	6a 15                	push   $0x15
  jmp alltraps
801060e8:	e9 62 fa ff ff       	jmp    80105b4f <alltraps>

801060ed <vector22>:
.globl vector22
vector22:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $22
801060ef:	6a 16                	push   $0x16
  jmp alltraps
801060f1:	e9 59 fa ff ff       	jmp    80105b4f <alltraps>

801060f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $23
801060f8:	6a 17                	push   $0x17
  jmp alltraps
801060fa:	e9 50 fa ff ff       	jmp    80105b4f <alltraps>

801060ff <vector24>:
.globl vector24
vector24:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $24
80106101:	6a 18                	push   $0x18
  jmp alltraps
80106103:	e9 47 fa ff ff       	jmp    80105b4f <alltraps>

80106108 <vector25>:
.globl vector25
vector25:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $25
8010610a:	6a 19                	push   $0x19
  jmp alltraps
8010610c:	e9 3e fa ff ff       	jmp    80105b4f <alltraps>

80106111 <vector26>:
.globl vector26
vector26:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $26
80106113:	6a 1a                	push   $0x1a
  jmp alltraps
80106115:	e9 35 fa ff ff       	jmp    80105b4f <alltraps>

8010611a <vector27>:
.globl vector27
vector27:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $27
8010611c:	6a 1b                	push   $0x1b
  jmp alltraps
8010611e:	e9 2c fa ff ff       	jmp    80105b4f <alltraps>

80106123 <vector28>:
.globl vector28
vector28:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $28
80106125:	6a 1c                	push   $0x1c
  jmp alltraps
80106127:	e9 23 fa ff ff       	jmp    80105b4f <alltraps>

8010612c <vector29>:
.globl vector29
vector29:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $29
8010612e:	6a 1d                	push   $0x1d
  jmp alltraps
80106130:	e9 1a fa ff ff       	jmp    80105b4f <alltraps>

80106135 <vector30>:
.globl vector30
vector30:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $30
80106137:	6a 1e                	push   $0x1e
  jmp alltraps
80106139:	e9 11 fa ff ff       	jmp    80105b4f <alltraps>

8010613e <vector31>:
.globl vector31
vector31:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $31
80106140:	6a 1f                	push   $0x1f
  jmp alltraps
80106142:	e9 08 fa ff ff       	jmp    80105b4f <alltraps>

80106147 <vector32>:
.globl vector32
vector32:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $32
80106149:	6a 20                	push   $0x20
  jmp alltraps
8010614b:	e9 ff f9 ff ff       	jmp    80105b4f <alltraps>

80106150 <vector33>:
.globl vector33
vector33:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $33
80106152:	6a 21                	push   $0x21
  jmp alltraps
80106154:	e9 f6 f9 ff ff       	jmp    80105b4f <alltraps>

80106159 <vector34>:
.globl vector34
vector34:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $34
8010615b:	6a 22                	push   $0x22
  jmp alltraps
8010615d:	e9 ed f9 ff ff       	jmp    80105b4f <alltraps>

80106162 <vector35>:
.globl vector35
vector35:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $35
80106164:	6a 23                	push   $0x23
  jmp alltraps
80106166:	e9 e4 f9 ff ff       	jmp    80105b4f <alltraps>

8010616b <vector36>:
.globl vector36
vector36:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $36
8010616d:	6a 24                	push   $0x24
  jmp alltraps
8010616f:	e9 db f9 ff ff       	jmp    80105b4f <alltraps>

80106174 <vector37>:
.globl vector37
vector37:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $37
80106176:	6a 25                	push   $0x25
  jmp alltraps
80106178:	e9 d2 f9 ff ff       	jmp    80105b4f <alltraps>

8010617d <vector38>:
.globl vector38
vector38:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $38
8010617f:	6a 26                	push   $0x26
  jmp alltraps
80106181:	e9 c9 f9 ff ff       	jmp    80105b4f <alltraps>

80106186 <vector39>:
.globl vector39
vector39:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $39
80106188:	6a 27                	push   $0x27
  jmp alltraps
8010618a:	e9 c0 f9 ff ff       	jmp    80105b4f <alltraps>

8010618f <vector40>:
.globl vector40
vector40:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $40
80106191:	6a 28                	push   $0x28
  jmp alltraps
80106193:	e9 b7 f9 ff ff       	jmp    80105b4f <alltraps>

80106198 <vector41>:
.globl vector41
vector41:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $41
8010619a:	6a 29                	push   $0x29
  jmp alltraps
8010619c:	e9 ae f9 ff ff       	jmp    80105b4f <alltraps>

801061a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $42
801061a3:	6a 2a                	push   $0x2a
  jmp alltraps
801061a5:	e9 a5 f9 ff ff       	jmp    80105b4f <alltraps>

801061aa <vector43>:
.globl vector43
vector43:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $43
801061ac:	6a 2b                	push   $0x2b
  jmp alltraps
801061ae:	e9 9c f9 ff ff       	jmp    80105b4f <alltraps>

801061b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $44
801061b5:	6a 2c                	push   $0x2c
  jmp alltraps
801061b7:	e9 93 f9 ff ff       	jmp    80105b4f <alltraps>

801061bc <vector45>:
.globl vector45
vector45:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $45
801061be:	6a 2d                	push   $0x2d
  jmp alltraps
801061c0:	e9 8a f9 ff ff       	jmp    80105b4f <alltraps>

801061c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $46
801061c7:	6a 2e                	push   $0x2e
  jmp alltraps
801061c9:	e9 81 f9 ff ff       	jmp    80105b4f <alltraps>

801061ce <vector47>:
.globl vector47
vector47:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $47
801061d0:	6a 2f                	push   $0x2f
  jmp alltraps
801061d2:	e9 78 f9 ff ff       	jmp    80105b4f <alltraps>

801061d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $48
801061d9:	6a 30                	push   $0x30
  jmp alltraps
801061db:	e9 6f f9 ff ff       	jmp    80105b4f <alltraps>

801061e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $49
801061e2:	6a 31                	push   $0x31
  jmp alltraps
801061e4:	e9 66 f9 ff ff       	jmp    80105b4f <alltraps>

801061e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $50
801061eb:	6a 32                	push   $0x32
  jmp alltraps
801061ed:	e9 5d f9 ff ff       	jmp    80105b4f <alltraps>

801061f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $51
801061f4:	6a 33                	push   $0x33
  jmp alltraps
801061f6:	e9 54 f9 ff ff       	jmp    80105b4f <alltraps>

801061fb <vector52>:
.globl vector52
vector52:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $52
801061fd:	6a 34                	push   $0x34
  jmp alltraps
801061ff:	e9 4b f9 ff ff       	jmp    80105b4f <alltraps>

80106204 <vector53>:
.globl vector53
vector53:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $53
80106206:	6a 35                	push   $0x35
  jmp alltraps
80106208:	e9 42 f9 ff ff       	jmp    80105b4f <alltraps>

8010620d <vector54>:
.globl vector54
vector54:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $54
8010620f:	6a 36                	push   $0x36
  jmp alltraps
80106211:	e9 39 f9 ff ff       	jmp    80105b4f <alltraps>

80106216 <vector55>:
.globl vector55
vector55:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $55
80106218:	6a 37                	push   $0x37
  jmp alltraps
8010621a:	e9 30 f9 ff ff       	jmp    80105b4f <alltraps>

8010621f <vector56>:
.globl vector56
vector56:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $56
80106221:	6a 38                	push   $0x38
  jmp alltraps
80106223:	e9 27 f9 ff ff       	jmp    80105b4f <alltraps>

80106228 <vector57>:
.globl vector57
vector57:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $57
8010622a:	6a 39                	push   $0x39
  jmp alltraps
8010622c:	e9 1e f9 ff ff       	jmp    80105b4f <alltraps>

80106231 <vector58>:
.globl vector58
vector58:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $58
80106233:	6a 3a                	push   $0x3a
  jmp alltraps
80106235:	e9 15 f9 ff ff       	jmp    80105b4f <alltraps>

8010623a <vector59>:
.globl vector59
vector59:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $59
8010623c:	6a 3b                	push   $0x3b
  jmp alltraps
8010623e:	e9 0c f9 ff ff       	jmp    80105b4f <alltraps>

80106243 <vector60>:
.globl vector60
vector60:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $60
80106245:	6a 3c                	push   $0x3c
  jmp alltraps
80106247:	e9 03 f9 ff ff       	jmp    80105b4f <alltraps>

8010624c <vector61>:
.globl vector61
vector61:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $61
8010624e:	6a 3d                	push   $0x3d
  jmp alltraps
80106250:	e9 fa f8 ff ff       	jmp    80105b4f <alltraps>

80106255 <vector62>:
.globl vector62
vector62:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $62
80106257:	6a 3e                	push   $0x3e
  jmp alltraps
80106259:	e9 f1 f8 ff ff       	jmp    80105b4f <alltraps>

8010625e <vector63>:
.globl vector63
vector63:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $63
80106260:	6a 3f                	push   $0x3f
  jmp alltraps
80106262:	e9 e8 f8 ff ff       	jmp    80105b4f <alltraps>

80106267 <vector64>:
.globl vector64
vector64:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $64
80106269:	6a 40                	push   $0x40
  jmp alltraps
8010626b:	e9 df f8 ff ff       	jmp    80105b4f <alltraps>

80106270 <vector65>:
.globl vector65
vector65:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $65
80106272:	6a 41                	push   $0x41
  jmp alltraps
80106274:	e9 d6 f8 ff ff       	jmp    80105b4f <alltraps>

80106279 <vector66>:
.globl vector66
vector66:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $66
8010627b:	6a 42                	push   $0x42
  jmp alltraps
8010627d:	e9 cd f8 ff ff       	jmp    80105b4f <alltraps>

80106282 <vector67>:
.globl vector67
vector67:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $67
80106284:	6a 43                	push   $0x43
  jmp alltraps
80106286:	e9 c4 f8 ff ff       	jmp    80105b4f <alltraps>

8010628b <vector68>:
.globl vector68
vector68:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $68
8010628d:	6a 44                	push   $0x44
  jmp alltraps
8010628f:	e9 bb f8 ff ff       	jmp    80105b4f <alltraps>

80106294 <vector69>:
.globl vector69
vector69:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $69
80106296:	6a 45                	push   $0x45
  jmp alltraps
80106298:	e9 b2 f8 ff ff       	jmp    80105b4f <alltraps>

8010629d <vector70>:
.globl vector70
vector70:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $70
8010629f:	6a 46                	push   $0x46
  jmp alltraps
801062a1:	e9 a9 f8 ff ff       	jmp    80105b4f <alltraps>

801062a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $71
801062a8:	6a 47                	push   $0x47
  jmp alltraps
801062aa:	e9 a0 f8 ff ff       	jmp    80105b4f <alltraps>

801062af <vector72>:
.globl vector72
vector72:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $72
801062b1:	6a 48                	push   $0x48
  jmp alltraps
801062b3:	e9 97 f8 ff ff       	jmp    80105b4f <alltraps>

801062b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $73
801062ba:	6a 49                	push   $0x49
  jmp alltraps
801062bc:	e9 8e f8 ff ff       	jmp    80105b4f <alltraps>

801062c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $74
801062c3:	6a 4a                	push   $0x4a
  jmp alltraps
801062c5:	e9 85 f8 ff ff       	jmp    80105b4f <alltraps>

801062ca <vector75>:
.globl vector75
vector75:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $75
801062cc:	6a 4b                	push   $0x4b
  jmp alltraps
801062ce:	e9 7c f8 ff ff       	jmp    80105b4f <alltraps>

801062d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $76
801062d5:	6a 4c                	push   $0x4c
  jmp alltraps
801062d7:	e9 73 f8 ff ff       	jmp    80105b4f <alltraps>

801062dc <vector77>:
.globl vector77
vector77:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $77
801062de:	6a 4d                	push   $0x4d
  jmp alltraps
801062e0:	e9 6a f8 ff ff       	jmp    80105b4f <alltraps>

801062e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $78
801062e7:	6a 4e                	push   $0x4e
  jmp alltraps
801062e9:	e9 61 f8 ff ff       	jmp    80105b4f <alltraps>

801062ee <vector79>:
.globl vector79
vector79:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $79
801062f0:	6a 4f                	push   $0x4f
  jmp alltraps
801062f2:	e9 58 f8 ff ff       	jmp    80105b4f <alltraps>

801062f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $80
801062f9:	6a 50                	push   $0x50
  jmp alltraps
801062fb:	e9 4f f8 ff ff       	jmp    80105b4f <alltraps>

80106300 <vector81>:
.globl vector81
vector81:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $81
80106302:	6a 51                	push   $0x51
  jmp alltraps
80106304:	e9 46 f8 ff ff       	jmp    80105b4f <alltraps>

80106309 <vector82>:
.globl vector82
vector82:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $82
8010630b:	6a 52                	push   $0x52
  jmp alltraps
8010630d:	e9 3d f8 ff ff       	jmp    80105b4f <alltraps>

80106312 <vector83>:
.globl vector83
vector83:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $83
80106314:	6a 53                	push   $0x53
  jmp alltraps
80106316:	e9 34 f8 ff ff       	jmp    80105b4f <alltraps>

8010631b <vector84>:
.globl vector84
vector84:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $84
8010631d:	6a 54                	push   $0x54
  jmp alltraps
8010631f:	e9 2b f8 ff ff       	jmp    80105b4f <alltraps>

80106324 <vector85>:
.globl vector85
vector85:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $85
80106326:	6a 55                	push   $0x55
  jmp alltraps
80106328:	e9 22 f8 ff ff       	jmp    80105b4f <alltraps>

8010632d <vector86>:
.globl vector86
vector86:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $86
8010632f:	6a 56                	push   $0x56
  jmp alltraps
80106331:	e9 19 f8 ff ff       	jmp    80105b4f <alltraps>

80106336 <vector87>:
.globl vector87
vector87:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $87
80106338:	6a 57                	push   $0x57
  jmp alltraps
8010633a:	e9 10 f8 ff ff       	jmp    80105b4f <alltraps>

8010633f <vector88>:
.globl vector88
vector88:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $88
80106341:	6a 58                	push   $0x58
  jmp alltraps
80106343:	e9 07 f8 ff ff       	jmp    80105b4f <alltraps>

80106348 <vector89>:
.globl vector89
vector89:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $89
8010634a:	6a 59                	push   $0x59
  jmp alltraps
8010634c:	e9 fe f7 ff ff       	jmp    80105b4f <alltraps>

80106351 <vector90>:
.globl vector90
vector90:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $90
80106353:	6a 5a                	push   $0x5a
  jmp alltraps
80106355:	e9 f5 f7 ff ff       	jmp    80105b4f <alltraps>

8010635a <vector91>:
.globl vector91
vector91:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $91
8010635c:	6a 5b                	push   $0x5b
  jmp alltraps
8010635e:	e9 ec f7 ff ff       	jmp    80105b4f <alltraps>

80106363 <vector92>:
.globl vector92
vector92:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $92
80106365:	6a 5c                	push   $0x5c
  jmp alltraps
80106367:	e9 e3 f7 ff ff       	jmp    80105b4f <alltraps>

8010636c <vector93>:
.globl vector93
vector93:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $93
8010636e:	6a 5d                	push   $0x5d
  jmp alltraps
80106370:	e9 da f7 ff ff       	jmp    80105b4f <alltraps>

80106375 <vector94>:
.globl vector94
vector94:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $94
80106377:	6a 5e                	push   $0x5e
  jmp alltraps
80106379:	e9 d1 f7 ff ff       	jmp    80105b4f <alltraps>

8010637e <vector95>:
.globl vector95
vector95:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $95
80106380:	6a 5f                	push   $0x5f
  jmp alltraps
80106382:	e9 c8 f7 ff ff       	jmp    80105b4f <alltraps>

80106387 <vector96>:
.globl vector96
vector96:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $96
80106389:	6a 60                	push   $0x60
  jmp alltraps
8010638b:	e9 bf f7 ff ff       	jmp    80105b4f <alltraps>

80106390 <vector97>:
.globl vector97
vector97:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $97
80106392:	6a 61                	push   $0x61
  jmp alltraps
80106394:	e9 b6 f7 ff ff       	jmp    80105b4f <alltraps>

80106399 <vector98>:
.globl vector98
vector98:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $98
8010639b:	6a 62                	push   $0x62
  jmp alltraps
8010639d:	e9 ad f7 ff ff       	jmp    80105b4f <alltraps>

801063a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $99
801063a4:	6a 63                	push   $0x63
  jmp alltraps
801063a6:	e9 a4 f7 ff ff       	jmp    80105b4f <alltraps>

801063ab <vector100>:
.globl vector100
vector100:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $100
801063ad:	6a 64                	push   $0x64
  jmp alltraps
801063af:	e9 9b f7 ff ff       	jmp    80105b4f <alltraps>

801063b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $101
801063b6:	6a 65                	push   $0x65
  jmp alltraps
801063b8:	e9 92 f7 ff ff       	jmp    80105b4f <alltraps>

801063bd <vector102>:
.globl vector102
vector102:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $102
801063bf:	6a 66                	push   $0x66
  jmp alltraps
801063c1:	e9 89 f7 ff ff       	jmp    80105b4f <alltraps>

801063c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $103
801063c8:	6a 67                	push   $0x67
  jmp alltraps
801063ca:	e9 80 f7 ff ff       	jmp    80105b4f <alltraps>

801063cf <vector104>:
.globl vector104
vector104:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $104
801063d1:	6a 68                	push   $0x68
  jmp alltraps
801063d3:	e9 77 f7 ff ff       	jmp    80105b4f <alltraps>

801063d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $105
801063da:	6a 69                	push   $0x69
  jmp alltraps
801063dc:	e9 6e f7 ff ff       	jmp    80105b4f <alltraps>

801063e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $106
801063e3:	6a 6a                	push   $0x6a
  jmp alltraps
801063e5:	e9 65 f7 ff ff       	jmp    80105b4f <alltraps>

801063ea <vector107>:
.globl vector107
vector107:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $107
801063ec:	6a 6b                	push   $0x6b
  jmp alltraps
801063ee:	e9 5c f7 ff ff       	jmp    80105b4f <alltraps>

801063f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $108
801063f5:	6a 6c                	push   $0x6c
  jmp alltraps
801063f7:	e9 53 f7 ff ff       	jmp    80105b4f <alltraps>

801063fc <vector109>:
.globl vector109
vector109:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $109
801063fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106400:	e9 4a f7 ff ff       	jmp    80105b4f <alltraps>

80106405 <vector110>:
.globl vector110
vector110:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $110
80106407:	6a 6e                	push   $0x6e
  jmp alltraps
80106409:	e9 41 f7 ff ff       	jmp    80105b4f <alltraps>

8010640e <vector111>:
.globl vector111
vector111:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $111
80106410:	6a 6f                	push   $0x6f
  jmp alltraps
80106412:	e9 38 f7 ff ff       	jmp    80105b4f <alltraps>

80106417 <vector112>:
.globl vector112
vector112:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $112
80106419:	6a 70                	push   $0x70
  jmp alltraps
8010641b:	e9 2f f7 ff ff       	jmp    80105b4f <alltraps>

80106420 <vector113>:
.globl vector113
vector113:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $113
80106422:	6a 71                	push   $0x71
  jmp alltraps
80106424:	e9 26 f7 ff ff       	jmp    80105b4f <alltraps>

80106429 <vector114>:
.globl vector114
vector114:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $114
8010642b:	6a 72                	push   $0x72
  jmp alltraps
8010642d:	e9 1d f7 ff ff       	jmp    80105b4f <alltraps>

80106432 <vector115>:
.globl vector115
vector115:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $115
80106434:	6a 73                	push   $0x73
  jmp alltraps
80106436:	e9 14 f7 ff ff       	jmp    80105b4f <alltraps>

8010643b <vector116>:
.globl vector116
vector116:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $116
8010643d:	6a 74                	push   $0x74
  jmp alltraps
8010643f:	e9 0b f7 ff ff       	jmp    80105b4f <alltraps>

80106444 <vector117>:
.globl vector117
vector117:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $117
80106446:	6a 75                	push   $0x75
  jmp alltraps
80106448:	e9 02 f7 ff ff       	jmp    80105b4f <alltraps>

8010644d <vector118>:
.globl vector118
vector118:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $118
8010644f:	6a 76                	push   $0x76
  jmp alltraps
80106451:	e9 f9 f6 ff ff       	jmp    80105b4f <alltraps>

80106456 <vector119>:
.globl vector119
vector119:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $119
80106458:	6a 77                	push   $0x77
  jmp alltraps
8010645a:	e9 f0 f6 ff ff       	jmp    80105b4f <alltraps>

8010645f <vector120>:
.globl vector120
vector120:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $120
80106461:	6a 78                	push   $0x78
  jmp alltraps
80106463:	e9 e7 f6 ff ff       	jmp    80105b4f <alltraps>

80106468 <vector121>:
.globl vector121
vector121:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $121
8010646a:	6a 79                	push   $0x79
  jmp alltraps
8010646c:	e9 de f6 ff ff       	jmp    80105b4f <alltraps>

80106471 <vector122>:
.globl vector122
vector122:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $122
80106473:	6a 7a                	push   $0x7a
  jmp alltraps
80106475:	e9 d5 f6 ff ff       	jmp    80105b4f <alltraps>

8010647a <vector123>:
.globl vector123
vector123:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $123
8010647c:	6a 7b                	push   $0x7b
  jmp alltraps
8010647e:	e9 cc f6 ff ff       	jmp    80105b4f <alltraps>

80106483 <vector124>:
.globl vector124
vector124:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $124
80106485:	6a 7c                	push   $0x7c
  jmp alltraps
80106487:	e9 c3 f6 ff ff       	jmp    80105b4f <alltraps>

8010648c <vector125>:
.globl vector125
vector125:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $125
8010648e:	6a 7d                	push   $0x7d
  jmp alltraps
80106490:	e9 ba f6 ff ff       	jmp    80105b4f <alltraps>

80106495 <vector126>:
.globl vector126
vector126:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $126
80106497:	6a 7e                	push   $0x7e
  jmp alltraps
80106499:	e9 b1 f6 ff ff       	jmp    80105b4f <alltraps>

8010649e <vector127>:
.globl vector127
vector127:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $127
801064a0:	6a 7f                	push   $0x7f
  jmp alltraps
801064a2:	e9 a8 f6 ff ff       	jmp    80105b4f <alltraps>

801064a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $128
801064a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ae:	e9 9c f6 ff ff       	jmp    80105b4f <alltraps>

801064b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $129
801064b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ba:	e9 90 f6 ff ff       	jmp    80105b4f <alltraps>

801064bf <vector130>:
.globl vector130
vector130:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $130
801064c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064c6:	e9 84 f6 ff ff       	jmp    80105b4f <alltraps>

801064cb <vector131>:
.globl vector131
vector131:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $131
801064cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064d2:	e9 78 f6 ff ff       	jmp    80105b4f <alltraps>

801064d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $132
801064d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064de:	e9 6c f6 ff ff       	jmp    80105b4f <alltraps>

801064e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $133
801064e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064ea:	e9 60 f6 ff ff       	jmp    80105b4f <alltraps>

801064ef <vector134>:
.globl vector134
vector134:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $134
801064f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064f6:	e9 54 f6 ff ff       	jmp    80105b4f <alltraps>

801064fb <vector135>:
.globl vector135
vector135:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $135
801064fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106502:	e9 48 f6 ff ff       	jmp    80105b4f <alltraps>

80106507 <vector136>:
.globl vector136
vector136:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $136
80106509:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010650e:	e9 3c f6 ff ff       	jmp    80105b4f <alltraps>

80106513 <vector137>:
.globl vector137
vector137:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $137
80106515:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010651a:	e9 30 f6 ff ff       	jmp    80105b4f <alltraps>

8010651f <vector138>:
.globl vector138
vector138:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $138
80106521:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106526:	e9 24 f6 ff ff       	jmp    80105b4f <alltraps>

8010652b <vector139>:
.globl vector139
vector139:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $139
8010652d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106532:	e9 18 f6 ff ff       	jmp    80105b4f <alltraps>

80106537 <vector140>:
.globl vector140
vector140:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $140
80106539:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010653e:	e9 0c f6 ff ff       	jmp    80105b4f <alltraps>

80106543 <vector141>:
.globl vector141
vector141:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $141
80106545:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010654a:	e9 00 f6 ff ff       	jmp    80105b4f <alltraps>

8010654f <vector142>:
.globl vector142
vector142:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $142
80106551:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106556:	e9 f4 f5 ff ff       	jmp    80105b4f <alltraps>

8010655b <vector143>:
.globl vector143
vector143:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $143
8010655d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106562:	e9 e8 f5 ff ff       	jmp    80105b4f <alltraps>

80106567 <vector144>:
.globl vector144
vector144:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $144
80106569:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010656e:	e9 dc f5 ff ff       	jmp    80105b4f <alltraps>

80106573 <vector145>:
.globl vector145
vector145:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $145
80106575:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010657a:	e9 d0 f5 ff ff       	jmp    80105b4f <alltraps>

8010657f <vector146>:
.globl vector146
vector146:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $146
80106581:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106586:	e9 c4 f5 ff ff       	jmp    80105b4f <alltraps>

8010658b <vector147>:
.globl vector147
vector147:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $147
8010658d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106592:	e9 b8 f5 ff ff       	jmp    80105b4f <alltraps>

80106597 <vector148>:
.globl vector148
vector148:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $148
80106599:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010659e:	e9 ac f5 ff ff       	jmp    80105b4f <alltraps>

801065a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $149
801065a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065aa:	e9 a0 f5 ff ff       	jmp    80105b4f <alltraps>

801065af <vector150>:
.globl vector150
vector150:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $150
801065b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065b6:	e9 94 f5 ff ff       	jmp    80105b4f <alltraps>

801065bb <vector151>:
.globl vector151
vector151:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $151
801065bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065c2:	e9 88 f5 ff ff       	jmp    80105b4f <alltraps>

801065c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $152
801065c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ce:	e9 7c f5 ff ff       	jmp    80105b4f <alltraps>

801065d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $153
801065d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065da:	e9 70 f5 ff ff       	jmp    80105b4f <alltraps>

801065df <vector154>:
.globl vector154
vector154:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $154
801065e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065e6:	e9 64 f5 ff ff       	jmp    80105b4f <alltraps>

801065eb <vector155>:
.globl vector155
vector155:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $155
801065ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065f2:	e9 58 f5 ff ff       	jmp    80105b4f <alltraps>

801065f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $156
801065f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065fe:	e9 4c f5 ff ff       	jmp    80105b4f <alltraps>

80106603 <vector157>:
.globl vector157
vector157:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $157
80106605:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010660a:	e9 40 f5 ff ff       	jmp    80105b4f <alltraps>

8010660f <vector158>:
.globl vector158
vector158:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $158
80106611:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106616:	e9 34 f5 ff ff       	jmp    80105b4f <alltraps>

8010661b <vector159>:
.globl vector159
vector159:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $159
8010661d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106622:	e9 28 f5 ff ff       	jmp    80105b4f <alltraps>

80106627 <vector160>:
.globl vector160
vector160:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $160
80106629:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010662e:	e9 1c f5 ff ff       	jmp    80105b4f <alltraps>

80106633 <vector161>:
.globl vector161
vector161:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $161
80106635:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010663a:	e9 10 f5 ff ff       	jmp    80105b4f <alltraps>

8010663f <vector162>:
.globl vector162
vector162:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $162
80106641:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106646:	e9 04 f5 ff ff       	jmp    80105b4f <alltraps>

8010664b <vector163>:
.globl vector163
vector163:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $163
8010664d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106652:	e9 f8 f4 ff ff       	jmp    80105b4f <alltraps>

80106657 <vector164>:
.globl vector164
vector164:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $164
80106659:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010665e:	e9 ec f4 ff ff       	jmp    80105b4f <alltraps>

80106663 <vector165>:
.globl vector165
vector165:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $165
80106665:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010666a:	e9 e0 f4 ff ff       	jmp    80105b4f <alltraps>

8010666f <vector166>:
.globl vector166
vector166:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $166
80106671:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106676:	e9 d4 f4 ff ff       	jmp    80105b4f <alltraps>

8010667b <vector167>:
.globl vector167
vector167:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $167
8010667d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106682:	e9 c8 f4 ff ff       	jmp    80105b4f <alltraps>

80106687 <vector168>:
.globl vector168
vector168:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $168
80106689:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010668e:	e9 bc f4 ff ff       	jmp    80105b4f <alltraps>

80106693 <vector169>:
.globl vector169
vector169:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $169
80106695:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010669a:	e9 b0 f4 ff ff       	jmp    80105b4f <alltraps>

8010669f <vector170>:
.globl vector170
vector170:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $170
801066a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066a6:	e9 a4 f4 ff ff       	jmp    80105b4f <alltraps>

801066ab <vector171>:
.globl vector171
vector171:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $171
801066ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066b2:	e9 98 f4 ff ff       	jmp    80105b4f <alltraps>

801066b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $172
801066b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066be:	e9 8c f4 ff ff       	jmp    80105b4f <alltraps>

801066c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $173
801066c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ca:	e9 80 f4 ff ff       	jmp    80105b4f <alltraps>

801066cf <vector174>:
.globl vector174
vector174:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $174
801066d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066d6:	e9 74 f4 ff ff       	jmp    80105b4f <alltraps>

801066db <vector175>:
.globl vector175
vector175:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $175
801066dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066e2:	e9 68 f4 ff ff       	jmp    80105b4f <alltraps>

801066e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $176
801066e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ee:	e9 5c f4 ff ff       	jmp    80105b4f <alltraps>

801066f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $177
801066f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066fa:	e9 50 f4 ff ff       	jmp    80105b4f <alltraps>

801066ff <vector178>:
.globl vector178
vector178:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $178
80106701:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106706:	e9 44 f4 ff ff       	jmp    80105b4f <alltraps>

8010670b <vector179>:
.globl vector179
vector179:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $179
8010670d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106712:	e9 38 f4 ff ff       	jmp    80105b4f <alltraps>

80106717 <vector180>:
.globl vector180
vector180:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $180
80106719:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010671e:	e9 2c f4 ff ff       	jmp    80105b4f <alltraps>

80106723 <vector181>:
.globl vector181
vector181:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $181
80106725:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010672a:	e9 20 f4 ff ff       	jmp    80105b4f <alltraps>

8010672f <vector182>:
.globl vector182
vector182:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $182
80106731:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106736:	e9 14 f4 ff ff       	jmp    80105b4f <alltraps>

8010673b <vector183>:
.globl vector183
vector183:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $183
8010673d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106742:	e9 08 f4 ff ff       	jmp    80105b4f <alltraps>

80106747 <vector184>:
.globl vector184
vector184:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $184
80106749:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010674e:	e9 fc f3 ff ff       	jmp    80105b4f <alltraps>

80106753 <vector185>:
.globl vector185
vector185:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $185
80106755:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010675a:	e9 f0 f3 ff ff       	jmp    80105b4f <alltraps>

8010675f <vector186>:
.globl vector186
vector186:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $186
80106761:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106766:	e9 e4 f3 ff ff       	jmp    80105b4f <alltraps>

8010676b <vector187>:
.globl vector187
vector187:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $187
8010676d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106772:	e9 d8 f3 ff ff       	jmp    80105b4f <alltraps>

80106777 <vector188>:
.globl vector188
vector188:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $188
80106779:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010677e:	e9 cc f3 ff ff       	jmp    80105b4f <alltraps>

80106783 <vector189>:
.globl vector189
vector189:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $189
80106785:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010678a:	e9 c0 f3 ff ff       	jmp    80105b4f <alltraps>

8010678f <vector190>:
.globl vector190
vector190:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $190
80106791:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106796:	e9 b4 f3 ff ff       	jmp    80105b4f <alltraps>

8010679b <vector191>:
.globl vector191
vector191:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $191
8010679d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067a2:	e9 a8 f3 ff ff       	jmp    80105b4f <alltraps>

801067a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $192
801067a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ae:	e9 9c f3 ff ff       	jmp    80105b4f <alltraps>

801067b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $193
801067b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ba:	e9 90 f3 ff ff       	jmp    80105b4f <alltraps>

801067bf <vector194>:
.globl vector194
vector194:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $194
801067c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067c6:	e9 84 f3 ff ff       	jmp    80105b4f <alltraps>

801067cb <vector195>:
.globl vector195
vector195:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $195
801067cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067d2:	e9 78 f3 ff ff       	jmp    80105b4f <alltraps>

801067d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $196
801067d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067de:	e9 6c f3 ff ff       	jmp    80105b4f <alltraps>

801067e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $197
801067e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067ea:	e9 60 f3 ff ff       	jmp    80105b4f <alltraps>

801067ef <vector198>:
.globl vector198
vector198:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $198
801067f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067f6:	e9 54 f3 ff ff       	jmp    80105b4f <alltraps>

801067fb <vector199>:
.globl vector199
vector199:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $199
801067fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106802:	e9 48 f3 ff ff       	jmp    80105b4f <alltraps>

80106807 <vector200>:
.globl vector200
vector200:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $200
80106809:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010680e:	e9 3c f3 ff ff       	jmp    80105b4f <alltraps>

80106813 <vector201>:
.globl vector201
vector201:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $201
80106815:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010681a:	e9 30 f3 ff ff       	jmp    80105b4f <alltraps>

8010681f <vector202>:
.globl vector202
vector202:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $202
80106821:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106826:	e9 24 f3 ff ff       	jmp    80105b4f <alltraps>

8010682b <vector203>:
.globl vector203
vector203:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $203
8010682d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106832:	e9 18 f3 ff ff       	jmp    80105b4f <alltraps>

80106837 <vector204>:
.globl vector204
vector204:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $204
80106839:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010683e:	e9 0c f3 ff ff       	jmp    80105b4f <alltraps>

80106843 <vector205>:
.globl vector205
vector205:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $205
80106845:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010684a:	e9 00 f3 ff ff       	jmp    80105b4f <alltraps>

8010684f <vector206>:
.globl vector206
vector206:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $206
80106851:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106856:	e9 f4 f2 ff ff       	jmp    80105b4f <alltraps>

8010685b <vector207>:
.globl vector207
vector207:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $207
8010685d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106862:	e9 e8 f2 ff ff       	jmp    80105b4f <alltraps>

80106867 <vector208>:
.globl vector208
vector208:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $208
80106869:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010686e:	e9 dc f2 ff ff       	jmp    80105b4f <alltraps>

80106873 <vector209>:
.globl vector209
vector209:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $209
80106875:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010687a:	e9 d0 f2 ff ff       	jmp    80105b4f <alltraps>

8010687f <vector210>:
.globl vector210
vector210:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $210
80106881:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106886:	e9 c4 f2 ff ff       	jmp    80105b4f <alltraps>

8010688b <vector211>:
.globl vector211
vector211:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $211
8010688d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106892:	e9 b8 f2 ff ff       	jmp    80105b4f <alltraps>

80106897 <vector212>:
.globl vector212
vector212:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $212
80106899:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010689e:	e9 ac f2 ff ff       	jmp    80105b4f <alltraps>

801068a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $213
801068a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068aa:	e9 a0 f2 ff ff       	jmp    80105b4f <alltraps>

801068af <vector214>:
.globl vector214
vector214:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $214
801068b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068b6:	e9 94 f2 ff ff       	jmp    80105b4f <alltraps>

801068bb <vector215>:
.globl vector215
vector215:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $215
801068bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068c2:	e9 88 f2 ff ff       	jmp    80105b4f <alltraps>

801068c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $216
801068c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ce:	e9 7c f2 ff ff       	jmp    80105b4f <alltraps>

801068d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $217
801068d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068da:	e9 70 f2 ff ff       	jmp    80105b4f <alltraps>

801068df <vector218>:
.globl vector218
vector218:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $218
801068e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068e6:	e9 64 f2 ff ff       	jmp    80105b4f <alltraps>

801068eb <vector219>:
.globl vector219
vector219:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $219
801068ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068f2:	e9 58 f2 ff ff       	jmp    80105b4f <alltraps>

801068f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $220
801068f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068fe:	e9 4c f2 ff ff       	jmp    80105b4f <alltraps>

80106903 <vector221>:
.globl vector221
vector221:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $221
80106905:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010690a:	e9 40 f2 ff ff       	jmp    80105b4f <alltraps>

8010690f <vector222>:
.globl vector222
vector222:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $222
80106911:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106916:	e9 34 f2 ff ff       	jmp    80105b4f <alltraps>

8010691b <vector223>:
.globl vector223
vector223:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $223
8010691d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106922:	e9 28 f2 ff ff       	jmp    80105b4f <alltraps>

80106927 <vector224>:
.globl vector224
vector224:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $224
80106929:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010692e:	e9 1c f2 ff ff       	jmp    80105b4f <alltraps>

80106933 <vector225>:
.globl vector225
vector225:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $225
80106935:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010693a:	e9 10 f2 ff ff       	jmp    80105b4f <alltraps>

8010693f <vector226>:
.globl vector226
vector226:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $226
80106941:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106946:	e9 04 f2 ff ff       	jmp    80105b4f <alltraps>

8010694b <vector227>:
.globl vector227
vector227:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $227
8010694d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106952:	e9 f8 f1 ff ff       	jmp    80105b4f <alltraps>

80106957 <vector228>:
.globl vector228
vector228:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $228
80106959:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010695e:	e9 ec f1 ff ff       	jmp    80105b4f <alltraps>

80106963 <vector229>:
.globl vector229
vector229:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $229
80106965:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010696a:	e9 e0 f1 ff ff       	jmp    80105b4f <alltraps>

8010696f <vector230>:
.globl vector230
vector230:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $230
80106971:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106976:	e9 d4 f1 ff ff       	jmp    80105b4f <alltraps>

8010697b <vector231>:
.globl vector231
vector231:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $231
8010697d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106982:	e9 c8 f1 ff ff       	jmp    80105b4f <alltraps>

80106987 <vector232>:
.globl vector232
vector232:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $232
80106989:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010698e:	e9 bc f1 ff ff       	jmp    80105b4f <alltraps>

80106993 <vector233>:
.globl vector233
vector233:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $233
80106995:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010699a:	e9 b0 f1 ff ff       	jmp    80105b4f <alltraps>

8010699f <vector234>:
.globl vector234
vector234:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $234
801069a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069a6:	e9 a4 f1 ff ff       	jmp    80105b4f <alltraps>

801069ab <vector235>:
.globl vector235
vector235:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $235
801069ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069b2:	e9 98 f1 ff ff       	jmp    80105b4f <alltraps>

801069b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $236
801069b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069be:	e9 8c f1 ff ff       	jmp    80105b4f <alltraps>

801069c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $237
801069c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ca:	e9 80 f1 ff ff       	jmp    80105b4f <alltraps>

801069cf <vector238>:
.globl vector238
vector238:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $238
801069d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069d6:	e9 74 f1 ff ff       	jmp    80105b4f <alltraps>

801069db <vector239>:
.globl vector239
vector239:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $239
801069dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069e2:	e9 68 f1 ff ff       	jmp    80105b4f <alltraps>

801069e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $240
801069e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ee:	e9 5c f1 ff ff       	jmp    80105b4f <alltraps>

801069f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $241
801069f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069fa:	e9 50 f1 ff ff       	jmp    80105b4f <alltraps>

801069ff <vector242>:
.globl vector242
vector242:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $242
80106a01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a06:	e9 44 f1 ff ff       	jmp    80105b4f <alltraps>

80106a0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $243
80106a0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a12:	e9 38 f1 ff ff       	jmp    80105b4f <alltraps>

80106a17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $244
80106a19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a1e:	e9 2c f1 ff ff       	jmp    80105b4f <alltraps>

80106a23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $245
80106a25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a2a:	e9 20 f1 ff ff       	jmp    80105b4f <alltraps>

80106a2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $246
80106a31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a36:	e9 14 f1 ff ff       	jmp    80105b4f <alltraps>

80106a3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $247
80106a3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a42:	e9 08 f1 ff ff       	jmp    80105b4f <alltraps>

80106a47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $248
80106a49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a4e:	e9 fc f0 ff ff       	jmp    80105b4f <alltraps>

80106a53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $249
80106a55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a5a:	e9 f0 f0 ff ff       	jmp    80105b4f <alltraps>

80106a5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $250
80106a61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a66:	e9 e4 f0 ff ff       	jmp    80105b4f <alltraps>

80106a6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $251
80106a6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a72:	e9 d8 f0 ff ff       	jmp    80105b4f <alltraps>

80106a77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $252
80106a79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a7e:	e9 cc f0 ff ff       	jmp    80105b4f <alltraps>

80106a83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $253
80106a85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a8a:	e9 c0 f0 ff ff       	jmp    80105b4f <alltraps>

80106a8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $254
80106a91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a96:	e9 b4 f0 ff ff       	jmp    80105b4f <alltraps>

80106a9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $255
80106a9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106aa2:	e9 a8 f0 ff ff       	jmp    80105b4f <alltraps>
80106aa7:	66 90                	xchg   %ax,%ax
80106aa9:	66 90                	xchg   %ax,%ax
80106aab:	66 90                	xchg   %ax,%ax
80106aad:	66 90                	xchg   %ax,%ax
80106aaf:	90                   	nop

80106ab0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ab6:	89 d3                	mov    %edx,%ebx
{
80106ab8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106aba:	c1 eb 16             	shr    $0x16,%ebx
80106abd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ac0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ac3:	8b 06                	mov    (%esi),%eax
80106ac5:	a8 01                	test   $0x1,%al
80106ac7:	74 27                	je     80106af0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ace:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ad4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ada:	89 fa                	mov    %edi,%edx
80106adc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ae2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106af0:	85 c9                	test   %ecx,%ecx
80106af2:	74 2c                	je     80106b20 <walkpgdir+0x70>
80106af4:	e8 d7 b9 ff ff       	call   801024d0 <kalloc>
80106af9:	85 c0                	test   %eax,%eax
80106afb:	89 c3                	mov    %eax,%ebx
80106afd:	74 21                	je     80106b20 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106aff:	83 ec 04             	sub    $0x4,%esp
80106b02:	68 00 10 00 00       	push   $0x1000
80106b07:	6a 00                	push   $0x0
80106b09:	50                   	push   %eax
80106b0a:	e8 11 de ff ff       	call   80104920 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b15:	83 c4 10             	add    $0x10,%esp
80106b18:	83 c8 07             	or     $0x7,%eax
80106b1b:	89 06                	mov    %eax,(%esi)
80106b1d:	eb b5                	jmp    80106ad4 <walkpgdir+0x24>
80106b1f:	90                   	nop
}
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b36:	89 d3                	mov    %edx,%ebx
80106b38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b3e:	83 ec 1c             	sub    $0x1c,%esp
80106b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b48:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b50:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b53:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b56:	29 df                	sub    %ebx,%edi
80106b58:	83 c8 01             	or     $0x1,%eax
80106b5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b5e:	eb 15                	jmp    80106b75 <mappages+0x45>
    if(*pte & PTE_P)
80106b60:	f6 00 01             	testb  $0x1,(%eax)
80106b63:	75 45                	jne    80106baa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b65:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b68:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b6b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b6d:	74 31                	je     80106ba0 <mappages+0x70>
      break;
    a += PGSIZE;
80106b6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b78:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b7d:	89 da                	mov    %ebx,%edx
80106b7f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b82:	e8 29 ff ff ff       	call   80106ab0 <walkpgdir>
80106b87:	85 c0                	test   %eax,%eax
80106b89:	75 d5                	jne    80106b60 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b93:	5b                   	pop    %ebx
80106b94:	5e                   	pop    %esi
80106b95:	5f                   	pop    %edi
80106b96:	5d                   	pop    %ebp
80106b97:	c3                   	ret    
80106b98:	90                   	nop
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ba3:	31 c0                	xor    %eax,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
      panic("remap");
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	68 ac 7c 10 80       	push   $0x80107cac
80106bb2:	e8 d9 97 ff ff       	call   80100390 <panic>
80106bb7:	89 f6                	mov    %esi,%esi
80106bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bcc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106bce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd4:	83 ec 1c             	sub    $0x1c,%esp
80106bd7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bda:	39 d3                	cmp    %edx,%ebx
80106bdc:	73 66                	jae    80106c44 <deallocuvm.part.0+0x84>
80106bde:	89 d6                	mov    %edx,%esi
80106be0:	eb 3d                	jmp    80106c1f <deallocuvm.part.0+0x5f>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106be8:	8b 10                	mov    (%eax),%edx
80106bea:	f6 c2 01             	test   $0x1,%dl
80106bed:	74 26                	je     80106c15 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106bef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106bf5:	74 58                	je     80106c4f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106bf7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bfa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c03:	52                   	push   %edx
80106c04:	e8 17 b7 ff ff       	call   80102320 <kfree>
      *pte = 0;
80106c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c0c:	83 c4 10             	add    $0x10,%esp
80106c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c15:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c1b:	39 f3                	cmp    %esi,%ebx
80106c1d:	73 25                	jae    80106c44 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c1f:	31 c9                	xor    %ecx,%ecx
80106c21:	89 da                	mov    %ebx,%edx
80106c23:	89 f8                	mov    %edi,%eax
80106c25:	e8 86 fe ff ff       	call   80106ab0 <walkpgdir>
    if(!pte)
80106c2a:	85 c0                	test   %eax,%eax
80106c2c:	75 ba                	jne    80106be8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c2e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c34:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c40:	39 f3                	cmp    %esi,%ebx
80106c42:	72 db                	jb     80106c1f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c4a:	5b                   	pop    %ebx
80106c4b:	5e                   	pop    %esi
80106c4c:	5f                   	pop    %edi
80106c4d:	5d                   	pop    %ebp
80106c4e:	c3                   	ret    
        panic("kfree");
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 46 76 10 80       	push   $0x80107646
80106c57:	e8 34 97 ff ff       	call   80100390 <panic>
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c60 <seginit>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c66:	e8 15 cf ff ff       	call   80103b80 <cpuid>
80106c6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c71:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c7a:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106c81:	ff 00 00 
80106c84:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106c8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c8e:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106c95:	ff 00 00 
80106c98:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106c9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ca2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106ca9:	ff 00 00 
80106cac:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106cb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cb6:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106cbd:	ff 00 00 
80106cc0:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106cc7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cca:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
80106ccf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cd3:	c1 e8 10             	shr    $0x10,%eax
80106cd6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cdd:	0f 01 10             	lgdtl  (%eax)
}
80106ce0:	c9                   	leave  
80106ce1:	c3                   	ret    
80106ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cf0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
{
80106cf5:	55                   	push   %ebp
80106cf6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cf8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cfd:	0f 22 d8             	mov    %eax,%cr3
}
80106d00:	5d                   	pop    %ebp
80106d01:	c3                   	ret    
80106d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <switchuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d1c:	85 db                	test   %ebx,%ebx
80106d1e:	0f 84 cb 00 00 00    	je     80106def <switchuvm+0xdf>
  if(p->kstack == 0)
80106d24:	8b 43 08             	mov    0x8(%ebx),%eax
80106d27:	85 c0                	test   %eax,%eax
80106d29:	0f 84 da 00 00 00    	je     80106e09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d2f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d32:	85 c0                	test   %eax,%eax
80106d34:	0f 84 c2 00 00 00    	je     80106dfc <switchuvm+0xec>
  pushcli();
80106d3a:	e8 01 da ff ff       	call   80104740 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d3f:	e8 bc cd ff ff       	call   80103b00 <mycpu>
80106d44:	89 c6                	mov    %eax,%esi
80106d46:	e8 b5 cd ff ff       	call   80103b00 <mycpu>
80106d4b:	89 c7                	mov    %eax,%edi
80106d4d:	e8 ae cd ff ff       	call   80103b00 <mycpu>
80106d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d55:	83 c7 08             	add    $0x8,%edi
80106d58:	e8 a3 cd ff ff       	call   80103b00 <mycpu>
80106d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d60:	83 c0 08             	add    $0x8,%eax
80106d63:	ba 67 00 00 00       	mov    $0x67,%edx
80106d68:	c1 e8 18             	shr    $0x18,%eax
80106d6b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d72:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d79:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d7f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d84:	83 c1 08             	add    $0x8,%ecx
80106d87:	c1 e9 10             	shr    $0x10,%ecx
80106d8a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d95:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d9c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106da1:	e8 5a cd ff ff       	call   80103b00 <mycpu>
80106da6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dad:	e8 4e cd ff ff       	call   80103b00 <mycpu>
80106db2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106db6:	8b 73 08             	mov    0x8(%ebx),%esi
80106db9:	e8 42 cd ff ff       	call   80103b00 <mycpu>
80106dbe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dc4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dc7:	e8 34 cd ff ff       	call   80103b00 <mycpu>
80106dcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106dd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106dd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106dd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ddb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106de0:	0f 22 d8             	mov    %eax,%cr3
}
80106de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de6:	5b                   	pop    %ebx
80106de7:	5e                   	pop    %esi
80106de8:	5f                   	pop    %edi
80106de9:	5d                   	pop    %ebp
  popcli();
80106dea:	e9 91 d9 ff ff       	jmp    80104780 <popcli>
    panic("switchuvm: no process");
80106def:	83 ec 0c             	sub    $0xc,%esp
80106df2:	68 b2 7c 10 80       	push   $0x80107cb2
80106df7:	e8 94 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 dd 7c 10 80       	push   $0x80107cdd
80106e04:	e8 87 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e09:	83 ec 0c             	sub    $0xc,%esp
80106e0c:	68 c8 7c 10 80       	push   $0x80107cc8
80106e11:	e8 7a 95 ff ff       	call   80100390 <panic>
80106e16:	8d 76 00             	lea    0x0(%esi),%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <inituvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 75 10             	mov    0x10(%ebp),%esi
80106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e3b:	77 49                	ja     80106e86 <inituvm+0x66>
  mem = kalloc();
80106e3d:	e8 8e b6 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e42:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e45:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e47:	68 00 10 00 00       	push   $0x1000
80106e4c:	6a 00                	push   $0x0
80106e4e:	50                   	push   %eax
80106e4f:	e8 cc da ff ff       	call   80104920 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e54:	58                   	pop    %eax
80106e55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e5b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e60:	5a                   	pop    %edx
80106e61:	6a 06                	push   $0x6
80106e63:	50                   	push   %eax
80106e64:	31 d2                	xor    %edx,%edx
80106e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e69:	e8 c2 fc ff ff       	call   80106b30 <mappages>
  memmove(mem, init, sz);
80106e6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e71:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e74:	83 c4 10             	add    $0x10,%esp
80106e77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7d:	5b                   	pop    %ebx
80106e7e:	5e                   	pop    %esi
80106e7f:	5f                   	pop    %edi
80106e80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e81:	e9 4a db ff ff       	jmp    801049d0 <memmove>
    panic("inituvm: more than a page");
80106e86:	83 ec 0c             	sub    $0xc,%esp
80106e89:	68 f1 7c 10 80       	push   $0x80107cf1
80106e8e:	e8 fd 94 ff ff       	call   80100390 <panic>
80106e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ea0 <loaduvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106ea9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106eb0:	0f 85 91 00 00 00    	jne    80106f47 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106eb6:	8b 75 18             	mov    0x18(%ebp),%esi
80106eb9:	31 db                	xor    %ebx,%ebx
80106ebb:	85 f6                	test   %esi,%esi
80106ebd:	75 1a                	jne    80106ed9 <loaduvm+0x39>
80106ebf:	eb 6f                	jmp    80106f30 <loaduvm+0x90>
80106ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ece:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ed4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ed7:	76 57                	jbe    80106f30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106edc:	8b 45 08             	mov    0x8(%ebp),%eax
80106edf:	31 c9                	xor    %ecx,%ecx
80106ee1:	01 da                	add    %ebx,%edx
80106ee3:	e8 c8 fb ff ff       	call   80106ab0 <walkpgdir>
80106ee8:	85 c0                	test   %eax,%eax
80106eea:	74 4e                	je     80106f3a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106eec:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ef1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ef6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106efb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f01:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f04:	01 d9                	add    %ebx,%ecx
80106f06:	05 00 00 00 80       	add    $0x80000000,%eax
80106f0b:	57                   	push   %edi
80106f0c:	51                   	push   %ecx
80106f0d:	50                   	push   %eax
80106f0e:	ff 75 10             	pushl  0x10(%ebp)
80106f11:	e8 5a aa ff ff       	call   80101970 <readi>
80106f16:	83 c4 10             	add    $0x10,%esp
80106f19:	39 f8                	cmp    %edi,%eax
80106f1b:	74 ab                	je     80106ec8 <loaduvm+0x28>
}
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f25:	5b                   	pop    %ebx
80106f26:	5e                   	pop    %esi
80106f27:	5f                   	pop    %edi
80106f28:	5d                   	pop    %ebp
80106f29:	c3                   	ret    
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f33:	31 c0                	xor    %eax,%eax
}
80106f35:	5b                   	pop    %ebx
80106f36:	5e                   	pop    %esi
80106f37:	5f                   	pop    %edi
80106f38:	5d                   	pop    %ebp
80106f39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 0b 7d 10 80       	push   $0x80107d0b
80106f42:	e8 49 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f47:	83 ec 0c             	sub    $0xc,%esp
80106f4a:	68 ac 7d 10 80       	push   $0x80107dac
80106f4f:	e8 3c 94 ff ff       	call   80100390 <panic>
80106f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f60 <allocuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f6c:	85 ff                	test   %edi,%edi
80106f6e:	0f 88 8e 00 00 00    	js     80107002 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f77:	0f 82 93 00 00 00    	jb     80107010 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f8f:	0f 86 7e 00 00 00    	jbe    80107013 <allocuvm+0xb3>
80106f95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f9b:	eb 42                	jmp    80106fdf <allocuvm+0x7f>
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	68 00 10 00 00       	push   $0x1000
80106fa8:	6a 00                	push   $0x0
80106faa:	50                   	push   %eax
80106fab:	e8 70 d9 ff ff       	call   80104920 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fb0:	58                   	pop    %eax
80106fb1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fb7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fbc:	5a                   	pop    %edx
80106fbd:	6a 06                	push   $0x6
80106fbf:	50                   	push   %eax
80106fc0:	89 da                	mov    %ebx,%edx
80106fc2:	89 f8                	mov    %edi,%eax
80106fc4:	e8 67 fb ff ff       	call   80106b30 <mappages>
80106fc9:	83 c4 10             	add    $0x10,%esp
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	78 50                	js     80107020 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106fd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fd9:	0f 86 81 00 00 00    	jbe    80107060 <allocuvm+0x100>
    mem = kalloc();
80106fdf:	e8 ec b4 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106fe4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106fe6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106fe8:	75 b6                	jne    80106fa0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fea:	83 ec 0c             	sub    $0xc,%esp
80106fed:	68 29 7d 10 80       	push   $0x80107d29
80106ff2:	e8 69 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106ff7:	83 c4 10             	add    $0x10,%esp
80106ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ffd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107000:	77 6e                	ja     80107070 <allocuvm+0x110>
}
80107002:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107005:	31 ff                	xor    %edi,%edi
}
80107007:	89 f8                	mov    %edi,%eax
80107009:	5b                   	pop    %ebx
8010700a:	5e                   	pop    %esi
8010700b:	5f                   	pop    %edi
8010700c:	5d                   	pop    %ebp
8010700d:	c3                   	ret    
8010700e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107010:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107016:	89 f8                	mov    %edi,%eax
80107018:	5b                   	pop    %ebx
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret    
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107020:	83 ec 0c             	sub    $0xc,%esp
80107023:	68 41 7d 10 80       	push   $0x80107d41
80107028:	e8 33 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010702d:	83 c4 10             	add    $0x10,%esp
80107030:	8b 45 0c             	mov    0xc(%ebp),%eax
80107033:	39 45 10             	cmp    %eax,0x10(%ebp)
80107036:	76 0d                	jbe    80107045 <allocuvm+0xe5>
80107038:	89 c1                	mov    %eax,%ecx
8010703a:	8b 55 10             	mov    0x10(%ebp),%edx
8010703d:	8b 45 08             	mov    0x8(%ebp),%eax
80107040:	e8 7b fb ff ff       	call   80106bc0 <deallocuvm.part.0>
      kfree(mem);
80107045:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107048:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010704a:	56                   	push   %esi
8010704b:	e8 d0 b2 ff ff       	call   80102320 <kfree>
      return 0;
80107050:	83 c4 10             	add    $0x10,%esp
}
80107053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107056:	89 f8                	mov    %edi,%eax
80107058:	5b                   	pop    %ebx
80107059:	5e                   	pop    %esi
8010705a:	5f                   	pop    %edi
8010705b:	5d                   	pop    %ebp
8010705c:	c3                   	ret    
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
80107060:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107066:	5b                   	pop    %ebx
80107067:	89 f8                	mov    %edi,%eax
80107069:	5e                   	pop    %esi
8010706a:	5f                   	pop    %edi
8010706b:	5d                   	pop    %ebp
8010706c:	c3                   	ret    
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
80107070:	89 c1                	mov    %eax,%ecx
80107072:	8b 55 10             	mov    0x10(%ebp),%edx
80107075:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107078:	31 ff                	xor    %edi,%edi
8010707a:	e8 41 fb ff ff       	call   80106bc0 <deallocuvm.part.0>
8010707f:	eb 92                	jmp    80107013 <allocuvm+0xb3>
80107081:	eb 0d                	jmp    80107090 <deallocuvm>
80107083:	90                   	nop
80107084:	90                   	nop
80107085:	90                   	nop
80107086:	90                   	nop
80107087:	90                   	nop
80107088:	90                   	nop
80107089:	90                   	nop
8010708a:	90                   	nop
8010708b:	90                   	nop
8010708c:	90                   	nop
8010708d:	90                   	nop
8010708e:	90                   	nop
8010708f:	90                   	nop

80107090 <deallocuvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	8b 55 0c             	mov    0xc(%ebp),%edx
80107096:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107099:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010709c:	39 d1                	cmp    %edx,%ecx
8010709e:	73 10                	jae    801070b0 <deallocuvm+0x20>
}
801070a0:	5d                   	pop    %ebp
801070a1:	e9 1a fb ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801070a6:	8d 76 00             	lea    0x0(%esi),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070b0:	89 d0                	mov    %edx,%eax
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret    
801070b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070cc:	85 f6                	test   %esi,%esi
801070ce:	74 59                	je     80107129 <freevm+0x69>
801070d0:	31 c9                	xor    %ecx,%ecx
801070d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070d7:	89 f0                	mov    %esi,%eax
801070d9:	e8 e2 fa ff ff       	call   80106bc0 <deallocuvm.part.0>
801070de:	89 f3                	mov    %esi,%ebx
801070e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070e6:	eb 0f                	jmp    801070f7 <freevm+0x37>
801070e8:	90                   	nop
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070f3:	39 fb                	cmp    %edi,%ebx
801070f5:	74 23                	je     8010711a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070f7:	8b 03                	mov    (%ebx),%eax
801070f9:	a8 01                	test   $0x1,%al
801070fb:	74 f3                	je     801070f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107102:	83 ec 0c             	sub    $0xc,%esp
80107105:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107108:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010710d:	50                   	push   %eax
8010710e:	e8 0d b2 ff ff       	call   80102320 <kfree>
80107113:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107116:	39 fb                	cmp    %edi,%ebx
80107118:	75 dd                	jne    801070f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010711a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010711d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107120:	5b                   	pop    %ebx
80107121:	5e                   	pop    %esi
80107122:	5f                   	pop    %edi
80107123:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107124:	e9 f7 b1 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 5d 7d 10 80       	push   $0x80107d5d
80107131:	e8 5a 92 ff ff       	call   80100390 <panic>
80107136:	8d 76 00             	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <setupkvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	56                   	push   %esi
80107144:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107145:	e8 86 b3 ff ff       	call   801024d0 <kalloc>
8010714a:	85 c0                	test   %eax,%eax
8010714c:	89 c6                	mov    %eax,%esi
8010714e:	74 42                	je     80107192 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107150:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107153:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107158:	68 00 10 00 00       	push   $0x1000
8010715d:	6a 00                	push   $0x0
8010715f:	50                   	push   %eax
80107160:	e8 bb d7 ff ff       	call   80104920 <memset>
80107165:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107168:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010716b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010716e:	83 ec 08             	sub    $0x8,%esp
80107171:	8b 13                	mov    (%ebx),%edx
80107173:	ff 73 0c             	pushl  0xc(%ebx)
80107176:	50                   	push   %eax
80107177:	29 c1                	sub    %eax,%ecx
80107179:	89 f0                	mov    %esi,%eax
8010717b:	e8 b0 f9 ff ff       	call   80106b30 <mappages>
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	85 c0                	test   %eax,%eax
80107185:	78 19                	js     801071a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107187:	83 c3 10             	add    $0x10,%ebx
8010718a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107190:	75 d6                	jne    80107168 <setupkvm+0x28>
}
80107192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107195:	89 f0                	mov    %esi,%eax
80107197:	5b                   	pop    %ebx
80107198:	5e                   	pop    %esi
80107199:	5d                   	pop    %ebp
8010719a:	c3                   	ret    
8010719b:	90                   	nop
8010719c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	56                   	push   %esi
      return 0;
801071a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071a6:	e8 15 ff ff ff       	call   801070c0 <freevm>
      return 0;
801071ab:	83 c4 10             	add    $0x10,%esp
}
801071ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b1:	89 f0                	mov    %esi,%eax
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5d                   	pop    %ebp
801071b6:	c3                   	ret    
801071b7:	89 f6                	mov    %esi,%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071c0 <kvmalloc>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071c6:	e8 75 ff ff ff       	call   80107140 <setupkvm>
801071cb:	a3 a4 36 11 80       	mov    %eax,0x801136a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d0:	05 00 00 00 80       	add    $0x80000000,%eax
801071d5:	0f 22 d8             	mov    %eax,%cr3
}
801071d8:	c9                   	leave  
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071e1:	31 c9                	xor    %ecx,%ecx
{
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071eb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ee:	e8 bd f8 ff ff       	call   80106ab0 <walkpgdir>
  if(pte == 0)
801071f3:	85 c0                	test   %eax,%eax
801071f5:	74 05                	je     801071fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071fa:	c9                   	leave  
801071fb:	c3                   	ret    
    panic("clearpteu");
801071fc:	83 ec 0c             	sub    $0xc,%esp
801071ff:	68 6e 7d 10 80       	push   $0x80107d6e
80107204:	e8 87 91 ff ff       	call   80100390 <panic>
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107219:	e8 22 ff ff ff       	call   80107140 <setupkvm>
8010721e:	85 c0                	test   %eax,%eax
80107220:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107223:	0f 84 9f 00 00 00    	je     801072c8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010722c:	85 c9                	test   %ecx,%ecx
8010722e:	0f 84 94 00 00 00    	je     801072c8 <copyuvm+0xb8>
80107234:	31 ff                	xor    %edi,%edi
80107236:	eb 4a                	jmp    80107282 <copyuvm+0x72>
80107238:	90                   	nop
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
80107243:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107249:	68 00 10 00 00       	push   $0x1000
8010724e:	53                   	push   %ebx
8010724f:	50                   	push   %eax
80107250:	e8 7b d7 ff ff       	call   801049d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107255:	58                   	pop    %eax
80107256:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010725c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107261:	5a                   	pop    %edx
80107262:	ff 75 e4             	pushl  -0x1c(%ebp)
80107265:	50                   	push   %eax
80107266:	89 fa                	mov    %edi,%edx
80107268:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010726b:	e8 c0 f8 ff ff       	call   80106b30 <mappages>
80107270:	83 c4 10             	add    $0x10,%esp
80107273:	85 c0                	test   %eax,%eax
80107275:	78 61                	js     801072d8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107277:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010727d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107280:	76 46                	jbe    801072c8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107282:	8b 45 08             	mov    0x8(%ebp),%eax
80107285:	31 c9                	xor    %ecx,%ecx
80107287:	89 fa                	mov    %edi,%edx
80107289:	e8 22 f8 ff ff       	call   80106ab0 <walkpgdir>
8010728e:	85 c0                	test   %eax,%eax
80107290:	74 61                	je     801072f3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107292:	8b 00                	mov    (%eax),%eax
80107294:	a8 01                	test   $0x1,%al
80107296:	74 4e                	je     801072e6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107298:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010729a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010729f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801072a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801072a8:	e8 23 b2 ff ff       	call   801024d0 <kalloc>
801072ad:	85 c0                	test   %eax,%eax
801072af:	89 c6                	mov    %eax,%esi
801072b1:	75 8d                	jne    80107240 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801072b3:	83 ec 0c             	sub    $0xc,%esp
801072b6:	ff 75 e0             	pushl  -0x20(%ebp)
801072b9:	e8 02 fe ff ff       	call   801070c0 <freevm>
  return 0;
801072be:	83 c4 10             	add    $0x10,%esp
801072c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ce:	5b                   	pop    %ebx
801072cf:	5e                   	pop    %esi
801072d0:	5f                   	pop    %edi
801072d1:	5d                   	pop    %ebp
801072d2:	c3                   	ret    
801072d3:	90                   	nop
801072d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801072d8:	83 ec 0c             	sub    $0xc,%esp
801072db:	56                   	push   %esi
801072dc:	e8 3f b0 ff ff       	call   80102320 <kfree>
      goto bad;
801072e1:	83 c4 10             	add    $0x10,%esp
801072e4:	eb cd                	jmp    801072b3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801072e6:	83 ec 0c             	sub    $0xc,%esp
801072e9:	68 92 7d 10 80       	push   $0x80107d92
801072ee:	e8 9d 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801072f3:	83 ec 0c             	sub    $0xc,%esp
801072f6:	68 78 7d 10 80       	push   $0x80107d78
801072fb:	e8 90 90 ff ff       	call   80100390 <panic>

80107300 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107300:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107301:	31 c9                	xor    %ecx,%ecx
{
80107303:	89 e5                	mov    %esp,%ebp
80107305:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107308:	8b 55 0c             	mov    0xc(%ebp),%edx
8010730b:	8b 45 08             	mov    0x8(%ebp),%eax
8010730e:	e8 9d f7 ff ff       	call   80106ab0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107313:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107315:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107316:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107318:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010731d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107320:	05 00 00 00 80       	add    $0x80000000,%eax
80107325:	83 fa 05             	cmp    $0x5,%edx
80107328:	ba 00 00 00 00       	mov    $0x0,%edx
8010732d:	0f 45 c2             	cmovne %edx,%eax
}
80107330:	c3                   	ret    
80107331:	eb 0d                	jmp    80107340 <copyout>
80107333:	90                   	nop
80107334:	90                   	nop
80107335:	90                   	nop
80107336:	90                   	nop
80107337:	90                   	nop
80107338:	90                   	nop
80107339:	90                   	nop
8010733a:	90                   	nop
8010733b:	90                   	nop
8010733c:	90                   	nop
8010733d:	90                   	nop
8010733e:	90                   	nop
8010733f:	90                   	nop

80107340 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 1c             	sub    $0x1c,%esp
80107349:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010734c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010734f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107352:	85 db                	test   %ebx,%ebx
80107354:	75 40                	jne    80107396 <copyout+0x56>
80107356:	eb 70                	jmp    801073c8 <copyout+0x88>
80107358:	90                   	nop
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107363:	89 f1                	mov    %esi,%ecx
80107365:	29 d1                	sub    %edx,%ecx
80107367:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010736d:	39 d9                	cmp    %ebx,%ecx
8010736f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107372:	29 f2                	sub    %esi,%edx
80107374:	83 ec 04             	sub    $0x4,%esp
80107377:	01 d0                	add    %edx,%eax
80107379:	51                   	push   %ecx
8010737a:	57                   	push   %edi
8010737b:	50                   	push   %eax
8010737c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010737f:	e8 4c d6 ff ff       	call   801049d0 <memmove>
    len -= n;
    buf += n;
80107384:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107387:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010738a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107390:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107392:	29 cb                	sub    %ecx,%ebx
80107394:	74 32                	je     801073c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107396:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107398:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010739b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010739e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073a4:	56                   	push   %esi
801073a5:	ff 75 08             	pushl  0x8(%ebp)
801073a8:	e8 53 ff ff ff       	call   80107300 <uva2ka>
    if(pa0 == 0)
801073ad:	83 c4 10             	add    $0x10,%esp
801073b0:	85 c0                	test   %eax,%eax
801073b2:	75 ac                	jne    80107360 <copyout+0x20>
  }
  return 0;
}
801073b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073bc:	5b                   	pop    %ebx
801073bd:	5e                   	pop    %esi
801073be:	5f                   	pop    %edi
801073bf:	5d                   	pop    %ebp
801073c0:	c3                   	ret    
801073c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073cb:	31 c0                	xor    %eax,%eax
}
801073cd:	5b                   	pop    %ebx
801073ce:	5e                   	pop    %esi
801073cf:	5f                   	pop    %edi
801073d0:	5d                   	pop    %ebp
801073d1:	c3                   	ret    
