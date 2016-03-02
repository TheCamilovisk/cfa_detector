function Mapa_fft_magnitude = fourier_magnitude(Probabilidades)

%	Variavel utilizada para armazenar as transformadas de fourier de cada mapa de probabilidades.
%	Mapa_fft = zeros(size(Probabilidades));
	
%	Filtro passa-altas.
%	Aplica um limiar em cada canal para evitar muitas frequências altas.
%	Aplica um filtro passa-altas para acentuar as frequências mais altas.
%	h = [
%		0 -1 0
%		-1 4 -1
%		0 -1 0
%	];
	
%	 wnd_probs_f = imfilter(wnd_probs, h);
	
%	Mapas de Fourier de cada canal de cor das probabilidades.
	Mapa_fft = fft2(Probabilidades);
	
%	Magnitude do mapa de Fourier.
%	Foi aplicada a correção gamma;
%	 gamma = 2;
%	 maxs = max( max(fft_map) );
%	 maxs = repmat(maxs, [size(wnd_probs, 1) size(wnd_probs, 1) 1]);
%	 fft_map = ((fft_map ./ maxs) .^gamma) .* maxs;
	Mapa_fft_magnitude = abs( fftshift(Mapa_fft) );
  
%	Filtro de Hann.
	h = hanning(size(Mapa_fft_magnitude, 1));
  H = 1 - (h * h');
  Mapa_fft_magnitude = Mapa_fft_magnitude .* H;

%	Filtro passa-altas gaussiano, para atenuar as frequencias centrais.
%	 hp = hpf( size(wnd_probs, 1) );
%	 fft_magnitude = fft_magnitude .* hp;
	
endfunction
