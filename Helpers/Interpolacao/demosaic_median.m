function Im = demosaic_median(img)
	
	Im = double(demosaic_bili(img));
	
	M_r_g = medfilt2(Im(:, :, 1) .- Im(:, :, 2));
	M_g_b = medfilt2(Im(:, :, 2) .- Im(:, :, 3));
	M_r_b = medfilt2(Im(:, :, 1) .- Im(:, :, 3));
	
	Red_m = red_mask(rows(Im), columns(Im));
	Green_m = green_mask(rows(Im), columns(Im));
	Blue_m = blue_mask(rows(Im), columns(Im));
	
	Red_c = (img(:, :, 2) .+ (M_r_g .* Green_m)) .+ (img(:, :, 3) .+ (M_r_b .* Blue_m)) .+ img(:, :, 1);
	Green_c = (img(:, :, 1) .- (M_r_g .* Red_m)) .+ (img(:, :, 3) .+ (M_g_b .* Blue_m)) .+ img(:, :, 2);
	Blue_c = (img(:, :, 1) .- (M_r_b .* Red_m)) .+ (img(:, :, 2) .- (M_g_b .* Green_m)) .+ img(:, :, 3);
  
	
	Im(:, :, 1) = Red_c;
	Im(:, :, 2) = Green_c;
	Im(:, :, 3) = Blue_c;
	
	Im = uint8(Im);
	
endfunction