%{
#include <stdio.h>
#include <math.h>
int temp=0;
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
	|	error	{yyerror("%d.%d-%d.%d: Instruccion inválida",
				@1.first_line, @1.first_column, @1.last_line,
				@1.last_column); 
				yyerrok;}
	;

instr:	LEE ID ';'	{printf("param %s", $2->valor);
					 printf("call lee,1");}
	|	IMPRIME exprar ';'	{printf("param %s", $2->valor);
							 printf("call lee,1");}
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
	|	exprar '/' exprar	{	if ($3)
									printf();
								else {
									fprintf(stderr, "%d.%d-%d.%d: division por cero",
									@3.first_line, @3.first_column,
									@3.last_line, @3.last_column);
								}
							}
	|	'-' termino %prec UMENOS	{printf();}
	|	'(' exprar ')'
	;
	
exprlog:	exprar RELOP exprar
		|	'(' exprlog ')'
		;

param:	ENT		{printf("%d", $1);}
	|	FLOT	{printf("%f", $1);}
	|	exprasig
	|	'(' param ')'
	;

termino:	ENT
		|	FLOT
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