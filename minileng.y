%{
#include <stdio.h>
#include <math.h>
void yyerror(char *msj);
%}
%union	{
		float flot;
		int ent;
		simbolo *pos_ini;
		}
%token <ent> ENT
%token <flot> FLOT
%right '='
%left '+' '-'
%left '*' '/'
%right UMENOS
%%
instrs: /* Vacio */
	|	instr
	|	instrs instr
	|	error	{yyerror("Instruccion invalida"); yyerrok;}
	;

instr:	LEE ID ';'
	|	IMPRIME exprar ';'
	|	exprasig ';'
	|	PARA param HASTA param PASO param '(' instr ')' ';'
	|	SI exprlog ENTONCES instr CASO CONTRARIO instr
	|	'(' instr ')'
	;

exprasig:	ID '=' exprar
		|	ID '=' exprasig
		;

exprar:	termino
	|	exprar '+' exprar
	|	exprar '-' exprar
	|	exprar '*' exprar
	|	exprar '/' exprar
	|	'-' termino %prec UMENOS	{printf();}
	|	'(' exprar ')'
	;
	
exprlog:	exprar RELOP exprar
		|	'(' exprlog ')'
		;

param:	NUM
	|	exprasig
	|	'(' param ')'
	;

termino:	NUM
		|	ID
		|	'(' termino ')'
		;
%%
void yyerror(char *msg) {
	fprintf(stderr, "%s\n", msg);
}

int main() {
	yyparse();
	return 0;
}