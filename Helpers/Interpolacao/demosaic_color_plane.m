function Im = demosaic_color_plane(img)
	
	Im = double(img);
	
	h1 = [1 0 -1];
	h2 = [1 0 1];
	h3 = [-1 0 2 0 -1];
	h4 = [-1 2 -1];
	
	v1 = [1; 0; -1];
	v2 = [1; 0; 1];
	v3 = [-1; 0; 2; 0; -1];
	v4 = [-1; 2; -1];
	
	d1_1 = [1 0 0; 0 0 0; 0 0 -1];
	d1_2 = [1 0 0; 0 0 0; 0 0 1];
	d1_3 = [-1 0 0; 0 2 0; 0 0 -1];
	
	d2_1 = [0 0 1; 0 0 0; -1 0 0];
	d2_2 = [0 0 1; 0 0 0; 1 0 0];
	d2_3 = [0 0 -1; 0 2 0; -1 0 0];
	
	a1 = 1/4*[0 1 0; 1 0 1; 0 1 0];
	a2 = 1/8*[0 0 -1 0 0; 0 0 0 0 0; -1 0 4 0 -1; 0 0 0 0 0; 0 0 -1 0 0];
	
	d_a1 = 1/4*[1 0 1; 0 0 0; 1 0 1];
	d_a2 = 1/4*[-1 0 -1; 0 4 0; -1 0 -1];
	
	Red_m = red_mask(rows(Im), columns(Im));
	Green_m = green_mask(rows(Im), columns(Im));
	Blue_m = blue_mask(rows(Im), columns(Im));
	
	Red_c = Im(:, :, 1);
	Green_c = Im(:, :, 2);
	Blue_c = Im(:, :, 3);
	
	H_r = abs(conv2(Im(:, :, 2), h1, 'same') .* Red_m)  .+ abs(conv2(Im(:, :, 1), h3, 'same'));
	V_r = abs(conv2(Im(:, :, 2), v1, 'same') .* Red_m) .+ abs(conv2(Im(:, :, 1), v3, 'same'));
	
	H_b = abs(conv2(Im(:, :, 2), h1, 'same') .* Blue_m) .+ abs(conv2(Im(:, :, 3), h3, 'same'));
	V_b = abs(conv2(Im(:, :, 2), v1, 'same') .* Blue_m) .+ abs(conv2(Im(:, :, 3), v3, 'same'));
	
	G_h = conv2(Im(:, :, 2), (1/2) * h2, 'same') .+ conv2(Im(:, :, 1), (1/4) * h3, 'same') .+ conv2(Im(:, :, 3), (1/4) * h3, 'same');
	G_v = conv2(Im(:, :, 2), (1/2) * v2, 'same') .+ conv2(Im(:, :, 1), (1/4) * v3, 'same') .+ conv2(Im(:, :, 3), (1/4) * v3, 'same');
	G_a = conv2(Im(:, :, 2), a1, 'same') .+ conv2(Im(:, :, 1), a2, 'same') .+ conv2(Im(:, :, 3), a2, 'same');
	
	for i = 1:rows(Im)
		for j = 1:columns(Im)
			if(Red_m(i, j))
				if(H_r(i, j) < V_r(i, j))
					Green_c(i, j) = G_h(i, j);
				elseif(H_r(i, j) > V_r(i, j))
					Green_c(i, j) = G_v(i, j);
				else
					Green_c(i, j) = G_a(i, j);
				endif
			elseif(Blue_m(i, j))
				if(H_b(i, j) < V_b(i, j))
					Green_c(i, j) = G_h(i, j);
				elseif(H_b(i, j) > V_b(i, j))
					Green_c(i, j) = G_v(i, j);
				else
					Green_c(i, j) = G_a(i, j);
				endif
			endif
		endfor
	endfor
	
	Green_d_h = conv2(Green_c, (1/2) * h4, 'same');
	Green_d_v = conv2(Green_c, (1/2) * v4, 'same');
	
	Red_d_h = conv2(Im(:, :, 1), (1/2) * h2, 'same');
	Blue_d_h = conv2(Im(:, :, 3), (1/2) * h2, 'same');
	
	Red_d_v = conv2(Im(:, :, 1), (1/2) * v2, 'same');
	Blue_d_v = conv2(Im(:, :, 3), (1/2) * v2, 'same');
	
	change = false;
	
	for i = 1:rows(Im)
		if(!change)
			Red_c(i, :) = Red_d_h(i, :) .+ Green_d_h(i, :) ;
			Blue_c(i, :) = Blue_d_v(i, :) .+ Green_d_v(i, :);
		else
			Red_c(i, :) = Red_d_v(i, :) .+ Green_d_v(i, :);
			Blue_c(i, :) = Blue_d_h(i, :) .+ Green_d_h(i, :);
		endif
		
		change = !change;
	endfor
	
	D1_r = abs(conv2(Im(:, :, 1), d1_1, 'same')) .+ (abs(conv2(Green_c, d1_3, 'same')) .* Blue_m);
	D2_r = abs(conv2(Im(:, :, 1), d2_1, 'same')) .+ (abs(conv2(Green_c, d2_3, 'same')) .* Blue_m);
	
	D1_b = abs(conv2(Im(:, :, 3), d1_1, 'same')) .+ (abs(conv2(Green_c, d1_3, 'same')) .* Red_m);
	D2_b = abs(conv2(Im(:, :, 3), d2_1, 'same')) .+ (abs(conv2(Green_c, d2_3, 'same')) .* Red_m);
	
	R_b_d1 = conv2(Green_c, (1/2) * d1_3, 'same') .+ conv2(Im(:, :, 1), (1/2) * d1_2, 'same') .+ conv2(Im(:, :, 3), (1/2) * d1_2, 'same');
	R_b_d2 = conv2(Green_c, (1/2) * d2_3, 'same') .+ conv2(Im(:, :, 1), (1/2) * d2_2, 'same') .+ conv2(Im(:, :, 3), (1/2) * d2_2, 'same');
	R_b_a = conv2(Green_c, d_a2, 'same') .+ conv2(Im(:, :, 1), d_a1, 'same') .+ conv2(Im(:, :, 3), d_a1, 'same');
	
	for i = 1:rows(Im)
		for j = 1:columns(Im)
			if(Red_m(i, j))
				if(D1_b(i, j) < D2_b(i, j))
					Blue_c(i, j) = R_b_d1(i, j);
				elseif(D1_b(i, j) > D2_b(i, j))
					Blue_c(i, j) = R_b_d2(i, j);
				else
					Blue_c(i, j) = R_b_a(i, j);
				endif
			elseif(Blue_m(i, j))
				if(D1_r(i, j) < D2_r(i, j))
					Red_c(i, j) = R_b_d1(i, j);
				elseif(D1_r(i, j) > D2_r(i, j))
					Red_c(i, j) = R_b_d2(i, j);
				else
					Red_c(i, j) = R_b_a(i, j);
				endif
			endif
		endfor
	endfor
	
	Im(:, :, 1) = Im(:, :, 1) .+ Red_c ;
	Im(:, :, 2) = Green_c;
	Im(:, :, 3) = Im(:, :, 3) .+ Blue_c ;
	
	Im = uint8(Im);
	
endfunction