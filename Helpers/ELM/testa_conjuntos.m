page_output_immediately (1);
close all;
more off;
clear;
clc;

t_bloco = 2;
n_itens_selec = 1;
porcentagem_sel_treinamento = 1;

[Dados_treinamento Dados_teste] = prepara_conj_teste_treinamento(t_bloco, n_itens_selec, porcentagem_sel_treinamento);