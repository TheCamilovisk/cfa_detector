function Mapa_fft_magnitude_display = fourier_magnitude_display(Probabilidades)

	% Varável utilizada para armazenar o mapa de probabilidades depois de ter sofrido upsample.
	ds = size(Probabilidades);
	Probabilidades_up = zeros(2*ds);
	
	%Variavel utilizada para armazenar a transformada de fourier do mapa de probabilidades.
	Mapa_fft = zeros(size(Probabilidades_up));
  Mapa_fft_magnitude_display = zeros(size(Probabilidades_up));
	
	% Realiza o umpsample nos mapas de probabilidade de cada canal.
	Probabilidades_up = upsample(Probabilidades',2);
	Probabilidades_up = upsample(Probabilidades_up',2);
	
	%Filtro passa-altas.
	%Aplica um limiar em cada canal para evitar muitas frequências altas.
	%Aplica um filtro passa-altas para acentuar as frequências mais altas.
%	h = [
%		0 -1 0
%		-1 4 -1
%		0 -1 0
%	];
	
	% wnd_probs_up_f = imfilter(wnd_probs_up, h);
	
	%Mapas de Fourier.
	Mapa_fft = fft2(Probabilidades_up);
	
	% Magnitude do mapa de Fourier.
	% Foi aplicada a correção gamma;
%	gamma = 2;
%	maxs = max( max(Mapa_fft) );
%	maxs = repmat(maxs, [size(Probabilidades_up, 1) size(Probabilidades_up, 1) 1]);
%	Mapa_fft = ((Mapa_fft ./ maxs) .^gamma) .* maxs;
  
	Mapa_fft_magnitude_display = abs( fftshift(Mapa_fft) );
	
	% Retorna os mapas com dimensões um pouco maiores do que os mapas de probabilidade.
	% Melhora a visualização das frequencias mais interessantes ao nosso estudo.
	dims = (ds - (ds/2 + 10)):(ds + (ds/2 + 9));
	Mapa_fft_magnitude_display = Mapa_fft_magnitude_display(dims, dims);
  
	%Filtro de Hann.
  h = hanning(size(Mapa_fft_magnitude_display, 1));
  H = 1 - (h * h');
  Mapa_fft_magnitude_display = Mapa_fft_magnitude_display .* H;

	%Filtro passa-altas gaussiano, para atenuar as frequencias centrais.
	% hp = hpf( size(wnd_probs, 1) );
	% fft_magnitude = fft_magnitude .* hp;
	
endfunction
