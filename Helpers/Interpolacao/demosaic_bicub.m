function Im = demosaic_bicub(img)
	
	r_b_filter = [-1/16 0 9/16 1 9/16 0 -1/16]' * [-1/16 0 9/16 1 9/16 0 -1/16];
	g_filter = (1/256) * [0 0 0 1 0 0 0; 
		               0 0 -9 0 -9 0 0;
		               0 -9 0 81 0 -9 0;
		               1 0 81 256 81 0 1;
		               0 -9 0 81 0 -9 0;
		               0 0 -9 0 -9 0 0;
		               0 0 0 1 0 0 0];
	
	Im = img;
	Im = double(Im);
	
	Im(:, :, 1) = conv2(Im(:, :, 1), r_b_filter, 'same');
	Im(:, :, 2) = conv2(Im(:, :, 2),g_filter, 'same');
	Im(:, :, 3) = conv2(Im(:, :, 3), r_b_filter, 'same');	
	
	Im = uint8(Im);
	
endfunction