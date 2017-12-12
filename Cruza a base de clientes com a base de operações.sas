* Declaração da biblioteca da AluraPlay ;
LIBNAME alura '/folders/myfolders/AluraPlay';

/*
 * AVALIAR QUANTOS JOGOS CADA CLIENTE ALUGOU EM 201709
 */

PROC CONTENTS data=alura.operacoes_201709 varnum;RUN;
PROC CONTENTS data=alura.cadastro_cliente_v3 varnum;RUN;


/* Agrupado a base de operações pelo CPF */

PROC SQL;
	create table contratos_cpf as
	select CPF, count(*) as Quantidade_jogos
	from alura.operacoes_201709
	group by 1
;QUIT;

/* Converter o CPF da base de clientes em CPF raiz */

DATA cad_cli_cpf_raiz;
set alura.cadastro_cliente_v3;

CPF_RAIZ = input(substr(CPF,1,11),COMMAX11.0);

RUN;

/* Ordenar a base de clientes */

PROC SORT
	data=cad_cli_cpf_raiz
	out=cad_cli_cpf_sort
	nodupkey;
	by CPF_RAIZ;
RUN;

PROC CONTENTS data=cad_cli_cpf_sort;RUN;
PROC CONTENTS data=contratos_cpf;RUN;

/* Cruzamento das bases usando um data merge */

DATA cad_cli_jogos;
merge cad_cli_cpf_sort (in=A)
	contratos_cpf
	(rename=(CPF=CPF_RAIZ));
by CPF_RAIZ;
if a;
RUN;

PROC PRINT data=cad_cli_jogos;RUN;
PROC PRINT data=contratos_cpf;RUN;













