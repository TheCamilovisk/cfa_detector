page_output_immediately (1);
close all;
more off;
clear;
clc;

str_img = "mesa";
tipo_interpolacao = "Baseada_Gradiente";

I = {0, 0, 0, 0};
Img = carrega_imagem(str_img, tipo_interpolacao, "tiff");
I{1,1} = Img;
I{1,2} = Img(1:256, 1:256, :);
I{1,3} = Img(100:(100+512), 205:(205+512), :);
I{1,4} = Img((end-512):end, (end-256):end, :);

clear Img;

n = 1;
v0 = 0.75;
erro = 1e-8;
Coefs = zeros(2*n+1, 2*n+1, size(I, 2));

for i = 1:size(I, 2)
  F = I{1, i};
  F = double(F(:, :, 2));
  [Coefs(:, :, i) W err variancias erros_max] = algoritmo_em(F, n, v0, erro);
endfor

Coefs