LIB = lib
OUT = out

LUA = lua
CC = gcc
CFLAGS = -O2 -Wall -fPIC
LDFLAGS = -shared -lyaml -llua5.4

dicts: $(OUT)
	./gen.lua --defaults -o $(OUT)
	prettier -w --tab-width 0 $(OUT)

$(OUT):
	mkdir -p $(OUT)

clean:
	$(RM) $(OUT)/*.json

.PHONY: dicts clean

