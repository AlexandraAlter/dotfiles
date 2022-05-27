CC = gcc
CFLAGS = -O2 -Wall -fPIC
LDFLAGS = -shared -lyaml -llua5.4
FILES = libyaml/*.c
LUA = lua
OUT = out

dicts: $(OUT) yaml.so
	./gen.lua -o $(OUT)
	prettier -w --tab-width 0 out

$(OUT):
	mkdir -p $(OUT)

yaml.so:
	$(CC) $(LDFLAGS) $(CFLAGS) $(FILES) -o $@

clean:
	$(RM) yaml.so $(OUT)/*.json

.PHONY: dicts clean
