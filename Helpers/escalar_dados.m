function N_m = escalar_dados(M, min_v, max_v)

	[n d] = size(M);
    	mmax = max(M);
    	mmin = min(M);
	
	mmaxs = repmat(mmax, [n 1]);
  mmins = repmat(mmin, [n 1]);
  difs_mat = mmaxs - mmins;
  
  dif_v = max_v - min_v;
  
  N_m = (((M - mmins) .* dif_v) ./ difs_mat) + min_v;
	
end
