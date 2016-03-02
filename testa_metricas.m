page_output_immediately (1);
close all;
more off;
clear;
clc;

tipo_interpolacao = "Bilinear";
str1 = "garagem";
str2 = "garagem2";
extensao = "tiff";
tipo_bloco = 2;

I_1 = imread(cat(2, obter_diretorio_imagens(), "/", tipo_interpolacao, "/", str1, ".tiff"));
I_2 = imread(cat(2, obter_diretorio_imagens(), "/", tipo_interpolacao, "/", str2, ".tiff"));
    
[es_o sims_o maxs_o medianas_o] = computar_metricas(I_1, str1, tipo_bloco);

[es_a sims_a maxs_a medianas_a] = computar_metricas(I_2, str2, tipo_bloco);

caminho_arquivo_teste = cat(2, obter_diretorio_testes(), str1, "_", str2, "_", tipo_interpolacao, "_", num2str(tipo_bloco), ".mat");
save(caminho_arquivo_teste, "es_o", "sims_o", "maxs_o", "medianas_o", "es_a", "sims_a", "maxs_a", "medianas_a");

figure;
semilogy(sims_o(:, 2), "og");
hold on;
semilogy(sims_a(:, 2), "xg");
hold off;
title("Similaridades");

figure;
semilogy(medianas_o(:, 2), "og");
hold on;
semilogy(medianas_a(:, 2), "xg");
hold off;
title("Medianas");

figure;
semilogy(maxs_o(:, 2), "og");
hold on;
semilogy(maxs_a(:, 2), "xg");
hold off;
title("Maximos");

figure;
plot(es_o(:, 2), "og");
hold on;
plot(es_a(:, 2), "xg");
hold off;
title("Energias");