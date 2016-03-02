function Im = demosaic_gradient(img)
	
	Im = double(img);
	
	r_b_filter = [1/4 1/2 1/4; 1/2 1 1/2; 1/4 1/2 1/4];
	
	h = [1/2 0 -1 0 1/2];
	
	H_r = abs(conv2(Im(:, :, 1), h, 'same'));
	V_r = abs(conv2(Im(:, :, 1), h', 'same'));
	
	H_b = abs(conv2(Im(:, :, 3), h, 'same'));
	V_b = abs(conv2(Im(:, :, 3), h', 'same'));
	
	h_g = 1/2 * [1 0 1];
	H_g = 1/4 * [0 1 0; 1 0 1; 0 1 0];
	
	G_h = conv2(Im(:, :, 2), h_g, 'same');
	G_v = conv2(Im(:, :, 2), h_g', 'same');
	G_a = conv2(Im(:, :, 2), H_g, 'same');
	
	Red_m = red_mask(rows(Im), columns(Im));
	Blue_m = blue_mask(rows(Im), columns(Im));
	
	Green_c = Im(:, :, 2);
	
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
	
	Im(:, :, 1) = ((Green_c .+ (conv2((Im(:, :, 1) .- Green_c) .* Red_m, r_b_filter, 'same'))) .* !Red_m) .+ Im(:, :, 1);
	Im(:, :, 3) = ((Green_c .+ (conv2((Im(:, :, 3) .- Green_c) .* Blue_m, r_b_filter, 'same'))) .* !Blue_m) .+ Im(:, :, 3);
	Im(:, :, 2) = Green_c;
	
	Im = uint8(Im);
	
endfunction