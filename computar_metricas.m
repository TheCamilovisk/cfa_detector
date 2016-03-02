function Metricas = computar_metricas(Img, str_img, tipo_bloco = 2)

%  Matriz de metricas.
  Metricas = [];
  
%  Processamento da imagem.
  [Coeficientes Fs_vermelho Fs_verde Fs_azul] = processar_imagem(Img, str_img, tipo_bloco);
  
  tamanho_ffts = size(Fs_vermelho, 1);
  n_ffts = size(Fs_vermelho, 3);
  
  raio = 3;
  switch tipo_bloco
    case {512}
      raio = 10;
  endswitch
  
  Mascaras = repmat(cria_mascara(tamanho_ffts, raio, 1), [1 1 n_ffts]);
  Mascaras2 = repmat(cria_mascara(tamanho_ffts, raio, 2), [1 1 n_ffts]);
  
%--------------------------------------------------------------------------------------------------------
  
%  Aplica a operacao de AND antre o mapas obtidos e a mascara.
  Fs_vermelho_amostrado = Fs_vermelho .* Mascaras;
  Fs_verde_amostrado = Fs_verde .* Mascaras2;
  Fs_azul_amostrado = Fs_azul .* Mascaras;
  
%  Energias totais dos mapas.
  Energias_totais_vermelho = squeeze(sum(sum(Fs_vermelho)));
  Energias_totais_verde = squeeze(sum(sum(Fs_verde)));
  Energias_totais_azul = squeeze(sum(sum(Fs_azul)));

%  Energias das frequencias amostradas.
  Energias_amostradas_vermelho = squeeze(sum(sum(Fs_vermelho_amostrado)));
  Energias_amostradas_verde = squeeze(sum(sum(Fs_verde_amostrado)));
  Energias_amostradas_azul = squeeze(sum(sum(Fs_azul_amostrado)));
  
%--------------------------------------------------------------------------------------------------------
  
%  Medidas do quanto a energia dos mapas amostrados contribui para a energia total dos mapas.
  p_vermelho = Energias_amostradas_vermelho ./ Energias_totais_vermelho;
  p_verde = Energias_amostradas_verde ./ Energias_totais_verde;
  p_azul = Energias_amostradas_azul ./ Energias_totais_azul;
  
%  Concatena as metricas a matriz de metricas.
  Metricas = cat(2, Metricas, p_vermelho, p_verde, p_azul);
  
%--------------------------------------------------------------------------------------------------------
  
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

  vars_fs_vermelho = var(Vecs_fs_vermelho)';
  vars_fs_verde = var(Vecs_fs_verde)';
  vars_fs_azul = var(Vecs_fs_azul)';
  
  Metricas = cat(2, Metricas, vars_fs_vermelho, vars_fs_verde, vars_fs_azul);
  
%--------------------------------------------------------------------------------------------------------

%  stds_fs_vermelho = std(Vecs_fs_vermelho)';
%  stds_fs_verde = std(Vecs_fs_verde)';
%  stds_fs_azul = std(Vecs_fs_azul)';
%  
%  Metricas = cat(2, Metricas, stds_fs_vermelho, stds_fs_verde, stds_fs_azul);

endfunction