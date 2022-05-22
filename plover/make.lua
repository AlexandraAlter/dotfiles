-- AlexandraAlter's Plover Dictionaries

local pl = require'plover'

print('Making directory...')
os.execute('mkdir -p out')

print('Clearing directory...')
os.execute('rm out/*')

print('Generating main strokes...')
pl.Dict:read_yaml('main.yaml'):write('out/main.json')

print('Generating number strokes...')
local numbers = require'numbers'
numbers.build():write('out/numbers.json')

print('Generating symbol strokes...')
local symbols = require'symbols'
symbols.build():write('out/symbols.json')

print('Generating modifier strokes...')
local modifiers = require'modifiers'
modifiers.build():write('out/modifiers.json')

print('Generating phrase strokes...')
local phrases = require'phrases'
phrases.build():write('out/phrases.json')

print('Reformatting files...')
os.execute('prettier -w --tab-width 0 out')
