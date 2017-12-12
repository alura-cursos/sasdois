* Declaração da biblioteca da AluraPlay ;
LIBNAME alura '/folders/myfolders/AluraPlay';

/*
 * CALCULA A IDADE DOS CLIENTES
 */

/* Checa a base de clientes V2 */
PROC CONTENTS data=alura.cadastro_cliente_v2;RUN;

/* Calcula a idade do cliente */
DATA cad_cli_idade;
set alura.cadastro_cliente_v2;

*data_nascimento = input(nascimento,YYMMDD10.);

*hoje = mdy(12,1,2017);

*idade = int((hoje-data_nascimento)/365);

*idade1 = intck('YEAR',data_nascimento,hoje);

Idade = intck('YEAR',input(nascimento,YYMMDD10.),mdy(12,1,2017),'c');

*FORMAT data_nascimento DDMMYY10. hoje DDMMYY10.;

*if idade1 ~= idade2;

RUN;

/* Imprime a base */
PROC PRINT data=cad_cli_idade;RUN;

/* 
 * Ano = Year
 * Mês = Month
 * Dia = Day
 */


