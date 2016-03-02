page_output_immediately (1);
close all;
more off;
clear;
clc;

strs_img = {"garagem", "mesa", "monitor", "rua", "sala"}; % "garagem", "mesa", "monitor", "rua", "sala" // "casa", "passaro", "piao", "piaocaido", "telhado"
tipos_interpolacao = {"Sem_Interpolacao", "Bilinear"}; % "Bilinear", "Bicubica", "Mediana", "Baseada_Gradiente", "Transicao_Saturacao", "Plano_Cor", "Borradas", "Testes", "Sem_Interpolacao"
tipo_referencia = "Sem_Interpolacao"
extensao = ".tiff";
ref_existe = 0;

tipo_bloco = 2;
nome_base = "512";
if tipo_bloco == 2
  nome_base = "256";
elseif tipo_bloco == 0
  nome_base = "128";
endif

Base_dados_em = [];

arquivo = cat(2, obter_diretorio_imagens(), tipo_referencia, "/", nome_base, ".mat");
if (exist(arquivo) == 2)
  printf("Arquivo de referencia existe!\n");
  ref_existe = 1;
  load(arquivo);
  Base_dados_em = Base_dados_em_interpolacao;
  clear Base_dados_em_interpolacao;
  printf("Tamanho inicial da base de dados: %d\n", size(Base_dados_em, 1));
else
  printf("Arquivo de referencia nao existe!\n");
  printf("Tamanho inicial da base de dados: %d\n", size(Base_dados_em, 1));
endif

printf("Tipo do bloco escolhido: %d\n", tipo_bloco);

n = 1;
v0 = 0.75;
erro = 1e-11;

n_imgs = size(strs_img, 2);
n_t_interpolacao = size(tipos_interpolacao, 2);

%Base_dados_em = [];
feito = 0;

for j = 1:n_t_interpolacao

  if strcmp(tipos_interpolacao{1,j}, tipo_referencia) && ref_existe
    continue;
  endif
  
  Base_dados_em_interpolacao = [];
  
  for i = 1:n_imgs
    printf("Verificando a imagem %s do modelo %s...\n ", strs_img{1,i}, tipos_interpolacao{1,j});
    
    I_1 = imread(cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j}, "/", strs_img{1,i}, extensao));
    
    Metricas = [];
    metricas_ok = false;
    tentativas = 0;
    
    while (~metricas_ok)
      c = 0;
      
      try
        Img_alt_nome = cria_nome(strs_img{1,i}, tipos_interpolacao{1,j}, tipo_bloco);
        Metricas = computar_metricas(I_1, Img_alt_nome, tipo_bloco);
      catch
        if tentativas < 20
          tentativas++;
          printf("Erro %d\n", tentativas);
          c = 1;
        else
          rethrow(lasterror);
        endif
      end_try_catch
      
      if c ~= 1
        metricas_ok = true;
      endif
      
    endwhile
    
    if strcmp(tipos_interpolacao{1,j}, tipo_referencia)
      etiquetas = ones(size(Metricas, 1), 1);
    else
      etiquetas = zeros(size(Metricas, 1), 1);
    endif
    
    f = cat(2, etiquetas, Metricas);
    Base_dados_em_interpolacao = cat(1, Base_dados_em_interpolacao, f);
    
    save(cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,j}, "/", nome_base, ".mat"), "Base_dados_em_interpolacao");
    
    printf("Feito!\n");
  endfor
  
  Base_dados_em = cat(1, Base_dados_em, Base_dados_em_interpolacao);
  
endfor

printf("Tamanho final da base de dados: %d\n", size(Base_dados_em, 1));

feito = 1;

save(cat(2, "Helpers/ELM/", nome_base, ".mat"), "Base_dados_em");
save(cat(2, obter_diretorio_imagens(), tipos_interpolacao{1,n_t_interpolacao}, "/", nome_base, ".mat"), "Base_dados_em");
save(cat(2, "Helpers/ELM/controle.mat"), "feito");
    