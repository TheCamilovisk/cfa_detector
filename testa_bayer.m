page_output_immediately (1);
close all;
more off;
clear;
clc;

I = carrega_imagem("garagem", "Bilinear");
B = bayer(I);
imshow(B);