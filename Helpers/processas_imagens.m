page_output_immediately (1);
close all;
more off;
clear;
clc;

strs_img = {"garagem"}; % "garagem", "mesa", "monitor", "rua", "sala", "teste"
tipos_interpolacao = {"Sem_Interpolacao"}; % , "Bicubica", "Mediana", "Baseada_Gradiente", "Transicao_Saturacao", "Plano_Cor"
extensao = "tiff";
tipo_bloco = 2;
nome_base = "256";

n = 1;
v0 = 0.75;
erro = 1e-11;

n_imgs = size(strs_img, 2);
n_t_interpolacao = size(tipos_interpolacao, 2);

for i = 1:n_imgs
  for j = 1:n_t_interpolacao
    printf("Verificando a imagem %s do modelo %s...\n ", strs_img{1,i}, tipos_interpolacao{1,j});
    
    processamento_ok = false;
    tentativas = 0;
    
    while (~processamento_ok)
      c = 0;
      
      try
        [Coeficientes Ws_vermelho Ws_verde Ws_azul] = processar_imagem(strs_img{1,i}, tipo_bloco, tipos_interpolacao{1,j}, extensao);
      catch
        [MSG, MSGID] = lasterr ()
        if tentativas < 20
          tentativas++;
          printf("Erro %d\n", tentativas);
          c = 1;
        else
          rethrow(lasterror);
        endif
      end_try_catch
      
      if c ~= 1
        processamento_ok = true;
      endif
      
    endwhile
    
    printf("Feito!\n");
  endfor
endfor

    