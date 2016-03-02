more off;
close all;
clear;
clc;

str_img = "garagem";
tipo_interpolacao = "Bilinear";

I_1 = imread(cat(2, obter_diretorio_imagens(), "/", tipo_interpolacao, "/", str_img, ".tiff"));
I_2 = imread(cat(2, obter_diretorio_imagens(), "/", tipo_interpolacao, "/", str_img, "2.tiff"));

[Segmentos etiquetas] = comparar_imagens_referencia(I_1, I_2, 2);

ind1 = find(etiquetas == 1)
ind2 = find(etiquetas == 0)