page_output_immediately (1);
close all;
more off;
clear;
clc;

t_bloco = 1;
n_itens_selec = 1;
porcentagem_sel_treinamento = 0.8;

ActivationFunction = "sig";

n_neuronios_inicial = 1;
n_neuronios_final = 100;
n_neuronios_passo = 1;

tipo_bloco = "512";
switch t_bloco
  case {1}
    tipo_bloco = "512";
  case {2}
    tipo_bloco = "256";
  case {0}
    tipo_bloco = "128";
  otherwise
    printf("Tamanho de bloco invalido! Utilizando valor padrao: 512 x 512");
    tipo_bloco = "512";
endswitch

arquivo_dados = cat(2, tipo_bloco, ".mat")
load(arquivo_dados);

printf("Numero de neuronios inicial - %d\nNumero de neuronios final - %d\nPasso - %d\n", n_neuronios_inicial, n_neuronios_final, n_neuronios_passo);

clear Base_dados_em;

iteracoes = 20;

m_t_teste = [];
m_a_teste = [];
m_t_treinamento = [];
m_a_treinamento = [];

cont = 0;

x = n_neuronios_inicial:n_neuronios_passo:n_neuronios_final;

for n = x;

  printf("Analise para %d neuronios.\n", n);
  cont++;
  
  t_teste = [];
  a_teste = [];
  t_treinamento = [];
  a_treinamento = [];
  
  for k = 1:iteracoes
    printf("Interacao - %d\n", k);
    [Dados_treinamento Dados_teste] = prepara_conj_teste_treinamento(t_bloco, n_itens_selec, porcentagem_sel_treinamento);
    [t_treinamento(k),a_treinamento(k)] = elm_train(Dados_treinamento, tipo_bloco, n, ActivationFunction);
    [t_teste(k), a_teste(k)] = elm_predict(Dados_teste, tipo_bloco);
  endfor
  
  m_t_treinamento(cont) = mean(t_treinamento); m_a_treinamento(cont) = mean(a_treinamento);
  m_t_teste(cont) = mean(t_teste); m_a_teste(cont) = mean(a_teste);
endfor
clear ActivationFunction;
clear n_neuronios_inicial;
clear a_teste;
clear a_treinamento;
clear t_teste;
clear t_treinamento;
clear n;
clear k;

[m_a_treinamento_sorted inds_m_a_treinamento_sorted] = sort(m_a_treinamento);
[m_a_teste_sorted inds_m_a_teste_sorted] = sort(m_a_teste);

copyfile (cat(2, "elm_model_", tipo_bloco, ".mat"), "../../");

save(cat(2, "accuracy_train_", tipo_bloco, ".mat"), "m_a_treinamento");
save(cat(2, "accuracy_test_", tipo_bloco, ".mat"), "m_a_teste");

figure('Position', [0, 0, 210, 110]); plot(x, m_a_treinamento);
title (cat(2, "Treinamento para blocos de ", tipo_bloco));
xlabel ("Neuronios");
ylabel ("Precisao");
axis([5 n_neuronios_final min(m_a_treinamento(5:end))-0.01 1.01]);
figure('Position', [0, 0, 210, 110]); plot(x, m_a_teste);
title (cat(2, "Testes para blocos de ", tipo_bloco));
xlabel ("Neuronios");
ylabel ("Precisao");
axis([5 n_neuronios_final min(m_a_teste(5:end))-0.01 1.01]);
