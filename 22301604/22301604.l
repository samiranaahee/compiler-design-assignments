%option noyywrap

%{
#include<bits/stdc++.h>

#include"symbol_info.h"

#define YYSTYPE symbol_info*

#include "y.tab.h"

extern YYSTYPE yylval;

using namespace std;

void yyerror(char *);

extern int line_num;

extern ofstream outlog;

/* token paile: symbol_info banay, yylval-e rakhe, log-e print kore, token return kore */
int emit(string type, int code)
{
    symbol_info *s = new symbol_info((string)yytext, type);
    yylval = (YYSTYPE)s;
    outlog << "Line no " << line_num << ": Token <" << type
           << "> Lexeme " << yytext << " found" << "\n" << "\n";
    return code;
}

%}

/* Regular Definitions */

delim    [ \t\v\r]
ws       {delim}+
newline  \n

letter_  [A-Za-z_]
digit    [0-9]

id       {letter_}({letter_}|{digit})*
integer  {digit}+
float    ({digit}*\.{digit}+([Ee][+-]?{digit}+)?)|({digit}+[Ee][+-]?{digit}+)

%%

{ws}        { /* ignore whitespace */ }
{newline}   { line_num++; }

"if"        { return emit("IF", IF); }
"else"      { return emit("ELSE", ELSE); }
"for"       { return emit("FOR", FOR); }
"while"     { return emit("WHILE", WHILE); }
"do"        { return emit("DO", DO); }
"break"     { return emit("BREAK", BREAK); }
"int"       { return emit("INT", INT); }
"char"      { return emit("CHAR", CHAR); }
"float"     { return emit("FLOAT", FLOAT); }
"double"    { return emit("DOUBLE", DOUBLE); }
"void"      { return emit("VOID", VOID); }
"return"    { return emit("RETURN", RETURN); }
"switch"    { return emit("SWITCH", SWITCH); }
"case"      { return emit("CASE", CASE); }
"default"   { return emit("DEFAULT", DEFAULT); }
"continue"  { return emit("CONTINUE", CONTINUE); }
"goto"      { return emit("GOTO", GOTO); }
"printf"    { return emit("PRINTLN", PRINTLN); }

{id}        { return emit("ID", ID); }

{integer}   { return emit("CONST_INT", CONST_INT); }
{float}     { return emit("CONST_FLOAT", CONST_FLOAT); }

"+"|"-"                                 { return emit("ADDOP", ADDOP); }
"*"|"/"|"%"                             { return emit("MULOP", MULOP); }
"++"                                    { return emit("INCOP", INCOP); }
"--"                                    { yylval = (YYSTYPE)new symbol_info((string)yytext, "DECOP"); return DECOP; }
"<"|">"|"=="|"<="|">="|"!="             { return emit("RELOP", RELOP); }
"="                                     { return emit("ASSIGNOP", ASSIGNOP); }
"&&"|"||"                               { return emit("LOGICOP", LOGICOP); }
"!"                                     { return emit("NOT", NOT); }
"("         { return emit("LPAREN", LPAREN); }
")"         { return emit("RPAREN", RPAREN); }
"{"         { return emit("LCURL", LCURL); }
"}"         { return emit("RCURL", RCURL); }
"["         { return emit("LTHIRD", LTHIRD); }
"]"         { return emit("RTHIRD", RTHIRD); }
","         { return emit("COMMA", COMMA); }
":"         { return emit("COLON", COLON); }
";"         { return emit("SEMICOLON", SEMICOLON); }

.           { outlog << "Error at line " << line_num << ": Unrecognized character " << yytext << "\n" << "\n"; }

%%
