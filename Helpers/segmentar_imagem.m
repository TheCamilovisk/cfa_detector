% Função de comparacao de imagens de referencia que determina as porcoes da imagem autenticas e modificadas da imagem alterada.
% Retorno:                 segmentos -> matriz que armazenara os limites de cada bloco.
% Parametros:              Imagem -> Matriz representante da imagem a ser segmentada.
%                          tipo_do_bloco -> inidica o tamanho predefinido dos blocos resultantes.
%                                              0 -> blocos de 512x512.
%                                              1 -> blocos de 256x256.

function Segmentos = segmentar_imagem(Imagem, tipo_do_bloco)
%  Inicializaçao.
%----------------------------------------------------------------------------------------------------------
%  Determinacao do tamanho dos blocos.
  tamanho_bloco = [512 512];
  if tipo_do_bloco == 2
    tamanho_bloco(1) = tamanho_bloco(2) = 256;
  elseif tipo_do_bloco == 0
    tamanho_bloco(1) = tamanho_bloco(2) = 128;
  endif
  
%  Array que armazenara os segmentos da imagem.
  Segmentos = 0;
  
%  Salva o tamanho das imagens.
  tamanho_imagem = size(Imagem);
  
%  Indica se ja houve a necessidade da criacao de limite adicional para escaneamento nas colunas.
  teve_adicional_colunas = 0;
  
%  Indica se ja houve a necessidade da criacao de limite adicional para escaneamento nas linhas.
  teve_adicional_linhas = 0;
  
%----------------------------------------------------------------------------------------------------------
%  Fim da inicializaçao.
%  Inicio da segmentacao das imagens.
%----------------------------------------------------------------------------------------------------------
%  Determinacao da quantidade de limites nas colunas.
  n_b_colunas = q_colunas = floor(tamanho_imagem(2) / tamanho_bloco(2));
  teve_adicional_colunas = mod(tamanho_imagem(2), tamanho_bloco(2)) > 0;
  if (teve_adicional_colunas)
    n_b_colunas = q_colunas + 1;
  endif
  
%  Determinacao da quantidade de limites nas linhas.
  n_b_linhas = q_linhas = floor(tamanho_imagem(1) / tamanho_bloco(1));
  teve_adicional_linhas = mod(tamanho_imagem(1), tamanho_bloco(1)) > 0;
  if(teve_adicional_linhas)
    n_b_linhas = q_linhas + 1;
  endif
  
%  Preenche a matriz 'Segmentos' com uma matriz (n° de blocos x 2) de zeros.
  Segmentos = zeros(n_b_linhas * n_b_colunas, 2);
  
%  Preenche a matriz 'Segmentos' com seus valores proprios.
  cont = 1;
  ponto_x = 0;
  ponto_y = 0;
  for l = 0:(n_b_linhas - 1)
    if (l == n_b_linhas - 1) && teve_adicional_linhas
      ponto_x = tamanho_imagem(1) - tamanho_bloco(1) + 1;
    else
      ponto_x = l * tamanho_bloco(1) + 1;
    endif
    for c = 0:(n_b_colunas - 1)
      if (c == n_b_colunas - 1) && teve_adicional_colunas
        ponto_y = tamanho_imagem(2) - tamanho_bloco(2) + 1;
      else
        ponto_y = c * tamanho_bloco(2) + 1;
      endif
%      Armazena o ponto superior esquerda do segmento.
      Segmentos(cont, 1) = ponto_x; Segmentos(cont, 2) = ponto_y;
      cont++;
    endfor
  endfor
%----------------------------------------------------------------------------------------------------------
%  Fim da segmentacao das imagens.
endfunction