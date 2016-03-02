page_output_immediately (1);
close all;
more off;
clear;
clc;

Imagem = imread(cat(2, pwd(), "/Imagens/Bilinear/garagem.tiff"));
Segmentos = segmentar_imagem(Imagem, 2);

i_seg = 1;
x = Segmentos(i_seg, 1); y = Segmentos(i_seg, 2);
Bloco = Imagem(x: x+256-1, y: y+256-1, :);
figure;
imshow(Bloco);