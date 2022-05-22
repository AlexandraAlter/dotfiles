-- AlexandraAlter's Plover Dictionaries

local pl = require'plover'
local numbers = require'numbers'
local symbols = require'symbols'
local modifiers = require'modifiers'
local phrases = require'phrases'

print('Generating main strokes...')
pl.Dict:read_yaml('dict.yaml'):write('out/dict.json')

print('Generating number strokes...')
numbers.build():write('out/numbers.json')

print('Generating symbol strokes...')
symbols.build():write('out/symbols.json')

print('Generating modifier strokes...')
modifiers.build():write('out/modifiers.json')

print('Generating phrase strokes...')
phrases.build():write('out/phrases.json')
