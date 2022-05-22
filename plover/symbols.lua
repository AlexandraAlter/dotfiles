
require'lib'

local prefix = '¶#'

local symbols = {
  -- more computer function-y symbols
  ['FG']    = {'{#Tab}', '{#Backspace}', '{#Delete}', '{#Escape}'},
  ['RPBG']  = {'{#Up}', '{#Left}', '{#Right}', '{#Down}'},
  ['FRPBG'] = {'{#Page_Up}', '{#Home}', '{#End}', '{#Page_Down}'},
  ['FRBG']  = {'{#AudioPlay}', '{#AudioPrev}', '{#AudioNext}', '{#AudioStop}'},
  ['FRB']   = {'{#AudioMute}', '{#AudioLowerVolume}', '{#AudioRaiseVolume}', '{#Eject}'},
  ['']      = {'', '{*!}', '{*?}', '{#Space}'},
  ['FL']    = {'{*-|}', '{*<}', '{<}', '{*>}'},

  -- typable symbols
  ['FR']     = {'!', '¬', '↦', '¡'},
  ['FP']     = {'"', '“', '”', '„'},
  ['FRLG']   = {'#', '©', '®', '™'},
  ['RPBL']   = {'$', '¥', '€', '£'},
  ['FRPB']   = {'%', '‰', '‱', 'φ'},
  ['FBG']    = {'&', '∩', '∧', '∈'},
  ['F']      = {"'", '‘', '’', '‚'},
  ['FPL']    = {'(', '[', '<', '{'},
  ['RBG']    = {')', ']', '>', '}'},
  ['L']      = {'*', '∏', '§', '×'},
  ['G']      = {'+', '∑', '¶', '±'},
  ['B']      = {',', '∪', '∨', '∉'},
  ['PL']     = {'-', '−', '–', '—'},
  ['R']      = {'.', '•', '·', '…'},
  ['RP']     = {'/', '⇒', '⇔', '÷'},
  ['LG']     = {':', '∋', '∵', '∴'},
  ['RB']     = {';', '∀', '∃', '∄'},
  ['PBLG']   = {'=', '≡', '≈', '≠'},
  ['FPB']    = {'?', '¿', '∝', '‽'},
  ['FRPBLG'] = {'@', '⊕', '⊗', '∅'},
  ['FB']     = {'\\', 'Δ', '√', '∞'},
  ['RPG']    = {'^', '«', '»', '°'},
  ['BG']     = {'_', '≤', '≥', 'µ'},
  ['P']      = {'`', '⊂', '⊃', 'π'},
  ['PB']     = {'|', '⊤', '⊥', '¦'},
  ['FPBG']   = {'~', '⊆', '⊇', '˜'},
  ['FPBL']   = {'↑', '←', '→', '↓'},
}

local repetitions = {
  [''] = 1,
  ['A'] = 2,
  ['O'] = 3,
  ['AO'] = 4,
}

local variants = {
  [''] = 1,
  ['E'] = 2,
  ['U'] = 3,
  ['EU'] = 4,
}

function build_symbols()
  local dict = Dict:new{}

  for sk,symbol in pairs(symbols) do
    for vk,variant in pairs(variants) do
      for rk,repetition in pairs(repetitions) do
        local sym = symbol[variant]
        sym = string.rep(sym, repetition)
        dict:add({prefix, rk, vk, sk}, sym)
      end
    end
  end

  return dict
end
