# Emily's Modifier Dictionary
# Modified by AlexandraAlter
import re

unique_starts = ["!"]
unique_ends = [""]

LONGEST_KEY = 1

# fingerspelling dictionary entries for relevant theories
spelling = {
    "A": "a",
    "PW": "b",
    "KR": "c",
    "TK": "d",
    "E": "e",
    "TP": "f",
    "TKPW": "g",
    "H": "h",
    "EU": "i",
    "SKWR": "j",
    "K": "k",
    "HR": "l",
    "PH": "m",
    "TPH": "n",
    "O": "o",
    "P": "p",
    "KW": "q",
    "R": "r",
    "S": "s",
    "T": "t",
    "U": "u",
    "SR": "v",
    "W": "w",
    "KP": "x",
    "KWR": "y",
    "STKPW": "z",
}

# same as emily-symbols format, but modified for use on the left hand
symbols = {
    "TR": ["tab", "delete", "backspace", "escape"],
    "KPWR": ["up", "left", "right", "down"],
    "KPWHR": ["page_up", "home", "end", "page_down"],
    "": ["", "tab", "return", "space"],

    # typable symbols
    "HR": ["exclam", "", "notsign", "exclamdown"],
    "PH": ["quotedbl", "", "", ""],
    "TKHR": ["numbersign", "registered", "copyright", ""],
    "KPWH": ["dollar", "euro", "yen", "sterling"],
    "PWHR": ["percent", "", "", ""],
    "SKP": ["ampersand", "", "", ""],
    "H": ["apostrophe", "", "", ""],
    "TPH": ["parenleft", "less", "bracketleft", "braceleft"],
    "KWR": ["parenright", "greater", "bracketright", "braceright"],
    "T": ["asterisk", "section", "", "multiply"],
    "K": ["plus", "paragraph", "", "plusminus"],
    "W": ["comma", "", "", ""],
    "TP": ["minus", "", "", ""],
    "R": ["period", "periodcentered", "", ""],
    "WH": ["slash", "", "", "division"],
    "TK": ["colon", "", "", ""],
    "WR": ["semicolon", "", "", ""],
    "TKPW": ["equal", "", "", ""],
    "TPW": ["question", "", "questiondown", ""],
    "TKPWHR": ["at", "", "", ""],
    "PR": ["backslash", "", "", ""],
    "KPR": ["asciicircum", "guillemotleft", "guillemotright", "degree"],
    "KW": ["underscore", "", "", "mu"],
    "P": ["grave", "", "", ""],
    "PW": ["bar", "", "", "brokenbar"],
    "TPWR": ["asciitilde", "", "", ""]
}

mods = {
    "R": "shift(",
    "F": "control(",
    "B": "alt(",
    "P": "super(",
}

numbers = {
    "R": 1,
    "W": 2,
    "K": 4,
    "S": 8,
}

variants = {
    "A": 1,
    "O": 2,
}

stroke_re = re.compile(r"([#!+^]*)([STKPWHR]*)([AO]*)([*-]?)([EU]*)([FRPB]*)([LGTSDZ]*)")

trans_numbers = str.maketrans("1234506789", "STPHAOFPLT")


def lookup(chord):

    # extract the chord for easy use
    stroke = chord[0]

    # quick tests to avoid regex if non-relevant stroke is sent
    if len(chord) != 1:
        raise KeyError
    assert len(chord) <= LONGEST_KEY

    # extract relevant parts of the stroke
    first_match = stroke_re.fullmatch(stroke)

    # error out if there are no matches found
    if first_match is None:
        raise KeyError
    # name the relevant extracted parts of the regex
    (starter, key, vowel1, seperator, vowel2, modifiers, ender) = first_match.groups()

    # error out if no modifiers were provided
    if modifiers == "":
        raise KeyError

    if starter not in unique_starts or ender not in unique_ends:
        raise KeyError

    if key == "" and vowel1 == "" and vowel2 == "":
        # just modifiers pressed on their own, used a lot in windows apparently
        character = ""
    elif "*" in seperator:
        # use * to distinguish symbol input from numerical or character input
        # symbol input
        pattern, vari = key, vowel1

        # if the pattern is not recognised, error out
        if pattern not in symbols:
            raise KeyError

        # calculate the variant count
        variant = sum(variants[v] for v in vari)

        # get the entry
        entry = symbols[pattern]
        if type(entry) == list:
            extract = entry[variant]
            # error out if the entry isn't applicable
            if extract == "":
                raise KeyError

            character = extract
        else:
            character = entry

    else:
        # numbers or letters
        shape = key

        # AO is unused in finger spelling, thus used to disginguish numerical input
        if vowel1 == "AO" and vowel2 == "":

            # left-hand bottom row counts in binary for numbers 0-9
            count = sum(numbers[s] for s in shape)

            if "T" in shape and "P" in shape:
                # function key
                character = "F" + str(count)
                if count > 12:
                    raise KeyError
            else:
                # numeral
                if count > 9:
                    raise KeyError
                character = str(count)
        else:
            # finger spelling input
            entry = shape + vowel1 + vowel2

            # check for entry in dictionary
            if entry not in spelling:
                raise KeyError
            character = spelling[entry]

            # if there is no entry, pass the error
            if character == "":
                raise KeyError

    # accumulate list of modifiers to be added to the character
    ms = [mods[key] for key in modifiers]
    ms_ends = [")"] * len(ms)

    # package it up with the syntax
    parts = ["{#", *ms, character, *ms_ends, "}"]
    return "".join(parts)
