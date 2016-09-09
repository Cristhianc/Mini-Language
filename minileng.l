%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#define LT 301
#define GT 302
#define LE 303
#define GE 304
#define EQ 305
#define NE 306
%}
letra	[a-zA-Z]
digito	[0-9]
espacs	[ \t\n]+
oparsym	[\*\/\-\+\(\)\;]
num_int	([\+\-])?({digito}){1,4}
num_float ([\+\-])?{digito}+\,{digito}+([eE]{digito}+)?
identif	{letra}({letra}|{digito}){0,2}
%%
{oparsym}	{return yytext[0];}
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
{num_float}	{yylval.num.flot = atof(yytext); return FLOT;}
{identif}	/*{yylval.pos_ini = buscar(pos_i, yytext); 
			if (yylval.pos_ini == NULL) {
				yylval.pos_ini = (simbolo *) malloc(sizeof(simbolo));
				strcpy(yylval.pos_ini->nombre, yytext);
				yylval.pos_ini->val.ent=0;
				insertar(&pos_i, yylval.pos_ini);
			}
			return ID;}*/
{espacs}	{;}
%%
int yywrap() {
	return 1;
}