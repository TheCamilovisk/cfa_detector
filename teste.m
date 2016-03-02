close all;
page_output_immediately (1);
more off;
close all;
clear;
clc;

str_img = "teste2"; % "garagem", "mesa", "monitor", "rua", "sala", "arvore", "mangalalt", "veropeso", "teste"
tipo_interpolacao = "Plano_Cor"; % "Bilinear", "Bicubica", "Mediana", "Baseada_Gradiente",  "Transicao_Saturacao", "Plano_Cor", "Camera"
extensao = "tiff";
tipo_bloco = 0;
raio = 2;
switch tipo_bloco
  case {512}
    raio = 5;
endswitch

I = imread(cat(2, pwd(), "/Imagens/", tipo_interpolacao, "/", str_img, ".", extensao));

[Coeficientes Fs_vermelho Fs_verde Fs_azul] = processar_imagem(I, cat(2, str_img, "_", tipo_interpolacao, "_"), tipo_bloco);

%----------------------------------------------------------------------------------------------------

tamanho_ffts = size(Fs_vermelho, 1);
n_ffts = size(Fs_vermelho, 3);

Mascaras = repmat(cria_mascara(tamanho_ffts, raio, 1), [1 1 n_ffts]);
Mascaras2 = repmat(cria_mascara(tamanho_ffts, raio, 2), [1 1 n_ffts]);

Fs_vermelho_amostrado = Fs_vermelho .* Mascaras;
Fs_verde_amostrado = Fs_verde .* Mascaras2;
Fs_azul_amostrado = Fs_azul .* Mascaras;

Energias_totais_vermelho = squeeze(sum(sum(Fs_vermelho)));
Energias_totais_verde = squeeze(sum(sum(Fs_verde)));
Energias_totais_azul = squeeze(sum(sum(Fs_azul)));

Energias_amostradas_vermelho = squeeze(sum(sum(Fs_vermelho_amostrado)));
Energias_amostradas_verde = squeeze(sum(sum(Fs_verde_amostrado)));
Energias_amostradas_azul = squeeze(sum(sum(Fs_azul_amostrado)));

e_vermelho = Energias_totais_vermelho ./ max(Energias_totais_vermelho);
e_verde = Energias_totais_verde ./ max(Energias_totais_verde);
e_azul = Energias_totais_azul ./ max(Energias_totais_azul);

figure;
stem(e_vermelho, "r");
legend("Energia total amostrada");
title("Vermelho");
figure;
stem(e_verde, "g");
legend("Energia total amostrada");
title("Verde");
figure;
stem(e_azul, "b");
legend("Energia total amostrada");
title("Azul");

p_vermelho = Energias_amostradas_vermelho ./ Energias_totais_vermelho;
p_verde = Energias_amostradas_verde ./ Energias_totais_verde;
p_azul = Energias_amostradas_azul ./ Energias_totais_azul;

p_vermelho = p_vermelho ./ max(p_vermelho);
p_verde = p_verde ./ max(p_verde);
p_azul = p_azul ./ max(p_azul);

figure;
stem(p_vermelho, "r");
legend("Representatividade");
title("Vermelho");
figure;
stem(p_verde, "g");
legend("Representatividade");
title("Verde");
figure;
stem(p_azul, "b");
legend("Representatividade");
title("Azul");

%----------------------------------------------------------------------------------------------------

dims = size(Fs_vermelho);

Vecs_fs_vermelho = zeros(dims(1) * dims(2), dims(3));
Vecs_fs_verde = zeros(dims(1) * dims(2), dims(3));
Vecs_fs_azul= zeros(dims(1) * dims(2), dims(3));

for i = 1:dims(3)
  Vecs_fs_vermelho(:, i) = vec(Fs_vermelho(:, :, i));
  Vecs_fs_vermelho(:, i) = Vecs_fs_vermelho(:, i) / max(Vecs_fs_vermelho(:, i));
  
  Vecs_fs_verde(:, i) = vec(Fs_verde(:, :, i));
  Vecs_fs_verde(:, i) = Vecs_fs_verde(:, i) / max(Vecs_fs_verde(:, i));
  
  Vecs_fs_azul(:, i) = vec(Fs_azul(:, :, i));
  Vecs_fs_azul(:, i) = Vecs_fs_azul(:, i) / max(Vecs_fs_azul(:, i));
endfor

Vars_fs_vermelho = var(Vecs_fs_vermelho);
Vars_fs_verde = var(Vecs_fs_verde);
Vars_fs_azul = var(Vecs_fs_azul);

figure;
stem(Vars_fs_vermelho', "r");
legend("Variancias");
title("Vermelho");
figure;
stem(Vars_fs_verde', "g");
legend("Variancias");
title("Verde");
figure;
stem(Vars_fs_azul', "b");
legend("Variancias");
title("Azul");

%----------------------------------------------------------------------------------------------------

%Médias

Me_fs_vermelho = mean(Vecs_fs_vermelho);
Me_fs_verde = mean(Vecs_fs_verde);
Me_fs_azul = mean(Vecs_fs_azul);

figure;
stem(Me_fs_vermelho', "r");
legend("Medias");
title("Vermelho");
figure;
stem(Me_fs_verde', "g");
legend("Medias");
title("Verde");
figure;
stem(Me_fs_azul', "b");
legend("Medias");
title("Azul");

%----------------------------------------------------------------------------------------------------
%
%dims = size(Fs_vermelho);
%
%Vecs_fs_vermelho = zeros(dims(1) * dims(2), dims(3));
%Vecs_fs_verde = zeros(dims(1) * dims(2), dims(3));
%Vecs_fs_azul= zeros(dims(1) * dims(2), dims(3));
%
%Vecs_fs_verde = zeros(dims(1) * dims(2), dims(3));
%Vecs_fs_azul= zeros(dims(1) * dims(2), dims(3));
%
%for i = 1:dims(3)
%  Vecs_fs_vermelho(:, i) = vec(Fs_vermelho(:, :, i));
%  Vecs_fs_vermelho(:, i) = Vecs_fs_vermelho(:, i) / max(Vecs_fs_vermelho(:, i));
%  
%  Vecs_fs_verde(:, i) = vec(Fs_verde(:, :, i));
%  Vecs_fs_verde(:, i) = Vecs_fs_verde(:, i) / max(Vecs_fs_verde(:, i));
%  
%  Vecs_fs_azul(:, i) = vec(Fs_azul(:, :, i));
%  Vecs_fs_azul(:, i) = Vecs_fs_azul(:, i) / max(Vecs_fs_azul(:, i));
%endfor
%
%Stds_fs_vermelho = std(Vecs_fs_vermelho);
%Stds_fs_verde = std(Vecs_fs_verde);
%Stds_fs_azul = std(Vecs_fs_azul);
%
%figure;
%stem(Stds_fs_vermelho', "r");
%legend("Devios padroes");
%title("Vermelho");
%figure;
%stem(Stds_fs_verde', "g");
%legend("Devios padroes");
%title("Verde");
%figure;
%stem(Stds_fs_azul', "b");
%legend("Devios padroes");
%title("Azul");
