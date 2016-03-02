page_output_immediately (1);
close all;
more off;
clear;
clc;

TrainingData_File = "diabetes_train";

t_bloco = 2;
n_itens_selec = 1;
porcentagem_sel_treinamento = 0.75;

ActivationFunction = "sig";


tipo_bloco = "512";
switch t_bloco
  case {1}
    tipo_bloco = "512";
  case {2}
    tipo_bloco = "256";
  otherwise
    printf("Tamanho de bloco invalido! Utilizando valor padrao: 512 x 512");
    tipo_bloco = "512";
endswitch

ModelPath = cat(2, pwd(), "/", tipo_bloco, "_treinamento.mat");
load(ModelPath);

[t_treinamento a_treinamento] = elm_train(Dados_treinamento, tipo_bloco, 100, ActivationFunction);
etiquetas = Dados_treinamento(:, 1)'
Dados_treinamento = Dados_treinamento(:, 2:size(Dados_treinamento, 2));
output = elm(Dados_treinamento, tipo_bloco)

etiquetas == output