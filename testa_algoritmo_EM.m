page_output_immediately (1);
close all;
more off;
clear;
clc;

str_img = "teste.tiff";

I = imread(cat(2, pwd(), "/", str_img));

n = 1;
v0 = 2;
erro = 1e-11;

  printf("Verificando a imagem %s... ", str_img);
  F = double(I(:, :, 2));
  [Coef W err variancias erros_max] = algoritmo_em(F, n, v0, erro);
  printf("FEITO!\n");

imshow(uint8(255*W));
