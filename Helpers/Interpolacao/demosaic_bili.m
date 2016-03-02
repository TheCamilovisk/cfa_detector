function Im = demosaic_bili(img)
	
	r_b_filter = [1/4 1/2 1/4; 1/2 1 1/2; 1/4 1/2 1/4];
	g_filter = [0 1/4 0; 1/4 1 1/4; 0 1/4 0];
	
	Im = img;
	Im = double(Im);
	
	Im(:, :, 1) = conv2(Im(:, :, 1), r_b_filter, 'same');
	Im(:, :, 2) = conv2(Im(:, :, 2),g_filter, 'same');
	Im(:, :, 3) = conv2(Im(:, :, 3), r_b_filter, 'same');	
	
	Im = uint8(Im);
	
endfunction