tamanho_f = size(interpolacao_final, 1);
linhas_a_serem_eliminadas = [];
cont = 0;
for i = 1:tamanho_f
  r = find(isnan(interpolacao_final(i, :)));
	[nr nc] = size(r);
  if(nc > 0)
    cont++;
    linhas_a_serem_eliminadas(cont) = i;
  endif
endfor
interpolacao_final(linhas_a_serem_eliminadas, :) = [];