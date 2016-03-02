function [Coeficientes Fs_vermelho Fs_verde Fs_azul] = processar_imagem(I, str_img, tipo_do_bloco = 1)
%  Inicializaçao.
%----------------------------------------------------------------------------------------------------------
%  Cria uma copia dos dados da imagem e os transforma para double se necessario.
  Img = I;
  if ~strcmp(class(I), "double")
    Img = double(Img);
  endif
  
  
  printf("Diretorio de resultados da imagem: %s ...\n", str_img);
  
%  Variavel utilizada para armazenar os coeficientes de interpolacao estimados de cada canal de cor da imagem.
  Coeficientes = zeros(3, 3, 3);
  
%  Variaveis utilizadas para armazenar as os mapas de magnitude das transformadas de Fourier dos mapas de probabilidades de cada canal.
  Fs_vermelho = [];
  Fs_verde = [];
  Fs_azul = [];
  
%  Verifica o tipo de bloco utilizado.
  tamanho_bloco = 512;
  if tipo_do_bloco == 2;
    tamanho_bloco = 256;
  elseif tipo_do_bloco == 0
    tamanho_bloco = 128;
  endif
  
%  Diretorio de testes da image.
  diretorio_testes = cat(2, obter_diretorio_testes(), str_img, "/");
  if (exist(diretorio_testes) ~= 7)
    [STATUS, MSG, MSGID] = mkdir (diretorio_testes);
    if ~STATUS
      MSG
      MSGID
    endif
  endif
  
%  Segmentacao da imagem.
  Pontos_bloco = segmentar_imagem(Img, tipo_do_bloco);
  printf("Foram criados %d blocos...\n", size(Pontos_bloco, 1));
  
%  Salva todos as informacoes dos blocos na pasta raiz de testes da imagem.
  caminho_dados_segmentacao = cat(2, diretorio_testes, "dados_segmentacao.mat");
  save(caminho_dados_segmentacao, "Pontos_bloco");
  
%  Ordem da matriz de coeficientes que será usada no algoritmo.
	n = 1;
  
%  Valor inicial da variãncia.
	variancia_0 = 0.75;
  
%  Tolerância do erro.
	erro_alvo = 1e-6;
  
%----------------------------------------------------------------------------------------------------------
%  Fim da inicializaçao.

%  Inicio do processamento da imagem.
%----------------------------------------------------------------------------------------------------------
%  Executa o algoritmo EM para cada canal de cor.
  for canal = 1:3
    str_canal = "";
    switch canal
    case {1}
      str_canal = "vermelho";
    case {2}
      str_canal = "verde";
    case {3}
      str_canal = "azul";
    endswitch
    
%    Algoritmo EM.
%##########################################################################################################

%	   Matriz que armazenará os mapas de probabilidades.
    Mapa_probabilidades = zeros([size(Img,1) size(Img,2)]);
    
%    Matriz que armazenara os coeficientes do modelo de interpolacao estimado.
    Coefs = zeros(2*n+1, 2*n+1);
    
%    Vetor que armazanar os indicadores de ocorrencia de erro do algoritmo.
    erro_interpolacao = 0;
    
%    Lista que armazenara o vetor de variancia obtido em cada execucao do algoritmo.
    variancias = [];
    
%    Lista que armazenara o vetor de erros maximos obtidos em cada execucao do algoritmo.
    erros_max = [];
    
    printf("processando o canal %s...\n", str_canal);
    
%    Algoritmo Em.
    [Coefs Mapa_probabilidades P_gaussiana erro_interpolacao variancias erros_max] = algoritmo_em (Img(:, :, canal), n, variancia_0, erro_alvo);
    
%    Salva os Coeficientes de interpolacao estimados.
    Coeficientes(:, :, canal) = Coefs;
    
%    Salva todos os dados importantes na pasta raiz de testes da imagem.
    caminho_dados_em = cat(2, diretorio_testes, "dados_em_", str_canal, ".mat");
    save(caminho_dados_em, "Coefs", "Mapa_probabilidades", "P_gaussiana", "erro_interpolacao", "variancias", "erros_max");
    clear Coefs;
    clear P_gaussiana;
    clear erro_interpolacao;
    clear variancias;
    clear erros_max;
    
%    Salva a imagem do mapa de probabilidades.
    caminho_mapa_probabilidades = cat(2, diretorio_testes, "probabilidades_", str_canal, ".tiff");
    imwrite(255*uint8(Mapa_probabilidades), caminho_mapa_probabilidades);
    
%##########################################################################################################

%    Inicio do escaneamento das janelas.
%##########################################################################################################

    for bl_i = 1:size(Pontos_bloco, 1)
    printf("Analizando o bloco %d...\n", bl_i);
%      Recupera o ponto superior esquerdo de cada bloco.
      x = Pontos_bloco(bl_i, 1); y = Pontos_bloco(bl_i, 2);
      
%      Cria a pasta do bloco.
      caminho_pasta_bloco = cat(2, diretorio_testes, num2str(bl_i), "/");
      if (exist(caminho_pasta_bloco) ~= 7)
        [STATUS, MSG, MSGID] = mkdir (caminho_pasta_bloco);
        if ~STATUS
          MSG
          MSGID
        endif
      endif
      
%      Coleta dos dados do bloco.
      Janela = Img(x: x+tamanho_bloco-1, y: y+tamanho_bloco-1, :);
      caminho_janela = cat(2, caminho_pasta_bloco, "janela.tiff");
      if (exist(caminho_janela) ~= 2)
        imwrite(uint8(Janela), caminho_janela);
        caminho_dados_janela = cat(2, caminho_pasta_bloco, "janela.mat");
        save(caminho_dados_janela, "Janela");
      endif
      
      Janela_probabilidades = Mapa_probabilidades(x: x+tamanho_bloco-1, y: y+tamanho_bloco-1, :);
      caminho_janela_probabilidades = cat(2, caminho_pasta_bloco, "probabilidades_", str_canal, ".tiff");
      imwrite(255*uint8(Janela_probabilidades), caminho_janela_probabilidades);
      
%      Obtem o mapa de Fourier da janela de probabilidades.
      Mapa_fft_magnitude = fourier_magnitude(Janela_probabilidades);
      
%      Salva os mapa de Fourier da janela de acordo com o canal analizado.
      switch canal
      case {1}
        Fs_vermelho(:, :, bl_i) = Mapa_fft_magnitude;
      case {2}
        Fs_verde(:, :, bl_i) = Mapa_fft_magnitude;
      case {3}
        Fs_azul(:, :, bl_i) = Mapa_fft_magnitude;
      endswitch
      
      Mapa_fft_magnitude_display = fourier_magnitude_display(Janela_probabilidades);
      caminho_mapa_fft_bloco = cat(2, caminho_pasta_bloco, "fft_magnitude_", str_canal, ".tiff");
      imwrite(uint8(Mapa_fft_magnitude_display), caminho_mapa_fft_bloco);
      caminho_dados_bloco = cat(2, caminho_pasta_bloco, "dados_bloco_", str_canal, ".mat");
      
%      Salva os dados importantes sobre os mapas de Fourier do bloco.
      save(caminho_dados_bloco, "Janela_probabilidades", "Mapa_fft_magnitude");
      
    endfor
    
%##########################################################################################################
  endfor
%----------------------------------------------------------------------------------------------------------
%  Fim do processamento da imagem.
endfunction