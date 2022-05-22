CC = gcc
CFLAGS = -O2 -Wall -fPIC
LDFLAGS = -shared -lyaml
FILES = libyaml/*.c

yaml.so:
	$(CC) $(LDFLAGS) $(CFLAGS) $(FILES) -o $@

clean:
	$(RM) yaml.so

.PHONY: clean
