%{
#include <stdio.h>
#include <math.h>
#include "tablaSimb.h"

simbolo *pos_i;
int temp=1;
int lin_cod_i=1;
char val_actual=' ';
union numero {
	int ent;
	float flot;
	char *nombre;
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
%type <num> exprar
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
						printf("%d: call lee,1\n"); 
						++lin_cod_i;}
	|	IMPRIME exprar ';'	{	if ($2!=NULL) {
									if (val_actual=='i') {
										printf("%d: param %d\n", $2);
										++lin_cod_i;
									}
									else if (val_actual=='f') {
										printf("%d: param %f\n", $2);
										++lin_cod_i;
									else {
										printf("%d: param %s\n", $2);
										++lin_cod_i;
									}
									printf("%d: call lee,1\n");
									++lin_cod_i;
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

exprar:	identif				{$$=$1;}
	|	numero				{$$=$1;}
	|	{printf("%d: t%d = ", lin_cod_i, temp); strcpy()} exprar '+' exprar
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
	|	'-' numero %prec UMENOS	{printf("%d: t%d = -%d\n", lin_cod_i, temp, $2); 
								++lin_cod_i;
								++temp;}
	|	'(' exprar ')'
	;
	
exprlog:	exprar RELOP exprar
		|	'(' exprlog ')'
		;

param:	numero			{ if (val_actual=='i') {
							printf("%d: t%d = %d\n", lin_cod_i, temp, $1);
							++lin_cod_i;
							++temp;
						 }
						 else {
							printf("%d: t%d = %f\n", lin_cod_i, temp, $1);
							++lin_cod_i;
							++temp;
						 }
						}
	|	identif '=' exprar	{ simbolo sim_comp;
							  if (val_actual=='i') {
								printf("%d: %s = %d\n", lin_cod_i, $1, $3);
								++lin_cod_i;
							  }
							  else if (val_actual=='f') {
								printf("%d: %s = %f\n", lin_cod_i, $1, $3);
								++lin_cod_i;
							  }
							  else {
								sim_comp = buscar(pos_ini, $3);
								if (sim_comp==NULL && val_actual!='t') {
									fprintf(stderr, "%d.%d-%d.%d: Variable %s no inicializada",
									@3.first_line, @3.first_column,
									@3.last_line, @3.last_column, $3);
								}
								else {
									printf("%d: %s = %s\n", lin_cod_i, $1, $3);
									++lin_cod_i;
								}
							  }
							}
	|	'(' param ')'
	;

identif:	ID	{strcpy($$, $1->nombre); val_actual='s';}
		|	'(' identif ')'
		;

numero:		ENT		{$$.ent=$1.ent; val_actual='i';}
		|	FLOT	{$$.flot=$1.flot; val_actual='f';}
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