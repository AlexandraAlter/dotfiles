local phrases = {}

local pl = require'plover'

-- briefs are of the following forms:
--  subject + adverb + verb
--  clause + subject_short + verb

local subjects = {
  ['SWR'] = 'I ',
  ['KPWR'] = 'you ',
  ['KWHR'] = 'he ',
  ['SKWHR'] = 'she ',
  ['TWH'] = 'they ',
  ['TWR'] = 'we ',
  ['KPWH'] = 'it ',
  ['STKPWHR'] = '',
}

local adverbs = {
  ['A'] = 'really ',
  ['U'] = 'really ',
  ['O'] = "can't ",
  ['AO'] = "really can't ",
  ['OU'] = "can't really ",
  ['OE'] = "don't ",
  ['AOE'] = "really don't ",
  ['OEU'] = "don't really ",
  ['E'] = "doesn't ",
  ['AE'] = "really doesn't ",
  ['EU'] = "doesn't really ",
  ['AU'] = "didn't ",
  ['AEU'] = "didn't really ",
  ['AOU'] = "really didn't ",
  ['AOEU'] = "don't even ",
  [''] = '',
}

local clauses = {
  ['WH'] = 'what ',
  ['SKPW'] = "don't ",
  ['STKO'] = 'do ',
  ['STKPWO'] = 'did ',
  ['STHA'] = 'that ',
  ['STPA'] = 'if ',
  ['SWH'] = 'when ',
}

local clause_do_replacement = {
  ['he '] = 'does',
  ['she '] = 'does',
  ['it '] = 'does',
  ['I '] = 'do',
  ['you '] = 'do',
  ['they '] = 'do',
  ['we '] = 'do',
  [''] = 'do',
}

local subjects_short = {
  ['E'] = 'he ',
  ['U'] = 'you ',
  ['EU'] = 'I ',
  [''] = '',
}

local verbs = {
  ['-PB'] = 'know',
  ['-PBT'] = 'know that',
  ['-PBTS'] = 'knows that',
  ['-*PBT'] = 'know the',
  ['-*PBTS'] = 'knows the',
  ['-*PBTD'] = 'knew the',
  ['-P'] = 'want',
  ['-PT'] = 'want to',
  ['-PTS'] = 'wants to',
  ['-PTD'] = 'wanted to',
  ['-*PT'] = 'want the',
  ['-*PTS'] = 'wants the',
  ['-*PTD'] = 'wanted the',
  ['-*P'] = 'wanna',
  ['-RPL'] = 'remember',
  ['-RPLT'] = 'remember that',
  ['-RPLTS'] = 'remembers that',
  ['-RPLTD'] = 'remembered that',
  ['-*RPLT'] = 'remember the',
  ['-*RPLTS'] = 'remembers the',
  ['-*RPLTD'] = 'remembered the',
  ['-BG'] = 'can',
  ['-BGT'] = "can't",
  ['-BGD'] = 'could',
  ['-BL'] = 'believe',
  ['-BLT'] = 'believe that',
  ['-*BLT'] = 'believe the',
  ['-D'] = 'had',
  ['-F'] = 'have',
  ['-FZ'] = 'has',
  ['-FS'] = 'was',
  ['-FT'] = 'have to',
  ['-FTS'] = 'has to',
  ['-*FT'] = 'have the',
  ['-*FTS'] = 'has the',
  ['-FPLT'] = 'must',
  ['-L'] = 'will',
  ['-LD'] = 'would',
  ['-PBG'] = 'think',
  ['-PBGT'] = 'think that',
  ['-PBGTS'] = 'thinks that',
  ['-*PBGT'] = 'think the',
  ['-*PBGTS'] = 'thinks the',
  ['-PL'] = 'may',
  ['-PLT'] = 'might',
  ['-R'] = 'are', -- special case this one
  ['-RT'] = 'are not', -- also special case this
  ['-*RT'] = "aren't", -- and this one
  ['-RB'] = 'shall',
  ['-RBD'] = 'should',
  ['-RL'] = 'recall',
  ['-RP'] = 'were',
  ['-RPBT'] = 'were not',
  ['-*RPBT'] = "weren't",
  ['-RPT'] = 'were the',
  ['-*RPT'] = 'were the',
  ['-RPBD'] = 'understand',
  ['-*RPBD'] = 'understood',
  ['-PBD'] = 'need',
  ['-PBTD'] = 'need to',
  ['-PBTSD'] = 'needs to',
  ['-*PBTD'] = 'need the',
  ['-*PBTSD'] = 'needs the',
  ['-FL'] = 'feel',
  ['-FLG'] = 'feel like',
  ['-FLT'] = 'felt',
  ['-FLGT'] = 'felt like',
  ['-PBL'] = 'mean',
  ['-PBLT'] = 'meant',
  ['-BLG'] = 'like',
  ['-BLGT'] = 'like to',
  ['-BLGTS'] = 'likes to',
  ['-*BLGT'] = 'like the',
  ['-*BLGTS'] = 'likes the',
  ['-LG'] = 'love',
  ['-LGT'] = 'love to',
  ['-LGTS'] = 'loves to',
  ['-*LGT'] = 'love the',
  ['-*LGTS'] = 'loves the',
  ['-RBG'] = 'care',
  ['-RBGT'] = 'care about',
  ['-RBGTS'] = 'cares about',
  ['-GT'] = 'get',
  ['-*GT'] = 'got',
  ['-PLD'] = 'mind',
  ['-FG'] = 'forget',
  ['-FGT'] = 'forgot',
  ['-FRB'] = 'wish',
  ['-FRBT'] = 'wish to',
  ['-*FRBT'] = 'wish the',
  ['-PGT'] = 'expect',
  ['-FPB'] = 'even',
  ['-PBLG'] = 'just',
  ['-FR'] = 'ever',
  ['-B'] = 'be',
  ['-BT'] = 'be the',
  ['-*BT'] = 'be the',
  ['-BS'] = 'said',
  ['-BTS'] = 'said to',
  ['-*BTS'] = 'said the',
  ['-BZ'] = 'say',
  ['-BTZ'] = 'say to',
  ['-*BTZ'] = 'say the',
  ['-PLG'] = 'imagine',
  ['-PLGT'] = 'imagine that',
  ['-*PLGT'] = 'imagine the',
  [''] = '',
}

local verb_are_replacement = {
  ['he '] = 'is',
  ['she '] = 'is',
  ['it '] = 'is',
  ['I '] = 'am',
  ['you '] = 'are',
  ['they '] = 'are',
  ['we '] = 'are',
  [''] = 'are',
}

function phrases.build()
  local dict = pl.Dict:new{}

  for vk,verb in pairs(verbs) do
    for sk,subject in pairs(subjects) do
      for ak,adverb in pairs(adverbs) do
        if verb == 'are ' or verb == 'are not' or verb == "aren't " then
          local rep = verb_are_replacement[subject]
          local v_rep = string.gsub(verb, 'are', rep)
          dict:add({sk, ak, vk}, subject .. adverb .. v_rep)
        else
          dict:add({sk, ak, vk}, subject .. adverb .. verb)
        end
      end
    end

    for ck,clause in pairs(clauses) do
      for sk,subject in pairs(subjects_short) do
        if clause == 'do ' or clause == "don't " then
          local rep = clause_do_replacement[subject]
          local c_rep = string.gsub(clause, 'do', rep)
          dict:add({ck, sk, vk}, c_rep .. subject .. verb)
        else
          dict:add({ck, sk, vk}, clause .. subject .. verb)
        end
      end
    end
  end

  return dict
end

return phrases
