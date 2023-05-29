# Plover 

## Vim Commands

### JSON to YAML

Protect *-first stroke: `:s/"\(\*.*":\)/".\1`
Unquote stroke: `:s/"\(.*\)":/\1:`
Single-quote output: `:s/"\(.*\)"/'\1'`
Remove comma: `:s/,$//`

### Sort Strokes

`:sort /: ["'].*["']/r`

### Double Stroke Finder

`\<\([A-Za-z0-9*ĀĒĪŌŪ-]*\)\/\1\>`


