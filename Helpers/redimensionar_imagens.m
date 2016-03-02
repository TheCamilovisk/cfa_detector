page_output_immediately (1);
close all;
more off;
clear;
clc;

strs_img = {"forest", "garagem", "mesa", "Sophie", "teste"};
pasta = "Testes";

for i = 1:size(strs_img, 2)
  printf("Redimensionando a imagem %s...\n", strs_img{1,i});
  I = carrega_imagem(strs_img{1,i}, pasta, "jpg");
  I = I(1:1456, :, :);
  salva_imagem_teste(I, strs_img{1,i}, pasta, "jpg");
endfor