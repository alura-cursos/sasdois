* Declaração da biblioteca da AluraPlay ;
LIBNAME alura '/folders/myfolders/AluraPlay';

/*
 * GERA OS GRÁFICOS DA ANÁLISE NA BASE DE CADASTRO CLIENTE
 */

/*
 * Criamos as variáveis de Estado e Idade
 * na base de cadastro dos clientes
 */

PROC FORMAT;
	VALUE estados_
		low-09 = "Grande SP"
		10-19  = "Interior SP"
		20-28  = "Rio de Janeiro"
		30-39  = "Minas Gerais"
		80-87  = "Paraná"
		OTHER  = "Demais Estados";
RUN;

DATA alura.CADASTRO_CLIENTE_V3;
set alura.CADASTRO_CLIENTE_V2;

Estado = put(input(substr(CEP,1,2),best.),estados_.);

Idade = intck('YEAR',input(Nascimento,YYMMDD10.),mdy(12,1,2017),'c');

RUN;

/* Gera uma tabela de frequências das variáveis de Estado e Idade */
TITLE "Tabela de clientes por estado e idade";
PROC FREQ
	data=alura.cadastro_cliente_v3;
	table Estado Idade;
RUN;

/* Plota o gráfico da variável Estado */
TITLE "Quantidade de clientes por estado";
PROC SGPLOT
	data=alura.cadastro_cliente_v3;
	vbar Estado / fillattrs=(color=green);
	yaxis label="Número de clientes"
		values=(0 to 35 by 5) grid
		minor minorcount=4;
	*title "Quantidade de clientes por estado";
RUN;
TITLE;

/* Plota o gráfico da variável Idade */
TITLE "Número de clientes por faixas de idade";
PROC SGPLOT
	data=alura.cadastro_cliente_v3;
	histogram Idade / fillattrs=(color=green);
	yaxis grid minor minorcount=9 label="Número de clientes";
	xaxis grid minor minorcount=9 label="Idade (anos)";
RUN;
TITLE;

/* Gera uma análise univariada da Idade, junto com um histograma */
PROC UNIVARIATE
	data=alura.cadastro_cliente_v3;
	var Idade;
	histogram;
RUN;













