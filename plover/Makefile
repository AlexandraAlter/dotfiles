LIB = lib
OUT = out

LUA = lua
CC = gcc
CFLAGS = -O2 -Wall -fPIC
LDFLAGS = -shared -lyaml -llua5.4
FILES = lib/*.c

dicts: $(OUT) $(LIB)/yaml.so
	./gen.lua -o $(OUT)
	prettier -w --tab-width 0 $(OUT)

$(OUT):
	mkdir -p $(OUT)

$(LIB)/yaml.so:
	$(CC) $(LDFLAGS) $(CFLAGS) $(FILES) -o $@

clean:
	$(RM) $(LIB)/yaml.so $(OUT)/*.json

.PHONY: dicts clean

