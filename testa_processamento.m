page_output_immediately (1);
close all;
more off;
clear;
clc;

str_img = "garagem";
tipo_interpolacao = "Plano_Cor";
extensao = "tiff";
tipo_bloco = 2;

str_img
tipo_interpolacao

I = imread(cat(2, pwd(), "/Imagens/", tipo_interpolacao, "/", str_img, ".", extensao));

processar_imagem(I, cat(2, str_img, "_", tipo_interpolacao), tipo_bloco);
