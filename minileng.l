%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "tablaSimb.h"
#define LT 301
#define GT 302
#define LE 303
#define GE 304
#define EQ 305
#define NE 306

simbolo *simbol;
simbolo *p_i;
%}
letra	[a-zA-Z]
digito	[0-9]
espacs	[ \t\n]+
oparsym	[\*\/\-\+\(\)\;]
num_int	({digito}){1,4}
num_float {digito}+\,{digito}+([eE]{digito}+)?
identif	{letra}({letra}|{digito}){0,2}
%%
"lee"		{return LEE;}
"imprime"	{return IMPRIME;}
"para"		{return PARA;}
"hasta"		{return HASTA;}
"paso"		{return PASO;}
"si"		{return SI;}
"entonces"	{return ENTONCES;}
"caso"		{return CASO;}
"contrario"	{return CONTRARIO;}
'<'			{yylval.entero = LT; return RELOP;}
'>'			{yylval.entero = GT; return RELOP;}
'<='		{yylval.entero = LE; return RELOP;}
'>='		{yylval.entero = GE; return RELOP;}
'<>'		{yylval.entero = NE; return RELOP;}
'=='		{yylval.entero = EQ; return RELOP;}
{num_int}	{yylval.num.ent = atoi(yytext); return ENT;}
{oparsym}	{return yytext[0];}
{num_float}	{ int i; 
			for (i=0; i < yyleng; i++)
				if (yytext[i] == ',') yytext[i]='.';
			yylval.num.flot = atof(yytext); return FLOT;}
{identif}	{simbol = buscar(p_i, yytext); 
			if (simbol == NULL) {
				simbol = (simbolo *) malloc(sizeof(simbolo));
				strcpy(simbol->nombre, yytext);
				simbol->val.ent=0;
				insertar(&p_i, simbol);
			}
			return ID;}
{espacs}	{;}
%%
int yywrap() {
	return 1;
}