function Mask = red_mask(matrix_row, matrix_colum)
	
	max_d =matrix_row;
	if(matrix_colum > matrix_row)
		max_d = matrix_colum;
	endif
	
	n = floor(max_d/6);
	
	patern = [1 0 1 0 1 0];
	row = patern;
	
	Mask = zeros((n+1)*6);
	
	for i = 1:n
		row = [row patern];
	endfor
	
	for i = 1:2:max_d
		Mask(i, :) = row;
	endfor
	
	Mask = Mask(1:matrix_row, 1:matrix_colum);
	
endfunction