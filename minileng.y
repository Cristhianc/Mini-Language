%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablaSimb.h"
int temp=1;
int lin_cod_i=1;
char val_actual=' ';
void yyerror(char *msj);
%}
%union	{
		union valor_num {
			int ent, cod_lin;
			float flot;
			char nombre[4];
		};
		struct cod_int {
			union valor_num cod_l;
		};
		struct cod_int cod;
		union valor_num num;
		int entero;
}
%token LEE IMPRIME PARA HASTA PASO SI ENTONCES CASO CONTRARIO RELOP
%token <num> ENT FLOT
%token <num> ID
%type <num> identif numero exprar
%type <cod> param
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
									printf("%d: param %d\n", lin_cod_i, $2.ent);
									++lin_cod_i;
									printf("%d: call imprime,1\n", lin_cod_i);
									++lin_cod_i;
								}
								else if ($2.flot != 0 && val_actual == 'f') {
									printf("%d: param %f\n", lin_cod_i, $2.flot);
									++lin_cod_i;
									printf("%d: call imprime,1\n", lin_cod_i);
									++lin_cod_i;
								}
								else if ($2.nombre != NULL && val_actual == 's'){
									printf("%d: param %s\n", lin_cod_i, $2.nombre);
									++lin_cod_i;
									printf("%d: call imprime,1\n");
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

exprar:	identif				{strcpy($$.nombre, $1.nombre);}
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
	|	'-' '(' exprar ')' %prec UMENOS	{ if (val_actual == 'i') {
									sprintf($$.nombre, "t%d", temp);
									val_actual = 's';
									printf("%d: %s = minus %d\n", lin_cod_i, $$.nombre, $3.ent); 
									++lin_cod_i;
									++temp;
								 }
								 else if (val_actual == 'f') {
									sprintf($$.nombre, "t%d", temp);
									val_actual = 's';
									printf("%d: %s = minus %f\n", lin_cod_i, $$.nombre, $3.flot); 
									++lin_cod_i;
									++temp;
								 }
								 else {
									sprintf($$.nombre, "t%d", temp);
									printf("%d: %s = minus %s\n", lin_cod_i, $$.nombre, $3.nombre); 
									++lin_cod_i;
									++temp;
								 }
								}
	|	'-' numero %prec UMENOS	{ if (val_actual == 'i') {
									sprintf($$.nombre, "t%d", temp);
									val_actual = 's';
									printf("%d: %s = minus %d\n", lin_cod_i, $$.nombre, $2.ent); 
									++lin_cod_i;
									++temp;
								 }
								 else {
									sprintf($$.nombre, "t%d", temp);
									val_actual = 's';
									printf("%d: %s = minus %f\n", lin_cod_i, $$.nombre, $2.flot); 
									++lin_cod_i;
									++temp;
								 }
								}
	;
	
exprlog:	exprar RELOP exprar
		;

param:	numero			{ if (val_actual == 'i') {
							sprintf($$.cod_l.nombre , "t%d", temp);
							$$.cod_l.ent = $1.ent;
							$$.cod_l.cod_lin = lin_cod_i;
							printf("%d: %s = %d\n", lin_cod_i, $$.cod_l.nombre, $1.ent);
							++lin_cod_i;
							++temp;
						 }
						 else {
							sprintf($$.cod_l.nombre, "t%d", temp);
							$$.cod_l.flot = $1.flot;
							$$.cod_l.cod_lin = lin_cod_i;
							printf("%d: %s = %f\n", lin_cod_i, $$.cod_l.nombre, $1.flot);
							++lin_cod_i;
							++temp;
						 }
						}
	|	identif '=' exprar	{$$.cod_l.ent=$1.ent;}
	;

identif:	ID	{$$.ent=$1.ent;}
		;

numero:		ENT		{$$.ent=$1.ent; val_actual='i';}
		|	FLOT	{$$.flot=$1.flot; val_actual='f';}
		;
%%
void yyerror(char *msg) {
	fprintf(stderr, "%s\n", msg);
}

int main() {
	/*pos_i = inicTabla();*/
	yyparse();
	return 0;
}
