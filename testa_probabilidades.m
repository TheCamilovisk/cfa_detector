page_output_immediately (1);
close all;
more off;
clear;
clc;

F = imread(cat(2, pwd(), "/teste.tiff"));

F = double(F(:, :, 2));

n = 1;

Coef = cria_matriz_coef(n)

Coef_rot = rot90(Coef, 2)

p_0 = 1/256;

variancias = 0.75;

R = zeros(size(F));

W = zeros(size(F));

R = abs( F .- conv2(F, Coef_rot, 'same') );

den = 1/(variancias * sqrt(2*pi));
a1 = -(R.^2) / (2*(variancias^2));
P = exp(a1) .* den;

W = P ./ (P .+ p_0);

Coef = calcula_coeficientes(F, W, n)