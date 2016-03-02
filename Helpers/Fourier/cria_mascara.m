function Mascara = cria_mascara(tamanho_fft, raio, tipo = 1)
  switch tipo
  case {1}
    Shifts = tamanho_fft/2*[1 1; 1 -1; -1 1; -1 -1; 1 0; 0 1; -1 0; 0 -1];
  case {2}
    Shifts = tamanho_fft/2*[1 1; 1 -1; -1 1; -1 -1];
  otherwise
    printf("Opcao para tipo de mascara inavalida! Utilizando opcao padrao (tipo = 1) \n");
    Shifts = tamanho_fft/2*[1 1; 1 -1; -1 1; -1 -1; 1 0; 0 1; -1 0; 0 -1];
  endswitch
  
  Mascara_pontos = zeros(tamanho_fft,tamanho_fft);
  for k = 1:size(Shifts, 1)
    Mascara_pontos(Shifts(k,1)+tamanho_fft/2+1,Shifts(k,2)+tamanho_fft/2+1) = 1;
  end
  disco = strel('disk',raio);
  Mascara = imdilate(Mascara_pontos,disco);
  Mascara = Mascara(1:tamanho_fft,1:tamanho_fft);
endfunction