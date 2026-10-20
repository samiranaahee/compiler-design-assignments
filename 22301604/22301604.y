%{

#include"symbol_info.h"

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);

extern FILE *yyin;

ofstream outlog;

int line_num = 1;

void yyerror(char *s)
{
        outlog<<"Error at line no "<<line_num<<" : "<<s<<endl<<endl;
}

/* Rule match hole log-e rule-er naam ar code-er ongsho print kore */
void logrule(string rule, string text)
{
        outlog<<"At line no: "<<line_num<<" "<<rule<<" "<<endl<<endl;
        outlog<<text<<endl<<endl;
}

/* symbol_info-er naam (text) ber kore ante chhoto shortcut */
string N(symbol_info *s)
{
        return s->getnameofsymbol();
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE GOTO PRINTLN
%token ID CONST_INT CONST_FLOAT
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA COLON SEMICOLON

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program
        {
                outlog<<"At line no: "<<line_num<<" start : program "<<endl<<endl;
        }
        ;

program : program unit
        {
                logrule("program : program unit", N($1)+"\n"+N($2));
                $$ = new symbol_info(N($1)+"\n"+N($2),"program");
        }
        | unit
        {
                logrule("program : unit", N($1));
                $$ = new symbol_info(N($1),"program");
        }
        ;

unit : variable_decl
        {
                logrule("unit : variable_decl", N($1));
                $$ = new symbol_info(N($1),"unit");
        }
        | func_definition
        {
                logrule("unit : func_definition", N($1));
                $$ = new symbol_info(N($1),"unit");
        }
        ;

func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement
        {
                logrule("func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement",
                        N($1)+" "+N($2)+"("+N($4)+")\n"+N($6));
                $$ = new symbol_info(N($1)+" "+N($2)+"("+N($4)+")\n"+N($6),"func_def");
        }
        | type_specifier ID LPAREN RPAREN compound_statement
        {
                logrule("func_definition : type_specifier ID LPAREN RPAREN compound_statement",
                        N($1)+" "+N($2)+"()\n"+N($5));
                $$ = new symbol_info(N($1)+" "+N($2)+"()\n"+N($5),"func_def");
        }
        ;

param_list : param_list COMMA type_specifier ID
        {
                logrule("param_list : param_list COMMA type_specifier ID", N($1)+","+N($3)+" "+N($4));
                $$ = new symbol_info(N($1)+","+N($3)+" "+N($4),"param_list");
        }
        | param_list COMMA type_specifier
        {
                logrule("param_list : param_list COMMA type_specifier", N($1)+","+N($3));
                $$ = new symbol_info(N($1)+","+N($3),"param_list");
        }
        | type_specifier ID
        {
                logrule("param_list : type_specifier ID", N($1)+" "+N($2));
                $$ = new symbol_info(N($1)+" "+N($2),"param_list");
        }
        | type_specifier
        {
                logrule("param_list : type_specifier", N($1));
                $$ = new symbol_info(N($1),"param_list");
        }
        ;

compound_statement : LCURL statements RCURL
        {
                logrule("compound_statement : LCURL statements RCURL", "{\n"+N($2)+"\n}");
                $$ = new symbol_info("{\n"+N($2)+"\n}","compound");
        }
        | LCURL RCURL
        {
                logrule("compound_statement : LCURL RCURL", "{\n}");
                $$ = new symbol_info("{\n}","compound");
        }
        ;

variable_decl : type_specifier declaration_list SEMICOLON
        {
                logrule("variable_decl : type_specifier declaration_list SEMICOLON", N($1)+" "+N($2)+";");
                $$ = new symbol_info(N($1)+" "+N($2)+";","var_decl");
        }
        ;

type_specifier : INT
        {
                logrule("type_specifier : INT", "int");
                $$ = new symbol_info("int","type");
        }
        | FLOAT
        {
                logrule("type_specifier : FLOAT", "float");
                $$ = new symbol_info("float","type");
        }
        | VOID
        {
                logrule("type_specifier : VOID", "void");
                $$ = new symbol_info("void","type");
        }
        | CHAR
        {
                logrule("type_specifier : CHAR", "char");
                $$ = new symbol_info("char","type");
        }
        ;

declaration_list : declaration_list COMMA ID
        {
                logrule("declaration_list : declaration_list COMMA ID", N($1)+","+N($3));
                $$ = new symbol_info(N($1)+","+N($3),"decl_list");
        }
        | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
        {
                logrule("declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD",
                        N($1)+","+N($3)+"["+N($5)+"]");
                $$ = new symbol_info(N($1)+","+N($3)+"["+N($5)+"]","decl_list");
        }
        | ID
        {
                logrule("declaration_list : ID", N($1));
                $$ = new symbol_info(N($1),"decl_list");
        }
        | ID LTHIRD CONST_INT RTHIRD
        {
                logrule("declaration_list : ID LTHIRD CONST_INT RTHIRD", N($1)+"["+N($3)+"]");
                $$ = new symbol_info(N($1)+"["+N($3)+"]","decl_list");
        }
        ;

statements : statement
        {
                logrule("statements : statement", N($1));
                $$ = new symbol_info(N($1),"statements");
        }
        | statements statement
        {
                logrule("statements : statements statement", N($1)+"\n"+N($2));
                $$ = new symbol_info(N($1)+"\n"+N($2),"statements");
        }
        ;

statement : variable_decl
        {
                logrule("statement : variable_decl", N($1));
                $$ = new symbol_info(N($1),"stmnt");
        }
        | expression_statement
        {
                logrule("statement : expression_statement", N($1));
                $$ = new symbol_info(N($1),"stmnt");
        }
        | compound_statement
        {
                logrule("statement : compound_statement", N($1));
                $$ = new symbol_info(N($1),"stmnt");
        }
        | FOR LPAREN expression_statement expression_statement expression RPAREN statement
        {
                logrule("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement",
                        "for("+N($3)+N($4)+N($5)+")\n"+N($7));
                $$ = new symbol_info("for("+N($3)+N($4)+N($5)+")\n"+N($7),"stmnt");
        }
        | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
        {
                logrule("statement : IF LPAREN expression RPAREN statement",
                        "if("+N($3)+")\n"+N($5));
                $$ = new symbol_info("if("+N($3)+")\n"+N($5),"stmnt");
        }
        | IF LPAREN expression RPAREN statement ELSE statement
        {
                logrule("statement : IF LPAREN expression RPAREN statement ELSE statement",
                        "if("+N($3)+")\n"+N($5)+"\nelse\n"+N($7));
                $$ = new symbol_info("if("+N($3)+")\n"+N($5)+"\nelse\n"+N($7),"stmnt");
        }
        | WHILE LPAREN expression RPAREN statement
        {
                logrule("statement : WHILE LPAREN expression RPAREN statement",
                        "while("+N($3)+")\n"+N($5));
                $$ = new symbol_info("while("+N($3)+")\n"+N($5),"stmnt");
        }
        | PRINTLN LPAREN ID RPAREN SEMICOLON
        {
                logrule("statement : PRINTLN LPAREN ID RPAREN SEMICOLON", "printf("+N($3)+");");
                $$ = new symbol_info("printf("+N($3)+");","stmnt");
        }
        | RETURN expression SEMICOLON
        {
                logrule("statement : RETURN expression SEMICOLON", "return "+N($2)+";");
                $$ = new symbol_info("return "+N($2)+";","stmnt");
        }
        ;

expression_statement : SEMICOLON
        {
                logrule("expression_statement : SEMICOLON", ";");
                $$ = new symbol_info(";","expr_stmt");
        }
        | expression SEMICOLON
        {
                logrule("expression_statement : expression SEMICOLON", N($1)+";");
                $$ = new symbol_info(N($1)+";","expr_stmt");
        }
        ;

variable : ID
        {
                logrule("variable : ID", N($1));
                $$ = new symbol_info(N($1),"varbl");
        }
        | ID LTHIRD expression RTHIRD
        {
                logrule("variable : ID LTHIRD expression RTHIRD", N($1)+"["+N($3)+"]");
                $$ = new symbol_info(N($1)+"["+N($3)+"]","varbl");
        }
        ;

expression : logic_expression
        {
                logrule("expression : logic_expression", N($1));
                $$ = new symbol_info(N($1),"expr");
        }
        | variable ASSIGNOP logic_expression
        {
                logrule("expression : variable ASSIGNOP logic_expression", N($1)+"="+N($3));
                $$ = new symbol_info(N($1)+"="+N($3),"expr");
        }
        ;

logic_expression : rel_expression
        {
                logrule("logic_expression : rel_expression", N($1));
                $$ = new symbol_info(N($1),"lgc_expr");
        }
        | rel_expression LOGICOP rel_expression
        {
                logrule("logic_expression : rel_expression LOGICOP rel_expression", N($1)+N($2)+N($3));
                $$ = new symbol_info(N($1)+N($2)+N($3),"lgc_expr");
        }
        ;

rel_expression : simple_expression
        {
                logrule("rel_expression : simple_expression", N($1));
                $$ = new symbol_info(N($1),"rel_expr");
        }
        | simple_expression RELOP simple_expression
        {
                logrule("rel_expression : simple_expression RELOP simple_expression", N($1)+N($2)+N($3));
                $$ = new symbol_info(N($1)+N($2)+N($3),"rel_expr");
        }
        ;

simple_expression : term
        {
                logrule("simple_expression : term", N($1));
                $$ = new symbol_info(N($1),"simp_expr");
        }
        | simple_expression ADDOP term
        {
                logrule("simple_expression : simple_expression ADDOP term", N($1)+N($2)+N($3));
                $$ = new symbol_info(N($1)+N($2)+N($3),"simp_expr");
        }
        ;

term : unary_expression
        {
                logrule("term : unary_expression", N($1));
                $$ = new symbol_info(N($1),"term");
        }
        | term MULOP unary_expression
        {
                logrule("term : term MULOP unary_expression", N($1)+N($2)+N($3));
                $$ = new symbol_info(N($1)+N($2)+N($3),"term");
        }
        ;

unary_expression : ADDOP unary_expression
        {
                logrule("unary_expression : ADDOP unary_expression", N($1)+N($2));
                $$ = new symbol_info(N($1)+N($2),"un_expr");
        }
        | NOT unary_expression
        {
                logrule("unary_expression : NOT unary_expression", N($1)+N($2));
                $$ = new symbol_info(N($1)+N($2),"un_expr");
        }
        | factor_info
        {
                logrule("unary_expression : factor", N($1));
                $$ = new symbol_info(N($1),"un_expr");
        }
        ;

factor_info : factor
        {
                logrule("factor_info : factor", N($1));
                $$ = new symbol_info(N($1),"factor_info");
        }
        ;

factor : variable
        {
                logrule("factor : variable", N($1));
                $$ = new symbol_info(N($1),"factor");
        }
        | ID LPAREN argument_list RPAREN
        {
                logrule("factor : ID LPAREN argument_list RPAREN", N($1)+"("+N($3)+")");
                $$ = new symbol_info(N($1)+"("+N($3)+")","factor");
        }
        | LPAREN expression RPAREN
        {
                logrule("factor : LPAREN expression RPAREN", "("+N($2)+")");
                $$ = new symbol_info("("+N($2)+")","factor");
        }
        | CONST_INT
        {
                logrule("factor : CONST_INT", N($1));
                $$ = new symbol_info(N($1),"factor");
        }
        | CONST_FLOAT
        {
                logrule("factor : CONST_FLOAT", N($1));
                $$ = new symbol_info(N($1),"factor");
        }
        | variable INCOP
        {
                logrule("factor : variable INCOP", N($1)+"++");
                $$ = new symbol_info(N($1)+"++","factor");
        }
        | variable DECOP
        {
                logrule("factor : variable DECOP", N($1)+"--");
                $$ = new symbol_info(N($1)+"--","factor");
        }
        ;

argument_list : arguments
        {
                logrule("argument_list : arguments", N($1));
                $$ = new symbol_info(N($1),"arg_list");
        }
        |
        {
                logrule("argument_list :", "");
                $$ = new symbol_info("","arg_list");
        }
        ;

arguments : arguments COMMA logic_expression
        {
                logrule("arguments : arguments COMMA logic_expression", N($1)+","+N($3));
                $$ = new symbol_info(N($1)+","+N($3),"arguments");
        }
        | logic_expression
        {
                logrule("arguments : logic_expression", N($1));
                $$ = new symbol_info(N($1),"arguments");
        }
        ;

%%

int main(int argc, char *argv[])
{
        if(argc != 2)
        {
                cout<<"Please give input file name"<<endl;
                return 0;
        }
        yyin = fopen(argv[1], "r");
        outlog.open("22301604_log.txt", ios::trunc);

        if(yyin == NULL)
        {
                cout<<"Couldn't open file"<<endl;
                return 0;
        }

        yyparse();

        outlog<<endl<<"Total lines: "<<line_num<<endl;

        outlog.close();
        fclose(yyin);

        return 0;
}
