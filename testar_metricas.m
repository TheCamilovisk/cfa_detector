page_output_immediately (1);
close all;
more off;
clear;
clc;

str_img = "mesa2";
tipo_interpolacao = "Bilinear";
extensao = "tiff";
tipo_bloco = 2;

I = imread(cat(2, pwd(), "/Imagens/", tipo_interpolacao, "/", str_img, ".", extensao));

Metricas = computar_metricas(I, str_img, tipo_bloco);

figure;
stem(Metricas(:, 1), "r");
legend("Representatividade");
title("Vermelho");
figure;
stem(Metricas(:, 2), "g");
legend("Representatividade");
title("Verde");
figure;
stem(Metricas(:, 3), "b");
legend("Representatividade");
title("Azul");
