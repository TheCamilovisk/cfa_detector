function I = limpa_imagem(Img);
	%Filtro binomial 3X3.
	F = [1, 3, 3, 1];
	F = F' * F / 64;
  I = [Img(1:end, 1, :) Img Img(1:end, end, :)];
  I = [I(1, 1:end, :); I; I(end, 1:end, :)];
	%Aplica o filtro;
	I = imfilter(I, F);
  #Gera a imagem de sada.
	D = uint8(zeros(size(I)/2));
	for i = 1:3
		T = I(:, :, i);
		T = downsample(T', 2);
		T = downsample(T', 2);
		D(:, :, i) = T;
	endfor
  I = D(2:end, 2:end, :);
endfunction
