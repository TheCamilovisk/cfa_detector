function Mask = green_mask(matrix_row, matrix_colum)
	
	max_d =matrix_row;
	if(matrix_colum > matrix_row)
		max_d = matrix_colum;
	endif
	
	n = floor(max_d/6);
	
	patern = [0 1 0 1 0 1];
	row = patern;
	
	Mask = zeros((n+1)*6);
	
	for i = 1:n
		row = [row patern];
	endfor
	
	for i = 1:max_d
		Mask(i, :) = row;
		row = shift(row, 1);
	endfor
	
	Mask = Mask(1:matrix_row, 1:matrix_colum);
	
endfunction