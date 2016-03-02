function Nova_img = reinterpola_imagem(Img, str_tipo_interpolacao)
  I = [Img(1:end, 1, :) Img Img(1:end, end, :)];
  I = [I(1, 1:end, :); I; I(end, 1:end, :)];
  B = bayer(I);
  Nova_img = zeros(size(B));
  clear I
  switch (str_tipo_interpolacao)
    case "Bilinear"
      Nova_img = demosaic_bili(B);
    case "Bicubica"
      Nova_img = demosaic_bicub(B);
    case "Mediana"
      Nova_img = demosaic_median(B);
    case "Baseada_Gradiente"
      Nova_img = demosaic_gradient(B);
    case "Transicao_Saturacao"
      Nova_img = demosaic_smooth(B);
    case "Plano_Cor"
      Nova_img = demosaic_color_plane(B);
    otherwise
      printf("Erro!!!! Opcao de interpolacao invalida!!!\n");
  endswitch
  Nova_img = Nova_img(2:(end-1), 2:(end-1), :);
endfunction