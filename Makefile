CC=gcc
CFLAGS=-c -Wall
LDFLAGS=
SOURCES=progr.c fonction.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=progr

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)
