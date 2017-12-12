* Declaração da biblioteca da AluraPlay ;
LIBNAME alura '/folders/myfolders/AluraPlay';

/*
 * ANÁLISE DE QUANTOS JOGOS CADA CLIENTE
 * ALUGOU NO QUARTO TRIMESTRE DE 2017
 */

/* Análise das bases de operações */

PROC CONTENTS data=alura.OPERACOES_201710 VARNUM;RUN;
PROC CONTENTS data=alura.OPERACOES_201711 VARNUM;RUN;
PROC CONTENTS data=alura.OPERACOES_201712 VARNUM;RUN;

/* Empilhar as bases do quarto trimestre de 2017 */

PROC SQL;
	create table operacoes_2017T4 as
	select *
	from alura.OPERACOES_201710
	union all
	select *
	from alura.OPERACOES_201711
	union all
	select *
	from alura.OPERACOES_201712
;QUIT;


DATA operacoes_2017T4;
set	alura.OPERACOES_201710
	alura.OPERACOES_201711
	alura.OPERACOES_201712;
RUN;

/* Gera a base com o resultado consolidado
 do quarto trimestre de 2017 */

PROC SQL;
	create table CADASTRO_CLIENTE_JOGOS_2017T4 as
	select a.*,
		b.Total_contratos_2017T4,
		b.Contratos_validos_2017T4
	from alura.cadastro_cliente_v3 as A
	left join (
		select CPF,
			count(*) as Total_contratos_2017T4,
			sum(CASE WHEN DATA_RETORNO-DATA_RETIRADA > 30
					or CUSTO_REPARO > 0
				THEN 0
				ELSE 1
				END) as Contratos_validos_2017T4
		from operacoes_2017T4
		group by CPF
		) as B
	on input(substr(a.CPF,1,11),COMMAX11.0) = b.CPF
;QUIT;


/* Analisar a quantidade de jogos dos clientes
 em cada um dos meses do quarto trimestre 2017 */

PROC SQL;
	create table operacoes_2017T4_consolidada as
	select SAFRA, CPF,
		count(*) as Total_contratos_2017T4,
		sum(CASE WHEN DATA_RETORNO-DATA_RETIRADA > 30
				or CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END) as Contratos_validos_2017T4
	from operacoes_2017T4
	group by 1, 2
;QUIT;


/* Separar cada mês da base de operações consolidada */

DATA operacoes_201710_consolidada
	operacoes_201711_consolidada
	operacoes_201712_consolidada;
set operacoes_2017T4_consolidada;

IF SAFRA = 201710 THEN OUTPUT operacoes_201710_consolidada;ELSE
IF SAFRA = 201711 THEN OUTPUT operacoes_201711_consolidada;ELSE
IF SAFRA = 201712 THEN OUTPUT operacoes_201712_consolidada;

RUN;

/* Cruzamento da base de clientes com as operações de 2017 */

*%LET safra = 201710;

%MACRO cruza_clientes_jogos (safra);

PROC SQL;
	create table CADASTRO_CLIENTE_JOGOS_&safra as
	select a.*,
		b.Total_contratos_2017T4 as Total_contratos_&safra,
		b.Contratos_validos_2017T4 as Contratos_validos_&safra
	from alura.cadastro_cliente_v3 as A
	left join operacoes_&safra._consolidada as B
	on input(substr(a.CPF,1,11),COMMAX11.0) = b.CPF
;QUIT;

%MEND cruza_clientes_jogos;

%CRUZA_CLIENTES_JOGOS(201710);
%CRUZA_CLIENTES_JOGOS(201711);
%CRUZA_CLIENTES_JOGOS(201712);












