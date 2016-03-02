page_output_immediately (1);
close all;
more off;
clear;
clc;

strs_img = {"garagem", "mesa", "monitor", "rua", "sala", "arvore", "mangalalt", "veropeso", "pintura"}; % "garagem", "mesa", "monitor", "rua", "sala", "arvore", "mangalalt", "veropeso", "pintura"
n_imagens = size(strs_img, 2);

tipos_interpolacao = {"Bilinear"}; % "Bilinear", "Bicubica", "Mediana", "Baseada_Gradiente",  "Transicao_Saturacao", "Plano_Cor"
n_pastas = size(tipos_interpolacao, 2);
extensao = "tiff";

percentual_alteracao = 0.3;

tipo_do_bloco = 2;
tamanho_bloco = 512;
if tipo_do_bloco == 2
  tamanho_bloco = 256;
elseif tipo_do_bloco == 0
  tamanho_bloco = 128;
endif

for i = 1:n_imagens
  printf("Processando a imagem %s ...\n", strs_img{1,i});
  
  Img = imread(cat(2, obter_diretorio_imagens(), "Sem_Interpolacao/", strs_img{1,i}, ".", extensao)); % "Sem_Interpolacao" "Borradas"
  tamanho_original = size(Img);
  
  Segmentos = segmentar_imagem(Img, tipo_do_bloco);
  n_blocos = size(Segmentos, 1);
  q_blocos_alterados = round(n_blocos * percentual_alteracao);
  
  for j = 1:n_pastas
    printf("Interpolacao %s ...... ", tipos_interpolacao{1,j});

    Img_alt = imread(cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j},  "/", strs_img{1,i}, ".", extensao));
    Alteracoes = Img_alt;
    
    inds_perms = sort(randperm(n_blocos, q_blocos_alterados));
    
    for k = 1:q_blocos_alterados
    
      ind = inds_perms(k);
      x = Segmentos(ind, 1);
      y = Segmentos(ind, 2);
      
      Alteracoes(x:x+tamanho_bloco-1, y:y+tamanho_bloco-1, :) = zeros(tamanho_bloco, tamanho_bloco, 3);
      
      Img_alt(x:x+tamanho_bloco-1, y:y+tamanho_bloco-1, :) = Img(x:x+tamanho_bloco-1, y:y+tamanho_bloco-1, :);
      
    endfor
    
    imwrite(Img_alt, cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j},  "/", strs_img{1,i}, cat(2, "2", ".", extensao)));
    imwrite(Alteracoes, cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j},  "/", strs_img{1,i}, cat(2, "_alteracoes", ".jpg")));
    save(cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j}, "/", strs_img{1,i}, "_alteracoes.mat"), "inds_perms", "n_blocos");
    
    printf("FEITO!\n");
  endfor
endfor