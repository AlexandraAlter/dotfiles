-- Programatic symbols
local symbols = {}

local pl = require'plover'

local pfx = '¶S'

local syms = {
  -- more computer function-y symbols
  ['-FG']    = {'{#Tab}', '{#Backspace}', '{#Delete}', '{#Escape}'},
  ['-RPBG']  = {'{#Up}', '{#Left}', '{#Right}', '{#Down}'},
  ['-FRPBG'] = {'{#Page_Up}', '{#Home}', '{#End}', '{#Page_Down}'},
  ['-FRBG']  = {'{#AudioPlay}', '{#AudioPrev}', '{#AudioNext}', '{#AudioStop}'},
  ['-FRB']   = {'{#AudioMute}', '{#AudioLowerVolume}', '{#AudioRaiseVolume}', '{#Eject}'},
  ['']      = {'', '{*!}', '{*?}', '{#Space}'},
  ['-FL']    = {'{*-|}', '{*<}', '{<}', '{*>}'},

  -- typable symbols
  ['-FR']     = {'!', '¬', '↦', '¡'},
  ['-FP']     = {'"', '“', '”', '„'},
  ['-FRLG']   = {'#', '©', '®', '™'},
  ['-RPBL']   = {'$', '¥', '€', '£'},
  ['-FRPB']   = {'%', '‰', '‱', 'φ'},
  ['-FBG']    = {'&', '∩', '∧', '∈'},
  ['-F']      = {"'", '‘', '’', '‚'},
  ['-FPL']    = {'(', '[', '<', '{'},
  ['-RBG']    = {')', ']', '>', '}'},
  ['-L']      = {'*', '∏', '§', '×'},
  ['-G']      = {'+', '∑', '¶', '±'},
  ['-B']      = {',', '∪', '∨', '∉'},
  ['-PL']     = {'-', '−', '–', '—'},
  ['-R']      = {'.', '•', '·', '…'},
  ['-RP']     = {'/', '⇒', '⇔', '÷'},
  ['-LG']     = {':', '∋', '∵', '∴'},
  ['-RB']     = {';', '∀', '∃', '∄'},
  ['-PBLG']   = {'=', '≡', '≈', '≠'},
  ['-FPB']    = {'?', '¿', '∝', '‽'},
  ['-FRPBLG'] = {'@', '⊕', '⊗', '∅'},
  ['-FB']     = {'\\', 'Δ', '√', '∞'},
  ['-RPG']    = {'^', '«', '»', '°'},
  ['-BG']     = {'_', '≤', '≥', 'µ'},
  ['-P']      = {'`', '⊂', '⊃', 'π'},
  ['-PB']     = {'|', '⊤', '⊥', '¦'},
  ['-FPBG']   = {'~', '⊆', '⊇', '˜'},
  ['-FPBL']   = {'↑', '←', '→', '↓'},
}

local attachments = {
  ['']   = {'',    ''   },
  ['A']  = {'{^}', ''   },
  ['O']  = {'',    '{^}'},
  ['AO'] = {'{^}', '{^}'},
}

local variants = {
  [''] = 1,
  ['E'] = 2,
  ['U'] = 3,
  ['EU'] = 4,
}

local repetitions = {
  [''] = 1,
  ['-S'] = 2,
  ['-T'] = 3,
  ['-TS'] = 4,
}

local capitalizations = {
  [''] = '',
  ['*'] = '{-|}',
}

function symbols.build()
  local dict = pl.Dict:new{}

  for sk,sym in pairs(syms) do
    for vk,var in pairs(variants) do
      for rk,reps in pairs(repetitions) do
        for ck,caps in pairs(capitalizations) do
          local sym_rep = string.rep(sym[var], reps)
          if sym ~= '{*!}' and sym ~= '{*?}' then
            for ak,attch in pairs(attachments) do
              local a1, a2 = attch[1], attch[2]
              local sym_attch = a1 .. ' ' .. sym_rep .. ' ' .. a2
              dict:add({pfx, sk, vk, rk, ck, ak}, sym_attch .. caps)
            end
          else
            dict:add({pfx, sk, vk, rk, ck}, sym_rep .. caps)
          end
        end
      end
    end
  end

  return dict
end

return symbols
