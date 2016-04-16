page_output_immediately (1);
close all;
more off;
clear;
clc;

t_bloco = 0;
inter_n = "plano_cor";

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

load(cat(2, "accuracy_test_", tipo_bloco, ".mat"));

x = 1:100;
table = [x' m_a_teste'];
table = table(5:end, :);

csvwrite (cat(2, inter_n, "_", tipo_bloco, ".csv"), table);
