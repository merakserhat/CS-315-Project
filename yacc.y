%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
extern int yylineno;
%}

%token PLUS
%token SIGN
%token SPACE
%token ALPHABETIC
%token DIGIT
%token FLOAT
%token CHAR
%token BOOL
%token INT
%token IDENTIFIER
%token STRING
%token ARRAY_IDENT
%token COMMENT
%token MULTILINE_COMMENT
%token NL
%token WS
%token OROP
%token ANDOP
%token EQUAL
%token ASSIGN
%token NOT
%token MINUS
%token DIV
%token MULT
%token EXPONENT
%token MOD
%token INCREASE
%token DECREASE
%token IF
%token ELSE
%token FOR
%token WHILE
%token FUNCT
%token LP
%token RP
%token LB
%token RB
%token LSB
%token RSB
%token SC
%token COMMA
%token DOT
%token GREATER_THAN
%token LESS_THAN
%token GRE_OR_EQU
%token LES_OR_EQU
%token NOT_EQUAL
%token TRUE
%token FALSE
%token YE
%token TUKUR
%token BOOL_DEF
%token CHAR_DEF
%token STRING_DEF
%token FLOAT_DEF
%token INTEGER_DEF
%token DON
%token TT
%token KASIK
%token BICAK

%%		

program : KASIK statements BICAK
statements : statement | statement statements

statement : assignment_statement 
       | condition_statement 
       | loop_statement 
       | input_statement
       | output_statement
       | comment_statement
       | update_statement
       | function_statement
       | function_call
       | block
       | SC 

loop_statement : for_statement
       | while_statement
              
block : LB statements RB | LB statements DON expression RB | LB RB
function_call : function_name LP function_expression_list RP
function_expression_list : expression | expression COMMA expression

variable_type : BOOL_DEF | FLOAT_DEF | INTEGER_DEF
any_char : ALPHABETIC | DIGIT | WS

boolean_var : TRUE | FALSE
char_var : TT any_char TT

text : any_char | any_char text

int_var : INT

digit_sequence : DIGIT | DIGIT digit_sequence
signless_float : digit_sequence DOT digit_sequence
float_var : FLOAT

identifier : IDENTIFIER
variable_name : identifier 
variable : variable_type variable_name


collection : LSB integer_list RSB
       | LSB float_list RSB
       | LSB char_list RSB
       | LSB boolean_list RSB

integer_list : INT | integer_list COMMA INT
float_list : INT | float_list COMMA INT
char_list : INT | char_list COMMA INT
boolean_list : INT | boolean_list COMMA INT


expression : expression PLUS term | expression MINUS term
       | term
term : term MULT power | term DIV power
       | power
power : power EXPONENT factor | factor
factor : LP expression RP
       | item

item : variable_name | constant

constant : boolean_var | int_var | float_var

update_statement : variable_name DECREASE | variable_name INCREASE

assignment_statement : variable ASSIGN expression;  

condition : boolean_var 
       | LB expression RB comparison_operator LB expression RB 
       | variable_name 
       | variable_name comparison_operator variable_name
       | LB expression RB comparison_operator variable_name
       | variable_name comparison_operator LB expression RB 

conditions : LP condition RP
       | condition ANDOP condition
       | condition OROP condition
       | NOT condition
       | condition conditions
       | condition

condition_statement : IF LP conditions RP block
       | IF LP conditions RP block ELSE block

comparison_operator : EQUAL 
       | NOT_EQUAL
       | GREATER_THAN
       | LESS_THAN
       | GRE_OR_EQU
       | LES_OR_EQU

for_statement : FOR LP assignment_statement SC conditions SC update_statement RP block
while_statement : WHILE LP conditions RP block



input_statement: YE LP variable_name RP
output_statement : TUKUR LP expression RP


comment_statement : inline_comment 
inline_comment : COMMENT text



function_statement : FUNCT function_name function_body block
function_name : variable_name
function_variable_list : variable | variable COMMA function_variable_list
function_body : LP RP
       | LP function_variable_list RP

%%
#include "lex.yy.c"
void yyerror(char *s) {
	fprintf(stdout, "line %d: %s\n", yylineno,s);
}

int main() {
	int error = yyparse();
	if (error == 0) {
		printf("Input program is valid.\n");
	}
 	return error;
}