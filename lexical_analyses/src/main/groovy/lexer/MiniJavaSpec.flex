/* JFlex example: partial Java language lexer specification */
import java_cup.runtime.*;

/**
 * This class is a simple example lexer.
 */
%%

%class MiniJavaLexer
%implements sym
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?

Identifier = [:jletter:] [:jletterdigit:]*

DecIntegerLiteral = 0 | [1-9][0-9]*

%state STRING

%%

/** keywords minijava ->
  boolean, class, public, extends, static,
  void, main, String, int, while, if, else,
  return, length, true, false, this, new,
  System.out.println;
**/
<YYINITIAL>    "boolean"                { return symbol(BREAK); }
<YYINITIAL>    "class"                  { return symbol(CLASS); }
<YYINITIAL>    "public"                 { return symbol(PUBLIC); }
<YYINITIAL>    "extends"                { return symbol(EXTENDS); }
<YYINITIAL>    "static"                 { return symbol(STATIC); }
<YYINITIAL>    "void"                   { return symbol(VOID); }
<YYINITIAL>    "main"                   { return symbol(MAIN); }
<YYINITIAL>    "String"                 { return symbol(STRING); }
<YYINITIAL>    "int"                    { return symbol(INT); }
<YYINITIAL>    "while"                  { return symbol(WHILE); }
<YYINITIAL>    "if"                     { return symbol(IF); }
<YYINITIAL>    "else"                   { return symbol(ELSE); }
<YYINITIAL>    "return"                 { return symbol(RETURN); }
<YYINITIAL>    "length"                 { return symbol(LENGTH); }
<YYINITIAL>    "true"                   { return symbol(TRUE); }
<YYINITIAL>    "false"                  { return symbol(FALSE); }
<YYINITIAL>    "this"                   { return symbol(THIS); }
<YYINITIAL>    "new"                    { return symbol(NEW); }
<YYINITIAL>    "System.out.println"     { return symbol(SYSTEM.OUT.PRINTLN); }

<YYINITIAL> {
    /* identifiers */
    {Identifier}                   { return symbol(IDENTIFIER); }

    /* integer literals */
    {DecIntegerLiteral}            { return symbol(INTEGER_LITERAL); }

    /* operators minijava ->
        &&, <, ==, !=, +, -, *, !;
    */
    "&&"                           { return symbol(AND); }
    "<"                            { return symbol(LESS_THAN); }
    "=="                           { return symbol(EQUAL); }
    "!="                           { return symbol(NOT_EQUAL); }
    "+"                            { return symbol(PLUS); }
    "-"                            { return symbol(MINUS); }
    "*"                            { return symbol(MULT); }
    "!"                            { return symbol(NOT); }

    /* separators */
    ";"                            { return symbol(SEMICOLON); }
    ","                            { return symbol(COMMA); }
    "."                            { return symbol(DOT); }
    "="                            { return symbol(EQ); }
    "("                            { return symbol(LPAREN); }
    ")"                            { return symbol(RPAREN); }
    "{"                            { return symbol(LBRACE); }
    "}"                            { return symbol(RBRACE); }
    "["                            { return symbol(LBRACK); }
    "]"                            { return symbol(RBRACK); }
    /* comments */
    {Comment}                      { /* ignore */ }

    /* whitespace */
    {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
    \\n                            { string.append('\n'); }
    \\t                            { string.append('\t'); }
    \\r                            { string.append('\r'); }
    \\f                            { string.append('\f'); }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                   yytext()+">"); }
