%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
extern int yylineno;
%}

%token SIGN
%token ALPHABETIC
%token DIGIT
%token IDENTIFIER
%token BOOLEAN
%token STRING
%token COMMENT
%token NL
%token CONST
%token OROP
%token ANDOP
%token EQUAL
%token ASSIGN
%token NOT
%token PLUS
%token MINUS
%token DIV
%token EXPONENT
%token MOD
%token IF
%token ELSE
%token FOR
%token DO
%token WHILE
%token LP
%token RP
%token SC
%token GREATER_THAN
%token LESS_THAN
%token TRUE
%token FALSE

%%

program : kasik statements bicak
statements : statement | statement statements
statement : assignment_statement 
       | condition_statement 
       | loop_statement 
       | input_statement
       | output_statement
       | comment_statement
       | function_statement
       | function_call
       | block
       | SC

loop_statement : for_statement
       | while_statement
              
              
block : LB statements RB | LB statements don expression RB
function_call : function_name '(' function_expression_list ')'
function_expression_list : expression | expression COMMA expression

// variables
variable_type : bool | float | integer
any-char : letter | digit | symbol | whitespace

boolean_var : TRUE | FALSE

signless_int : digit | digit signless_int
int_var : plus signless_int | minus signless_int | signless_int

digit-sequence : digit | digit digit-sequence
signless_float : digit-sequence . digit-sequence
float_var : plus signless_float | minus signless_float | signless_float

identifier : letter | digit
variable_name_long : identifier | identifier /variable_name_long
variable_name : letter | letter variable_name_long
variable : variable_type variable_name

// Lists

collection : LSB integer-list RSB
       | LSB string-list RSB
       | LSB float-list RSB
       | LSB char-list RSB
       | LSB boolean-list RSB

integer-list : integer | integer-list COMMA integer
float-list : integer | float-list COMMA integer
char-list : integer | char-list COMMA integer
boolean-list : integer | boolean-list COMMA integer


// Expression


expression : expression + term | expression - term
       | term
term : term * power | term / power
       | power
power : power ^ factor | factor
factor : ( expression)
       | item

item : variable_name | constant

constant : char_var | boolean_var | string_var | int_var | float_var

update_statement : expression INCREASE
       | expression DECREASE

assignment_statement : variable EQUAL expression;  

condition_expression : expression comparison_operator expression
       | LP condition RP
       | condition AND condition
       | condition OR condition
       | NOT condition
       | boolean_var

// CONDITIONS

condition_statement : if LP condition_expression RP block
       | LP condition_expression RP statements else statements

// LOOPS

for_statement : for LP assignment_st SC condition_expression SC update_statement RP block
while_statement : while LP condition_expression RP block


// input output

input_statement: cinLP variable_name RP
output_statement : tukurLP string_varRP | tukurLP variable_nameRP

// comment statement

comment_statement : inline_comment | multiline_comment 
inline_comment : COMMENT text
multiline_comment : CM_OPEN text CM_CLOSE

// function

function_statement : function function_name  function_body RP block 
function_name : variable_name
function_variable_list : variable | variable COMMA function_variable_list
function_body : LPRP
       | LP function_variable_list RP

comparison_operator : "==" | "!=" | "<" | ">" | "<=" | ">="

math_operator : "+" | "-" | "*" | "/" | "^" | "%"

letter : "a" | "b" | ... | "z" | "A" | "B" | ... | "Z"

digit : "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
symbol : "+" | "-" | "*" | "/" | "=" | "==" | "!=" | "<" | ">" | "<=" | "=" | "&&" | "||"
whitespace : 
LP : (
RP : )
LB : {
RB :: = }
LSB : [
RSB : ]
COMMA : ,
SC : ;
EQUAL : =
OR : ||
AND : &&
NOT : !
INCRESE : ++
DECREASE : --
PLUS : +
MINUS : -
COMMENT : //
CM_OPEN : /*
CM_CLOSE : */
ARRAY_SIGN : []

TRUE : true
FALSE : false



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