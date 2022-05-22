-- AlexandraAlter's Plover Dictionaries

require'lib'

print('Making directory...')
os.execute('mkdir -p out')

print('Clearing directory...')
os.execute('rm out/*')

print('Generating number strokes...')
require'numbers'
local num_file <close> = io.open('out/numbers.json', 'w')
local num_dict = build_numbers()
num_dict:write(num_file)

print('Generating symbol strokes...')
require'symbols'
local sym_file <close> = io.open('out/symbols.json', 'w')
local sym_dict = build_symbols()
sym_dict:write(sym_file)

print('Generating modifier strokes...')
require'modifiers'
local mod_file <close> = io.open('out/modifiers.json', 'w')
local mod_dict = build_modifiers()
mod_dict:write(mod_file)

print('Generating phrase strokes...')
require'phrases'
local phr_file <close> = io.open('out/phrases.json', 'w')
local phr_dict = build_phrases()
phr_dict:write(phr_file)

print('Reformatting files...')
os.execute('prettier -w --tab-width 0 out')
