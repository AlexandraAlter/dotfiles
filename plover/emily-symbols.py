# Emily's Symbol Dictionary
# Modified by AlexandraAlter
import re

unique_starts = ["#!"]
unique_ends = [""]

# define if attachment keys define where "space"s or "attachment"s lie
method_spaces = True

LONGEST_KEY = 1

# variant format = ["", "E", "U", "EU"]
# if no variants exist, then a single string can be used for the symbol and the variant specifier keys will be valid but ignored
symbols = {
    unique_starts[0]: { # standard
        # more computer function-y symbols
        "FG"    : ["{#Tab}", "{#Backspace}", "{#Delete}", "{#Escape}"],
        "RPBG"  : ["{#Up}", "{#Left}", "{#Right}", "{#Down}"],
        "FRPBG" : ["{#Page_Up}", "{#Home}", "{#End}", "{#Page_Down}"],
        "FRBG"  : ["{#AudioPlay}", "{#AudioPrev}", "{#AudioNext}", "{#AudioStop}"],
        "FRB"   : ["{#AudioMute}", "{#AudioLowerVolume}", "{#AudioRaiseVolume}", "{#Eject}"],
        ""      : ["", "{*!}", "{*?}", "{#Space}"],
        "FL"    : ["{*-|}", "{*<}", "{<}", "{*>}"],

        # typable symbols
        "FR"     : ["!", "¬", "↦", "¡"],
        "FP"     : ["\"", "“", "”", "„"],
        "FRLG"   : ["#", "©", "®", "™"],
        "RPBL"   : ["$", "¥", "€", "£"],
        "FRPB"   : ["%", "‰", "‱", "φ"],
        "FBG"    : ["&", "∩", "∧", "∈"],
        "F"      : ["'", "‘", "’", "‚"],
        "FPL"    : ["(", "[", "<", "\{"],
        "RBG"    : [")", "]", ">", "\}"],
        "L"      : ["*", "∏", "§", "×"],
        "G"      : ["+", "∑", "¶", "±"],
        "B"      : [",", "∪", "∨", "∉"],
        "PL"     : ["-", "−", "–", "—"],
        "R"      : [".", "•", "·", "…"],
        "RP"     : ["/", "⇒", "⇔", "÷"],
        "LG"     : [":", "∋", "∵", "∴"],
        "RB"     : [";", "∀", "∃", "∄"],
        "PBLG"   : ["=", "≡", "≈", "≠"],
        "FPB"    : ["?", "¿", "∝", "‽"],
        "FRPBLG" : ["@", "⊕", "⊗", "∅"],
        "FB"     : ["\\", "Δ", "√", "∞"],
        "RPG"    : ["^", "«", "»", "°"],
        "BG"     : ["_", "≤", "≥", "µ"],
        "P"      : ["`", "⊂", "⊃", "π"],
        "PB"     : ["|", "⊤", "⊥", "¦"],
        "FPBG"   : ["~", "⊆", "⊇", "˜"],
        "FPBL"   : ["↑", "←", "→", "↓"]
    },
}

repetitions = {
    "A": 1,
    "O": 2,
}

variants = {
    "E": 1,
    "U": 2,
}

stroke_regex = re.compile(r"([#!+^STKPWHR]*)([AO]*)([*-]?)([EU]*)([FRPBLG]*)([TS]*)([DZ]*)")

trans_numbers = str.maketrans("1234506789", "STPHAOFPLT")

def lookup(chord):

    # extract the chord for easy use
    stroke = chord[0]

    # normalise stroke from embedded number, to preceding hash format
    if any(k.isnumeric() for k in stroke): # if chord contains a number
        stroke = "#" + stroke.translate(trans_numbers)

    # quick tests to avoid regex if non-relevant stroke is sent
    if len(chord) != 1:
        raise KeyError
    assert len(chord) <= LONGEST_KEY

    # extract relevant parts of the stroke
    match = stroke_regex.fullmatch(stroke)

    # error out if there are no matches found
    if match is None:
        raise KeyError

    # name the relevant extracted parts of the regex
    (starter, attachments, caps_str, vari_str, pattern, reps_str, ender) = match.groups()

    if starter not in unique_starts or ender not in unique_ends:
        raise KeyError

    # calculate the attachment method, and remove attachment specifier keys
    attach_before = method_spaces ^ ("A" in attachments)
    attach_after = method_spaces ^ ("O" in attachments)

    # detect if capitalisation is required
    caps = caps_str == "*"

    # calculate the variant number
    variant = sum(variants[v] for v in vari_str)

    # calculate the repetition
    reps = sum(repetitions[v] for v in reps_str) + 1

    if pattern not in symbols[starter]:
        raise KeyError

    # extract symbol entry from the 'symbols' dictionary
    # with variant specification if available
    selection = symbols[starter][pattern]
    if type(selection) == list:
        selection = selection[variant]
    output = selection

    # repeat the symbol the specified number of times
    output = output * reps

    # attachment space to either end of the symbol string to avoid escapement,
    # but prevent doing this for retrospective add/delete spaces, since it'll
    # mess with these macros
    if selection not in ["{*!}", "{*?}"]:
        output = " " + output + " "

    # add appropriate attachment as specified (again, prevent doing this
    # for retrospective add/delete spaces)
    if selection not in ["{*!}", "{*?}"]:
        if attach_before:
            output = "{^}" + output
        if attach_after:
            output = output + "{^}"

    # cancel out some formatting when using space attachment
    if method_spaces:
        if not attach_before:
            output = "{}" + output
        if not attach_after:
            output = output + "{}"

    # apply capitalisation
    if caps:
        output = output + "{-|}"

    # all done :D
    return output

