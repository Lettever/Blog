import std/[tables, enumutils]

type
    Lexer[SymEnum: enum, KwEnum: enum] = object
        src: string
        i: int
        symbols: Table[string, SymEnum]
        keywords: Table[string, KwEnum]
    Symbols = enum
        Plus = "+", Minus = "-", Star = "*", Slash = "/",
        Dot = ".", Eq = "=", DoubleEq = "==", Colon = ":",
        Exclamation = "!", LParan = "(", RParan = ")",
        LBracket = "{", RBracket = "}",
        LBrace = "[", RBrace = "]", LessThan = "<", GreaterThan = ">"
        LessThanOrEq = "<=", GreatherThanOrEq = ">=", NotEq = "!=",
        Range = "..", RangeEq = "..="
    Keywords = enum
        If = "if", While = "while", For = "for",
        Struct = "struct",

proc newLexer[SymEnum, KwEnum](src: string): Lexer[SymEnum, KwEnum] =
    result = Lexer[SymEnum, KwEnum](src: src)


#[
proc lexIdent(l: var Lexer): Token =
    var res = ""
    assert(parseIdent(l.src, res, l.i) == 0, "lexIdent did not lex anything - Should nexer happen")
    return newToken(res, Ident)

proc lexNumber(l: var Lexer): Token =
    var res = ""
    assert(parseWhile(l.src, res, Digits, l.i) == 0, "lexNumber did not lex anything - Should nexer happen")
    return newToken(res, Number)
]#

var lexer = newLexer[Symbols, Keywords]("abd")

echo lexer
echo Plus
echo symbolName(Minus)
#[
"+", "-", "*", "/",
".", "=", "==", ":",
"!", "(", ")",
"{", "}",
"[", "]", "<", ">"
"<=", ">=", "!=",
"..", "..="
]#
