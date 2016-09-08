%{
#include "y.tab.h"
%}
letra	[a-zA-Z]
digito	[0-9]
espacs	[ \t\n]+
oparsym	[\*\/\-\+\(\)\;]
numero	([\+\-])?{digito}+(\,{digito}+([eE]{digito}+)?)?
identif	{letra}[{letra}{digito}]{0,2}
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
'<'			{yylval.int = LT; return RELOP;}
'>'			{yylval.int = GT; return RELOP;}
'<='		{yylval.int = LE; return RELOP;}
'>='		{yylval.int = GE; return RELOP;}
'<>'		{yylval.int = NE; return RELOP;}
'=='		{yylval.int = EQ; return RELOP;}
{numero}	{return NUM;}
{identif}	{return ID;}
{espacs}	{;}
%%
int yywrap() {
	return 1;
}