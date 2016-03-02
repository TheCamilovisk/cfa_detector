% Função de comparacao de imagens de referencia que determina as porcoes da imagem autenticas e modificadas da imagem alterada.
% Retorno:                 segmentos -> matriz multi-dimensional (numero de blocos X 4) que armazenara os limites de cada bloco.
%                                          1° linha -> limites das linhas do bloco.
%                                          2° linhas -> limites das colunas dos blocos.
%                                          dimensao 'z' -> corresponde ao bloco.
%                          etiquetas -> indica se o bloco e alterado ou inalterado.
%                                          0 -> inalterado.
%                                          1 -> alterado.
% Parametros:              str_imagens_de_referencia -> String das imagens de referencia para a formacao dos blocos
%                                                       Serao tomadas duas imagens de referencia (original e alterada). A diferenca de valores de pixels correspondentes em cada imagem determinara se o bloco e original ou nao.
%                                                       diferenca == 0 -> nao ouveram alteracoes.
%                                                       diferenca > 0 -> houveram alteracoes.
%                          tipo_de_interpolacao_imagem -> Pasta do tipo de interpolacao das imagens de referencia.
%                          tipo_do_bloco -> inidica o tamanho predefinido dos blocos resultantes.
%                                              0 -> blocos de 512x512.
%                                              1 -> blocos de 256x256.

function [Segmentos etiquetas] = comparar_imagens_referencia(Img_original, Img_alterada, tipo_do_bloco)
  dim1 = size(Img_original);
  dim2 = size(Img_alterada);
  assert(dim1(1) == dim2(1) && dim1(2) == dim2(2) && dim1(3) == dim2(3), "Imagens nao tem as mesmas dimensoes\n");
  
%  Inicializacao.
%----------------------------------------------------------------------------------------------------------

%  Determinacao do tamanho dos blocos.
  tamanho_bloco = [512 512];
  if tipo_do_bloco == 2
    tamanho_bloco(1) = tamanho_bloco(2) = 256;
  elseif tipo_do_bloco == 0
    tamanho_bloco(1) = tamanho_bloco(2) = 128;
  endif
  
%  Array que armazenara os segmentos da imagem.
  Segmentos = [];
  
%  Array que armazenara os as etiquetas dos blocos.
  etiquetas = [];
  
%----------------------------------------------------------------------------------------------------------
%  Fim da inicializaçao.
%  Inicio da comparacao.
%----------------------------------------------------------------------------------------------------------
%  Segmentacao da imagem de referencia.
  Segmentos = segmentar_imagem(Img_original, tipo_do_bloco);
  
%  Verifica o numero de segmentos.
  n_segmentos = size(Segmentos, 1);
  
%  Preenche o vetor 'etiquetas' com um vetor de tamanho (n° de blocos) de zeros.
  etiquetas = zeros(n_segmentos, 1);
  
%  Verifica se ha diferencas entre a soma dos pixels das duas porcoes. Se houver, a porcao e identificada como alterada.
  for seg = 1:n_segmentos
    x = Segmentos(seg, 1); y = Segmentos(seg, 2);
    etiquetas(seg) = sum(sum(sum(
                                  double(Img_original(x: x+tamanho_bloco(1)-1, y: y+tamanho_bloco(2)-1, :)) -
                                  double(Img_alterada(x: x+tamanho_bloco(1)-1, y: y+tamanho_bloco(2)-1, :))
                                    ))) != 0;
  endfor
%----------------------------------------------------------------------------------------------------------
%  Fim da comparacao.
endfunction