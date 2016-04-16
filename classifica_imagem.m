page_output_immediately (1);
close all;
more off;
clear;
clc;

img_str = "domino";
extensao = ".tiff";
pasta_str = "Camera";
digito = "2";

tipo_bloco = 1;
nome_base = "512";
tamanho_bloco = 512;
if tipo_bloco == 2;
  nome_base = "256";
  tamanho_bloco = 256;
elseif tipo_bloco == 0;
  nome_base = "128";
  tamanho_bloco = 128;
endif

n = 1;
v0 = 0.75;
erro = 1e-11;

metricas_ok = false;
tentativas = 0;

img_str2 = cat(2, img_str, digito);

Img = imread(cat(2, obter_diretorio_imagens(), pasta_str, "/", img_str2, extensao));

%Para testes.
%----------------------------------------------------------------------------------------
Img2 = imread(cat(2, obter_diretorio_imagens(), pasta_str, "/", img_str, extensao));

[Segmentos etiquetas] = comparar_imagens_referencia(Img2, Img, tipo_bloco);
clear Img2;
clear Segmentos;
%----------------------------------------------------------------------------------------

img_str = cria_nome(img_str2, pasta_str, tipo_bloco);

while (~metricas_ok)
  c = 0;
  
  try
    Metricas = computar_metricas(Img, img_str, tipo_bloco);
  catch
    if tentativas < 1
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

resultados_raiz = cat(2, pwd(), "/Resultados/");
if (exist(resultados_raiz) ~= 7)
  [STATUS, MSG, MSGID] = mkdir (resultados_raiz);
  if ~STATUS
    MSG
    MSGID
  endif
endif

diretorio_resultados = cat(2, pwd(), "/Resultados/", img_str, "/");
if (exist(diretorio_resultados) ~= 7)
  [STATUS, MSG, MSGID] = mkdir (diretorio_resultados);
  if ~STATUS
    MSG
    MSGID
  endif
endif

saida = elm(Metricas, nome_base);

etiquetas = etiquetas';

MissClassificationRate_Training = 0;
for i = 1 : size(etiquetas, 2)
    if saida(i)~=etiquetas(i)
        MissClassificationRate_Training=MissClassificationRate_Training+1;
    end
end

acuracia=1-MissClassificationRate_Training/size(etiquetas, 2)

save(cat(2, diretorio_resultados, "dados.mat"), "Metricas", "saida", "etiquetas", "acuracia");

Segmentos = segmentar_imagem(Img, tipo_bloco);

sgms = size(Segmentos, 1);
for i = 1:sgms
  if saida(i) == 1
    x = Segmentos(i,1); y = Segmentos(i, 2);
    Img(x: x+tamanho_bloco-1, y: y+tamanho_bloco-1, 2) = 0;
  endif
endfor

imwrite(Img, cat(2, diretorio_resultados, "resultado.jpg"));

imshow(Img);
  