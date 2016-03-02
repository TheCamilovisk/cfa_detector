function M = ajusta_escala(M, min_v, max_v)
	
	[n d] = size(M);
    	mmax = max(M(:));
    	mmin = min(M(:));
	
	for i = 1:d
    	M(:, i) = (M(:,i)-mmin)*(max_v-min_v)/(mmax-mmin)+min_v;
	end 
	
end
