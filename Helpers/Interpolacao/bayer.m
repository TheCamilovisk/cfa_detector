function Mosaico= bayer(Img)
	
	Mosaico= double(Img);
	
	n_linhas = rows(Mosaico);
	
	n_colunas = columns(Mosaico);
	
	Red_m = red_mask(n_linhas, n_colunas);	
	Blue_m = blue_mask(n_linhas, n_colunas);	
	Green_m = green_mask(n_linhas, n_colunas);
	
	Mosaico(:, :, 1) = Mosaico(:, :, 1) .* Red_m;
	Mosaico(:, :, 2) = Mosaico(:, :, 2) .* Green_m;
	Mosaico(:, :, 3) = Mosaico(:, :, 3) .* Blue_m;
	
	Mosaico= uint8(Mosaico);
	
endfunction