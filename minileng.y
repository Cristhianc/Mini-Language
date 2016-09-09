%{
#include <stdio.h>
#include "tablaSimb.h"
int temp=1;
int lin_cod_i=1;
char val_actual=' ';
void yyerror(char *msj);
%}
%union	{
		union const_num{
		char nombre[4];
		int ent;
		float flot;	
		};
		union const_num num;
		int entero;
		simbolo *pos_ini;
		char nom[4];
}
%token LEE IMPRIME PARA HASTA PASO SI ENTONCES CASO CONTRARIO RELOP
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
instrs: instr
	|	instrs instr
	|	error	{fprintf(stderr, "%d.%d-%d.%d: Instruccion inválida",
				@1.first_line, @1.first_column, @1.last_line,
				@1.last_column); 
				yyerrok;}
	;

instr:	LEE identif ';'	{printf("%d: param %s\n", lin_cod_i, $2);
						++lin_cod_i;
						printf("%d: call lee,1\n"); 
						++lin_cod_i;}
	|	IMPRIME exprar ';'	{if ($2.ent != 0 && val_actual == 'i') {
									printf("%d: param %d\n", $2);
									++lin_cod_i;
									printf("%d: call lee,1\n");
									++lin_cod_i;
								}
								else if ($2.flot != 0 && val_actual == 'f') {
									printf("%d: param %f\n", $2);
									++lin_cod_i;
									printf("%d: call lee,1\n");
									++lin_cod_i;
								}
								else if ($2.nombre != NULL && val_actual == 's'){
									printf("%d: param %s\n", $2);
									++lin_cod_i;
									printf("%d: call lee,1\n");
									++lin_cod_i;
								}
								else {
									fprintf(stderr, "%d.%d-%d.%d: Expresion aritmetica no inicializada\n\n",
									@2.first_line, @2.first_column, @2.last_line,
									@2.last_column);
								}
							}
	|	exprasig ';'
	|	PARA param HASTA param PASO param '(' instr ')' ';'
	|	SI exprlog ENTONCES instr CASO CONTRARIO instr
	;

exprasig:	identif '=' exprar
		|	identif '=' exprasig
		;

exprar:	identif				{strcpy($$.nombre, $1);}
	|	numero				{if (val_actual == 'i') $$.ent=$1.ent;
							 else $$.flot=$1.flot;}
	|	/*{sprintf($<nom>$, "t%d", temp); ++temp}*/ exprar '+' exprar {printf("%d: %s = %");}
	|	exprar '-' exprar
	|	exprar '*' exprar
	|	exprar '/' exprar	{	if ($3.ent != 0 && val_actual == 'i') {
								
								}
								else if ($3.flot != 0 && val_actual == 'f') {
								
								}
								else {
									fprintf(stderr, "%d.%d-%d.%d: division por cero",
									@3.first_line, @3.first_column,
									@3.last_line, @3.last_column);
								}
							}
	|	'-' numero %prec UMENOS	{printf("%d: t%d = -%d\n", lin_cod_i, temp, $2); 
								++lin_cod_i;
								++temp;}
	;
	
exprlog:	exprar RELOP exprar
		;

param:	numero			{ if (val_actual == 'i') {
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
	|	identif '=' exprar	{ simbolo *sim_comp;
							  if (val_actual == 'i') {
								printf("%d: %s = %d\n", lin_cod_i, $1, $3);
								++lin_cod_i;
							  }
							  else if (val_actual == 'f') {
								printf("%d: %s = %f\n", lin_cod_i, $1, $3);
								++lin_cod_i;
							  }
							  else {
								sim_comp = buscar(pos_i, $3.nombre);
								if (sim_comp == NULL && val_actual != 't') {
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
	;

identif:	ID	{strcpy($$, $1->nombre); val_actual='s';}
		;

numero:		ENT		{$$.ent=$1.ent; val_actual='i';}
		|	FLOT	{$$.flot=$1.flot; val_actual='f';}
		;
%%
void yyerror(char *msg) {
	fprintf(stderr, "%s\n", msg);
}

int main() {
	pos_i = inicTabla();
	yyparse();
	return 0;
}