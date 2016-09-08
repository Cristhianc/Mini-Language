%{
#include <stdio.h>
#include <math.h>
int temp=1;
int lin_cod_i=1;
union numero {
	int ent;
	float flot;
}
void yyerror(char *msj);
%}
%union	{
		union numero num;
		char *nom;
		simbolo *pos_ini;
		}
%token RELOP
%token <num> ENT FLOT
%token <pos_ini> ID
%type <nom> identif
%type <num> numero
%right '='
%left '+' '-'
%left '*' '/'
%right UMENOS
%%
instrs: /* Vacio */
	|	instr
	|	instrs instr
	|	error	{fprintf("%d.%d-%d.%d: Instruccion inválida",
				@1.first_line, @1.first_column, @1.last_line,
				@1.last_column); 
				yyerrok;}
	;

instr:	LEE identif ';'	{printf("%d: param %s\n", lin_cod_i, $2->nombre);
						++lin_cod_i;
						printf("call lee,1"); ++lin_cod_i;}
	|	IMPRIME exprar ';'	{	if ($2!=NULL) {
									printf("param %s", $2->nombre);
									printf("call lee,1");
								} else {
									fprintf("%d.%d-%d.%d: Expresion aritmetica no inicializada",
									@2.first_line, @2.first_column, @2.last_line,
									@2.last_column);
								}
							}
	|	exprasig ';'
	|	PARA param HASTA param PASO param '(' instr ')' ';'
	|	SI exprlog ENTONCES instr CASO CONTRARIO instr
	|	'(' instr ')'
	;

exprasig:	identif '=' exprar
		|	identif '=' exprasig
		;

exprar:	identif
	|	numero
	|	exprar '+' exprar
	|	exprar '-' exprar
	|	exprar '*' exprar
	|	exprar '/' exprar	{	if ($3)
									printf("%");
								else {
									fprintf(stderr, "%d.%d-%d.%d: division por cero",
									@3.first_line, @3.first_column,
									@3.last_line, @3.last_column);
								}
							}
	|	'-' numero %prec UMENOS	{printf("t%d = -%d", temp, $2); ++temp;}
	|	'(' exprar ')'
	;
	
exprlog:	exprar RELOP exprar
		|	'(' exprlog ')'
		;

param:	numero		{printf("t%d = %d", temp, $1); ++temp;}
	|	exprasig
	|	'(' param ')'
	;

identif:	ID	{$$=$1->nombre;}
		|	'(' identif ')'
		;

numero:		ENT		{$$=$1;}
		|	FLOT	{$$=$1;}
		|	'(' numero ')'
		;
%%
void yyerror(char *msg) {
	fprintf(stderr, "%s\n", msg);
}

int main() {
	yyparse();
	return 0;
}