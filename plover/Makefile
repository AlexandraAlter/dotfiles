CC = gcc
CFLAGS = -O2 -Wall -fPIC
LDFLAGS = -shared -lyaml
FILES = libyaml/*.c
LUA = lua

dicts: yaml.so
	$(LUA) make.lua

yaml.so:
	$(CC) $(LDFLAGS) $(CFLAGS) $(FILES) -o $@

clean:
	$(RM) yaml.so

.PHONY: dicts clean
