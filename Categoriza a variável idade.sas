* Declaração da biblioteca da AluraPlay ;
LIBNAME alura '/folders/myfolders/AluraPlay';


/*
 * CLASSIFICAÇÃO DA VARIÁVEL DE IDADE
 */

/* Cria uma variável que classifica a Idade em 5 faixas */

PROC RANK
	data=alura.cadastro_cliente_v3
	out=base_ranks
	groups=5;
	var Idade;
	ranks Faixa_Idade;
RUN;

PROC FREQ
	data=base_ranks;
	table Faixa_Idade;
RUN;

/* Ordena a base com os ranks */

PROC SORT
	data=base_ranks;
	by Faixa_idade;
RUN;
	
/* PROC UNIVARIATE */
/* 	data=base_ranks; */
/* 	var Idade; */
/* 	by Faixa_Idade; */
/* RUN; */

/* PROC MEANS */
/* 	data=base_ranks noprint; */
/* 	var Idade; */
/* 	by Faixa_Idade; */
/* 	output out=base_faixas_idade */
/* 		(drop=_TYPE_ _FREQ_) */
/* 		N=Quantidade */
/* 		MIN=Minimo */
/* 		MAX=Maximo; */
/* RUN; */

/* Sumariza a base pelas faixas de idade usando o SUMMARY */

PROC SUMMARY
	data=base_ranks;
	var Idade;
	by Faixa_Idade;
	output out=base_faixas_idade
		(drop=_TYPE_ _FREQ_)
		N=Quantidade
		MIN=Minimo
		MAX=Maximo;
RUN;

/* Sumariza a base pelas faixas de idade usando o SQL */

PROC SQL;
	create table alura.FAIXAS_IDADE as
	select Faixa_Idade label="Faixas de Idade",
		count(*) as Quantidade label="Quantidade de clientes",
		min(Idade) as Minimo label="Mínimo da Idade na faixa",
		max(Idade) as Maximo label="Máximo da Idade na faixa"
	from base_ranks
	group by Faixa_Idade
;QUIT;





















