page_output_immediately (1);
close all;
more off;
clear;
clc;

strs_img = {"garagem", "mesa", "monitor", "rua", "sala", "arvore", "mangalalt", "veropeso", "pintura"}; % "garagem", "mesa", "monitor", "rua", "sala", "arvore", "mangalalt", "veropeso", "teste", "pintura" // "casa", "passaro", "piao", "piaocaido", "telhado", "domino"
n_imagens = size(strs_img, 2);
tipos_interpolacao = {"Bilinear", "Bicubica", "Mediana", "Baseada_Gradiente",  "Transicao_Saturacao", "Plano_Cor"}; % "Bilinear", "Bicubica", "Mediana", "Baseada_Gradiente",  "Transicao_Saturacao", "Plano_Cor"
n_pastas = size(tipos_interpolacao, 2);
extensao_entrada = ".jpg";
pasta_testes = "Testes";

for i = 1:n_imagens
  printf("Processando a imagem %s ...\n", strs_img{1,i});
  Img = imread(cat(2, obter_diretorio_imagens(), "/", pasta_testes, "/", strs_img{1,i}, extensao_entrada));
  dims = idivide(size(Img), [512 512 1]) .* [512 512 1];
  Img = Img(1:dims(1), 1:dims(2), :);
  
  if strcmp(pasta_testes, "Testes_Camera")
    imwrite(Img, cat(2, obter_diretorio_imagens(), "Camera/", strs_img{1,i}, ".tiff"));
  else
    Img2 = limpa_imagem(Img);
    imwrite(Img2, cat(2, obter_diretorio_imagens(), "Sem_Interpolacao/", strs_img{1,i}, ".tiff"));
    clear Img;
    for j = 1:n_pastas
      printf("Executando interpolacao %s ...... ", tipos_interpolacao{1,j});
      Img3 = reinterpola_imagem(Img2, tipos_interpolacao{1,j});
      imwrite(Img3, cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j},  "/", strs_img{1,i}, ".jpg"), "jpg", 'Quality', 75);
      printf("FEITO!\n");
    endfor
  endif
  
endfor