AS=nasm
ASFLAGS=-f bin
SOURCES=trans.asm
EXECUTABLE=trans.com

$(EXECUTABLE): $(SOURCES)
	$(AS) $(ASFLAGS) $(SOURCES) -o $@
